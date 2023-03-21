/// Institution model
class DeviceData {
  int s1;
  int s2;
  int s3;
  int s4;
  int s5;
  DateTime lastSeen;

  DeviceData({
    required this.s1,
    required this.s2,
    required this.s3,
    required this.s4,
    required this.s5,
    required this.lastSeen,
  });

  factory DeviceData.fromMap(Map data) {
    return DeviceData(
      s1: data['s1'] ?? 0,
      s2: data['s2'] ?? 0,
      s3: data['s3'] ?? 0,
      s4: data['s4'] ?? 0,
      s5: data['s5'] ?? 0,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(data['ts']),
    );
  }
}

class DeviceLedData {
  List<int> leds;

  DeviceLedData({
    required this.leds,
  });

  factory DeviceLedData.fromMap(Map data) {
    return DeviceLedData(
      leds: [
        data['l1'] ?? 0,
        data['l2'] ?? 0,
        data['l3'] ?? 0,
        data['l4'] ?? 0,
        data['l5'] ?? 0,
      ],
    );
  }
}
