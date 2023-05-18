import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../app/constants/app_keys.dart';
import '../models/appuser.dart';
import '../models/soil.dart';

class FirestoreService {
  final log = getLogger('FirestoreApi');
  // final _authenticationService = locator<FirebaseAuthenticationService>();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(UsersFirestoreKey);
  final CollectionReference _soilsCollection =
      FirebaseFirestore.instance.collection(SoilsFirestoreKey);

  Future<bool> createUser({required AppUser user, required keyword}) async {
    log.i('user:$user');
    try {
      final userDocument = _usersCollection.doc(user.id);
      await userDocument.set(user.toJson(keyword), SetOptions(merge: true));
      log.v('UserCreated at ${userDocument.path}');
      return true;
    } catch (error) {
      log.e("Error $error");
      return false;
    }
  }

  Future<AppUser?> getUser({required String userId}) async {
    log.i('userId:$userId');

    if (userId.isNotEmpty) {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        log.v('We have no user with id $userId in our database');
        return null;
      }

      final userData = userDoc.data();
      log.v('User found. Data: $userData');

      return AppUser.fromMap(userData! as Map<String, dynamic>);
    } else {
      log.e("Error no user");
      return null;
    }
  }

  Future<List<AppUser>> searchUsers(String keyword) async {
    log.i("searching for $keyword");
    final query = _usersCollection
        .where('keyword', arrayContains: keyword.toLowerCase())
        .limit(5);

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => AppUser.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Soil>?> fetchSoils() async {
    try {
      final QuerySnapshot querySnapshot = await _soilsCollection.get();

      final f = querySnapshot.docs.map((doc) {
        log.i("Soils: ${doc.exists}");
        return Soil.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return f;
    } catch (e) {
      // Handle error
      log.e(e);
      return null;
    }
  }
}
