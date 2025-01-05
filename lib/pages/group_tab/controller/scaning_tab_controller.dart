import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/main.dart';

final scannedDeviceProvider =
    NotifierProvider<ScanningTabController, DeviceGettingStates>(
        ScanningTabController.new);

class ScanningTabController extends Notifier<DeviceGettingStates> {
  DeviceCollection deviceCollection = DeviceCollection();
  @override
  DeviceGettingStates build() {
    return DeviceGettingInitalState();
  }

  void onClickAddDevices(WidgetRef ref) async {
    state = DeviceGettingLoadingState();
    try {
      var listOfDevices = await deviceCollection.getAllDevices(globalUserId);
      state = DeviceGettingLoadedState(list: listOfDevices);
    } catch (e) {
      state = DeviceGettingErrorState(error: e.toString());
      log("Error getting all devices for the scanning tab: ${e.toString()}");
    }
  }
}

abstract class DeviceGettingStates {
  const DeviceGettingStates();
}

class DeviceGettingInitalState extends DeviceGettingStates {}

class DeviceGettingLoadingState extends DeviceGettingStates {}

class DeviceGettingLoadedState extends DeviceGettingStates {
  final List<Device> list;
  const DeviceGettingLoadedState({required this.list});
}

class DeviceGettingErrorState extends DeviceGettingStates {
  final String error;
  const DeviceGettingErrorState({required this.error});
}
