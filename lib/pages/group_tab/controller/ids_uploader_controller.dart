import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/device_group_collection.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';
import 'package:home_automation_app/main.dart';

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
  build() {
    _initializeBooleanList();
    return booleanList;
  }

  Future<void> _initializeBooleanList() async {
    var listOfDevices = await deviceCollection.getAllDevices(globalUserId);
    booleanList = List.filled(listOfDevices.length, false);
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

  void onCreateGroupButtonClick() async {
    if (groupNameController.text.isEmpty) {
      // Optionally, show an error message if group name is empty
      return;
    }

    var listOfGroups =
        await deviceGroupCollection.getAllDeviceGroups(globalUserId);

    DeviceGroup group = DeviceGroup(
      createdAt: DateTime.now(),
      currentStatus: false,
      deviceIds: listOfIds,
      groupId: "0${listOfGroups.length + 1} ${groupNameController.text}",
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
}
