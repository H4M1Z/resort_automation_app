class DeviceGroup {
  final String groupId;
  final String groupName;
  final List<String> deviceIds;
  final bool currentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeviceGroup({
    required this.currentStatus,
    required this.groupId,
    required this.groupName,
    required this.deviceIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceGroup.fromJson(Map<String, dynamic> json) {
    return DeviceGroup(
      currentStatus: json['currentStatus'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      deviceIds: List<String>.from(json['deviceIds']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStatus': currentStatus,
      'groupId': groupId,
      'groupName': groupName,
      'deviceIds': deviceIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
