import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../models/soil.dart';
import '../../../services/firestore_service.dart';

class SoilViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');
  final _firestoreService = locator<FirestoreService>();

  List<Soil>? _soils = [];

  List<Soil>? get soils => _soils;

  Future<void> fetchSoils() async {
    setBusy(true);
    _soils = await _firestoreService.fetchSoils();
    setBusy(false);
  }
}
