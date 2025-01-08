import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/device_group_collection.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_switch_togle.dart';

final deviceGroupsProvider =
    NotifierProvider<GroupStateController, DeviceGroupStates>(
        GroupStateController.new);

class GroupStateController extends Notifier<DeviceGroupStates> {
  DeviceCollection deviceCollection = DeviceCollection();
  DeviceGroupCollection deviceGroupCollection = DeviceGroupCollection();
  @override
  DeviceGroupStates build() {
    return DeviceGroupInitalState();
  }

  Future<void> getAllDeviceGroups() async {
    log("device groups called");
    state = DeviceGroupLoadingState();
    try {
      var list = await deviceGroupCollection.getAllDeviceGroups(globalUserId);
      if (list.isNotEmpty) {
        for (var group in list) {
          ref
              .read(groupSwitchTogleProvider.notifier)
              .mapOfGroupSwitchStates[group.groupId] = group.currentStatus;
        }
      }

      state = DeviceGroupLoadedState(list: list);
      log("Group loaded state ");
    } catch (e) {
      state = DeviceGroupErrorState(error: e.toString());
      log("Error in getting device groups ${e.toString()}");
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      await deviceGroupCollection.deleteDeviceGroup(globalUserId, groupId);
    } catch (e) {
      log("Error in deleting group ${e.toString()}");
    }
  }
}

abstract class DeviceGroupStates {
  const DeviceGroupStates();
}

class DeviceGroupInitalState extends DeviceGroupStates {}

class DeviceGroupLoadingState extends DeviceGroupStates {}

class DeviceGroupLoadedState extends DeviceGroupStates {
  final List<DeviceGroup> list;
  const DeviceGroupLoadedState({required this.list});
}

class DeviceGroupErrorState extends DeviceGroupStates {
  final String error;
  const DeviceGroupErrorState({required this.error});
}
