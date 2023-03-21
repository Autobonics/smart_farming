import 'package:firebase_database/firebase_database.dart';
import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';
import '../models/models.dart';

class DbService with ReactiveServiceMixin {
  final log = getLogger('RealTimeDB_Service');

  FirebaseDatabase _db = FirebaseDatabase.instance;

  DeviceData? _node;
  DeviceData? get node => _node;

  void setupNodeListening() {
    DatabaseReference starCountRef =
        _db.ref('/devices/JwwLVYtb6INTTmbLj8FTTcIGM9P2/reading');
    starCountRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        _node = DeviceData.fromMap(event.snapshot.value as Map);
        // log.v(_node?.lastSeen); //data['time']
        notifyListeners();
      }
    });
  }

  Future<DeviceLedData?> getLedData() async {
    DatabaseReference dataRef =
        _db.ref('/devices/JwwLVYtb6INTTmbLj8FTTcIGM9P2/data');
    final value = await dataRef.once();
    if (value.snapshot.exists) {
      return DeviceLedData.fromMap(value.snapshot.value as Map);
    }
    return null;
  }

  void setDeviceData({required String led, required int value}) {
    log.i("Led path: ${led} is $value");
    DatabaseReference dataRef =
        _db.ref('/devices/JwwLVYtb6INTTmbLj8FTTcIGM9P2/data');
    dataRef.set({led: value});
  }
}
