import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/device_group_collection.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/providers/device_state_change_provider.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

final groupSwitchTogleProvider =
    NotifierProvider<GroupSwitchTogle, bool>(GroupSwitchTogle.new);

class GroupSwitchTogle extends Notifier<bool> {
  DeviceCollection deviceCollection = DeviceCollection();
  DeviceGroupCollection deviceGroupCollection = DeviceGroupCollection();
  bool isGroupSwitchOn = false;
  Map<String, bool> mapOfGroupSwitchStates = {};

  @override
  bool build() {
    return isGroupSwitchOn;
  }

  void intialGroupSwitchState(bool value) {
    state = value;
  }

  void onGroupSwitchToggle(bool value, String groupName, String groupId) async {
    try {
      // Step 1: Get the Device Group
      DeviceGroup? group = await deviceGroupCollection.getDeviceGroupByName(
          globalUserId, groupName);

      if (group != null) {
        var listOfDeviceIds = group.deviceIds;

        // Step 2: Fetch Devices by IDs
        List<Device> devices = await deviceCollection.getDevicesByIds(
            globalUserId, listOfDeviceIds);

        // Step 3: Update Devices
        for (var device in devices) {
          // Example: Toggle the status or make any other updates
          bool currentDevicestatus =
              GerenrateNumberFromHexa.hexaIntoStringAccordingToDeviceType(
                          device.type, device.status) ==
                      "On"
                  ? true
                  : false;
          //Update only if the status is different
          if (currentDevicestatus != value) {
            String action = value ? "On" : "Off";
            String getHexa = getCommand(device.type, action);
            await deviceCollection.updateDeviceStatus(
                globalUserId, device.deviceId, getHexa);
          }
        }
        await deviceGroupCollection.updateGroupStatus(group.groupId, value);
        mapOfGroupSwitchStates[groupId] = value;
        state = value;

        log("All devices in group '$groupName' updated successfully.");
      } else {
        log("Device group '$groupName' not found.");
      }
    } catch (e) {
      log("Error toggling group devices: $e");
    }
  }
}
