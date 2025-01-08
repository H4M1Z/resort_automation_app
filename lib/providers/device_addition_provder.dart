import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
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
    showProgressDialog(context: context, message: "Adding new Device");
    var tec = ref
            .read(newDevicetypeAdditionProvider.notifier)
            .controllers[deviceType]!
            .text ??
        "NDevice";
    var list = await deviceCollection.getAllDevices(globalUserId);
    final device = Device(
      type: deviceType,
      group: deviceGroup,
      status: deviceType == "Fan" ? "0x0100" : "0x0200",
      deviceName: tec,
      attributes: {
        GerenrateNumberFromHexa.getDeviceAttributeAccordingToDeviceType(
            deviceType): deviceType == "Fan" ? "0x0110" : "0x0210"
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deviceId: "0${(list.length + 1).toString()} $tec",
    );

    await deviceCollection.addDevice(userId: globalUserId, device: device);
    await ref.read(deviceStateProvider.notifier).getAllDevices();
    Navigator.of(context).pop();
    // Notify UI components to update, if needed
    state = "Change";
  }
}
