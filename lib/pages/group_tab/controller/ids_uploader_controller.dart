import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/device_group_collection.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_state_controller.dart';

final idsUploadStateProvider =
    NotifierProvider<IdsUploaderController, List<bool>>(
        IdsUploaderController.new);

class IdsUploaderController extends Notifier<List<bool>> {
  List<bool> booleanList = [];
  DeviceCollection deviceCollection = DeviceCollection();
  TextEditingController groupNameController = TextEditingController();
  DeviceGroupCollection deviceGroupCollection = DeviceGroupCollection();
  List<String> listOfIds = [];

  @override
  List<bool> build() {
    ref.onDispose(
      () {
        groupNameController.dispose();
      },
    );
    return booleanList;
  }

  Future<void> initializeBooleanList() async {
    var listOfDevices = await deviceCollection.getAllDevices(globalUserId);
    booleanList = List.filled(listOfDevices.length, false);
    log("Bolean List ${booleanList.length}");
    state = booleanList;
  }

  void onDeviceSelection(int index, String deviceId) {
    booleanList[index] = !booleanList[index];
    if (booleanList[index]) {
      listOfIds.add(deviceId);
    } else {
      listOfIds.remove(deviceId);
    }
    state = List.from(booleanList); // Update state to reflect changes
  }

  Future<void> onCreateGroupButtonClick(WidgetRef ref) async {
    if (groupNameController.text.isEmpty) {
      // Optionally, show an error message if group name is empty
      return;
    }

    var listOfGroups =
        await deviceGroupCollection.getAllDeviceGroups(globalUserId);
    var groupId =
        "${listOfGroups[listOfGroups.length - 1].groupId} ${groupNameController.text}";
    DeviceGroup group = DeviceGroup(
      createdAt: DateTime.now(),
      currentStatus: false,
      deviceIds: listOfIds,
      groupId: groupId,
      groupName: groupNameController.text,
      updatedAt: DateTime.now(),
    );

    await deviceGroupCollection.addDeviceGroup(
        userId: globalUserId, group: group);

    // Clear data after creating a group
    listOfIds.clear();
    booleanList = List.filled(booleanList.length, false);
    state = booleanList;
  }

  void clearGroupController() {
    groupNameController.clear();
  }
}
