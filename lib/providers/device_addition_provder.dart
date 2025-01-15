import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/providers/device_local_state/new_deviceType_addition_notifier.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

// Define the NotifierProvider
final deviceAdditionProvider = NotifierProvider<DeviceAdditionNotifier, String>(
  DeviceAdditionNotifier.new,
);

// DeviceAdditionNotifier class
class DeviceAdditionNotifier extends Notifier<String> {
  MqttService mqttService = MqttService();
  final DeviceCollection deviceCollection = DeviceCollection();

  String deviceType = 'Bulb';
  String deviceGroup = 'Null';
  String deviceCurrentStatus = "Off";

  @override
  String build() {
    // No state to initialize since this is a side-effect notifier
    return "";
  }

  // Method to add a device
  Future<void> addDevice(
      {required String deviceType,
      required WidgetRef ref,
      required BuildContext context}) async {
    //Showing dialog
    showProgressDialog(context: context, message: "Adding new Device");
    String? deviceName = ref
        .read(newDevicetypeAdditionProvider.notifier)
        .controllers[deviceType]!
        .text;

    if (deviceName != "") {
      final userId = globalUserId; // Replace with the current user's ID
      final topic = 'user123/$userId/init';

      if (mqttService.isConnected) {
        mqttService.publishMessage(topic, {'userId': userId}.toString());
        log('User ID sent during device addition: $userId');
      } else {
        log('Failed to send User ID during device addition. MQTT is not connected.');
      }
      var list = await deviceCollection.getAllDevices(globalUserId);
      int getDeviceId = int.parse(list[list.length - 1].deviceId[1]);
      final device = Device(
        type: deviceType,
        group: deviceGroup,
        status: deviceType == "Fan" ? "0x0100" : "0x0200",
        deviceName: deviceName,
        attributes: {
          GerenrateNumberFromHexa.getDeviceAttributeAccordingToDeviceType(
              deviceType): deviceType == "Fan" ? "0x0110" : "0x0210"
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deviceId: "0${getDeviceId + 1} $deviceName",
      );

      await deviceCollection.addDevice(userId: globalUserId, device: device);
      await ref.read(deviceStateProvider.notifier).getAllDevices();
      ref.read(newDevicetypeAdditionProvider.notifier).clearAllControllers();
      Navigator.of(context).pop();
      // Notify UI components to update, if needed
      state = "Change";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Please enter device name"),
      ));
    }
  }
}
