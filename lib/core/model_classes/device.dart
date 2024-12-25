class Device {
  final String deviceId;
  final String deviceName;
  final String type;
  final String status;
  final String? group;
  final Map<String, dynamic> attributes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.type,
    required this.status,
    this.group,
    required this.attributes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      type: json['type'],
      status: json['status'],
      group: json['group'],
      attributes: json['attributes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'type': type,
      'status': status,
      'group': group,
      'attributes': attributes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
