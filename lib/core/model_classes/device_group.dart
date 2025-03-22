import 'package:resort_automation_app/core/model_classes/device.dart'
    show Device;

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DeviceGroup {
  final String roomNumber;
  final List<Device>? devices;
  final bool groupStatus;
  const DeviceGroup({
    required this.roomNumber,
    this.devices,
    required this.groupStatus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roomNumber': roomNumber,
      'devices': devices!.map((x) => x.toJson()).toList(),
      'groupStatus': groupStatus,
    };
  }

  factory DeviceGroup.fromMap(Map<String, dynamic> map) {
    return DeviceGroup(
      roomNumber: map['roomNumber'] ?? '',
      devices: map['devices'] != null
          ? List<Device>.from(
              (map['devices'] as List<Map<String, dynamic>>).map<Device?>(
                (x) => Device.fromJson(x),
              ),
            )
          : null,
      groupStatus: map['groupValue'] ?? false,
    );
  }
}
