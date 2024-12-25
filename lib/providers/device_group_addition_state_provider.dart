import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/device_group_collection.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';

class DeviceGroupAdditionStateProvider extends ChangeNotifier {
  DeviceGroupCollection deviceGroupCollection = DeviceGroupCollection();

  void addDeviceGroup() async {
    DeviceGroup deviceGroup = DeviceGroup(
        groupId: "g1",
        groupName: "group1",
        deviceIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    await deviceGroupCollection.addDeviceGroup(
        userId: "user1", group: deviceGroup);
    notifyListeners();
  }
}
