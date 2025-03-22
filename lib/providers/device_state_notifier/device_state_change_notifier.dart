// Through Riverpod
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/model_classes/device.dart';
import 'package:resort_automation_app/core/protocol/Firestore_mqtt_Bridge.dart';
import 'package:resort_automation_app/core/protocol/mqt_service.dart';
import 'package:resort_automation_app/providers/device_state_change_provider.dart';
import 'package:resort_automation_app/providers/device_state_notifier/device_states.dart';
import 'package:resort_automation_app/providers/device_state_notifier/firebase_services.dart';
import 'package:resort_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/control_tab/controllers/switch_state_controller.dart';
import '../../utils/hexa_into_number.dart';

final deviceStateProvider =
    NotifierProvider<DeviceStateChangeNotifier, DeviceDataStates>(
        DeviceStateChangeNotifier.new);

class DeviceStateChangeNotifier extends Notifier<DeviceDataStates> {
  final MqttService mqttService = MqttService();
  // final DeviceCollection deviceCollection = DeviceCollection.instance;
  final FirebaseServices firebaseService = FirebaseServices();
  //Controllers for adding new devices
  final Map<String, TextEditingController> controllers = {};
  @override
  DeviceDataStates build() {
    return DeviceDataInitialState();
  }

  showDevices() {
    state = DevicesDataCodeScannedState();
  }

  listenToRoom() {
    final sharedpref = serviceLocator.get<SharedPreferences>();
    return firebaseService
        .listenToRoom(sharedpref.getString(SharedPrefKeys.kUserRoomNo)!);
  }

  listenToDevices() {
    final sharedPref = serviceLocator.get<SharedPreferences>();
    return firebaseService
        .listenToDevices(sharedPref.getString(SharedPrefKeys.kUserRoomNo)!);
  }

  // When the switch is toggeled
  void toggleSwitch(bool value, Device device, BuildContext context) async {
    if (!mqttService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          content: Text("MQTT is not connected. Cannot send the command.")));
      log('MQTT is not connected. Cannot send the command.');
      return;
    }

    final sharedPref = serviceLocator.get<SharedPreferences>();
    final roomNo =
        sharedPref.getString(SharedPrefKeys.kUserRoomNo) ?? 'Room No. 1';

    // showProgressDialog(
    //     context: context,
    //     message: "Turning ${device.deviceName} ${value ? "On" : "Off"}");

    var command = getCommand(value ? "On" : "Off");

    publishDeviceUpdate(roomNo, device.deviceId, command,
        device.attributes[device.attributes.keys.first], mqttService);

    await firebaseService.updateDeviceStatusOnToggleSwtich(
        roomNo, device.deviceId, command);

    // Fetch updated devices list and update state
    // List<Device> list = await firebaseService.getAllDevices(roomNo);
    // state = DeviceDataLoadedState(list: list);

    // Navigator.of(context).pop();
  }

  // void updateSliderValue(
  //     double value, Device device, String userId, BuildContext context) async {
  //   if (!mqttService.isConnected) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         duration: Duration(seconds: 1),
  //         content: Text("MQTT is not connected. Cannot send the command.")));
  //     log('MQTT is not connected. Cannot send the command.');
  //     return;
  //   }
  //   bool isSwitchOn = ref
  //           .read(switchStateProvider.notifier)
  //           .mapOfSwitchStates[device.deviceId] ??
  //       false;
  //   if (isSwitchOn) {
  //     showProgressDialog(context: context, message: "Updating Brightness");

  //     var command = getCommand(value.toInt().toString());
  //     //Publishing device update
  //     publishDeviceUpdate(userId, device.deviceId, command,
  //         device.attributes[device.attributes.keys.first], mqttService);

  //     var attributeType = 'Brightness';
  //     await FirebaseServices.updateDeviceStatusOnChangingSlider(
  //         userId, device, command, attributeType);

  //     // Fetch updated devices list and update state
  //     List<Device> list = await deviceCollection.getAllDevices(userId);
  //     state = DeviceDataLoadedState(list: list);

  //     Navigator.of(context).pop();
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Switch is off"),
  //         duration: Duration(seconds: 1),
  //       ),
  //     );
  //   }
  // }

  Future<void> getAllDevices() async {
    try {
      final sharedPref = serviceLocator.get<SharedPreferences>();
      final scannedRoomId = sharedPref.getString(SharedPrefKeys.kUserRoomNo);
      if (scannedRoomId != null && scannedRoomId.isNotEmpty) {
        state = DeviceDataLoadingState();
        final list = await firebaseService.getAllDevices(scannedRoomId);
        log('devices fetched from firebase');
        for (var device in list) {
          ref
                  .read(switchStateProvider.notifier)
                  .mapOfSwitchStates[device.deviceId] =
              GerenrateNumberFromHexa.hexaIntoStringForBulb(device.status) ==
                  "On";
        }
        state = DeviceDataLoadedState(list: list);
      } else {
        state = DeviceDataLoadedState(list: []);
      }
    } catch (e) {
      log('error in getting all devices: ${e.toString()}');
      state = DeviceDataErrorState(error: 'Could not fetch Devices');
    }
  }
}
