import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/device_group_collection.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';
import 'package:home_automation_app/main.dart';

final groupDevicesPageStateProvider =
    NotifierProvider<GroupDeviceButtonController, GroupDeviceButtonStates>(
        GroupDeviceButtonController.new);

class GroupDeviceButtonController extends Notifier<GroupDeviceButtonStates> {
  DeviceGroupCollection deviceGroupCollection = DeviceGroupCollection();
  DeviceCollection deviceCollection = DeviceCollection();
  @override
  GroupDeviceButtonStates build() {
    return GroupDeviceButtonInitialState();
  }

  Future<void> onDevicesButtonClick(String groupId) async {
    state = GroupDeviceButtonLoadingState();
    //Firstly we have get Ids of this group
    try {
      DeviceGroup? deviceGroup =
          await deviceGroupCollection.getDeviceGroup(globalUserId, groupId);
      if (deviceGroup != null) {
        List<String> deviceIds = deviceGroup.deviceIds;
        var listOfDevices =
            await deviceCollection.getDevicesByIds(globalUserId, deviceIds);
        state = GroupDeviceButtonLoadedState(listOfDevices: listOfDevices);
      }
    } catch (e) {
      log("Error in fetching devices list onDevicesButtonClick method: ${e.toString()}");
      state = GroupDeviceButtonErrorState(error: e.toString());
    }
  }

  Future<void> removeDeviceIdFromGroup(String groupId, int index) async {
    try {
      await deviceGroupCollection.removeDeviceIdFromGroup(
          userId: globalUserId, groupId: groupId, index: index);
    } catch (e) {
      log("Error in removing device id from group: ${e.toString()}");
    }
  }
}

abstract class GroupDeviceButtonStates {
  const GroupDeviceButtonStates();
}

class GroupDeviceButtonInitialState extends GroupDeviceButtonStates {}

class GroupDeviceButtonLoadingState extends GroupDeviceButtonStates {}

class GroupDeviceButtonLoadedState extends GroupDeviceButtonStates {
  final List<Device> listOfDevices;
  GroupDeviceButtonLoadedState({required this.listOfDevices});
}

class GroupDeviceButtonErrorState extends GroupDeviceButtonStates {
  final String error;
  const GroupDeviceButtonErrorState({required this.error});
}
