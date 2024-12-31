import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

import '../core/collections/device_collection.dart';
import '../core/model_classes/device.dart';

// class DeviceStateChangeProvider with ChangeNotifier {
//   final MqttService mqttService = MqttService.instance;
//   final DeviceCollection _deviceCollection = DeviceCollection.instance;
//   AddDeviceTypeAdditionProvider addDeviceTypeAdditionProvider =
//       AddDeviceTypeAdditionProvider();

//   // Getter for deviceSwitchState
//   Map<String, bool> get deviceSwitchState =>
//       addDeviceTypeAdditionProvider.deviceSwitchState;

//   // Setter for deviceSwitchState
//   set deviceSwitchState(Map<String, bool> newState) {
//     addDeviceTypeAdditionProvider.deviceSwitchState = newState;
//     log("In device switch state method");
//     notifyListeners(); // Notify listeners whenever the map is updated
//   }

//   // Getter for deviceSliderValue
//   Map<String, double> get deviceSliderValue =>
//       addDeviceTypeAdditionProvider.deviceSliderValue;

//   // Setter for deviceSliderValue
//   set deviceSliderValue(Map<String, double> newSliderValue) {
//     addDeviceTypeAdditionProvider.deviceSliderValue = newSliderValue;
//     notifyListeners(); // Notify listeners whenever the slider value map is updated
//   }

//   // Toggle switch for individual devices
//   void toggleSwitch(
//       bool value, Device device, String userId, BuildContext context) async {
//     showProgressDialog(
//         context: context,
//         message: "Turning ${device.deviceName} ${value ? "On" : "Off"}");

//     // Update the switch state
//     addDeviceTypeAdditionProvider.deviceSwitchState = {
//       ...deviceSwitchState, // Copy existing map
//       device.deviceId: value, // Update the specific device switch state
//     };

//     log("Coming value after calling  $value");
//     log("Switch State in Toggle switch method ${deviceSwitchState[device.deviceId]}");

//     if (deviceSwitchState[device.deviceId] ?? value) {
//       // Send "On" command
//       var command = _getCommand(device.type, "On");
//       await _deviceCollection.updateDeviceStatus(
//           userId, device.deviceId, command);
//     } else {
//       // Send "Off" command
//       var command = _getCommand(device.type, "Off");
//       await _deviceCollection.updateDeviceStatus(
//           userId, device.deviceId, command);
//     }

//     Navigator.of(context).pop();
//   }

//   // Update slider value for individual devices
//   void updateSliderValue(
//       double value, Device device, String userId, BuildContext context) async {
//     if (!mqttService.isConnected) {
//       log('MQTT is not connected. Cannot send the command.');
//       return;
//     }
//     if (deviceSwitchState[device.deviceId] == true) {
//       showProgressDialog(
//           context: context,
//           message:
//               "Updating ${GerenrateNumberFromHexa.getDeviceAttributeAccordingToDeviceType(device.type)}");

//       // Only update if the switch is on
//       deviceSliderValue = {
//         ...deviceSliderValue, // Copy existing map
//         device.deviceId: value, // Update the specific device slider value
//       };

//       log("Device Type ${device.type}");
//       log("Slider Value ${value.toInt().toString()}");

//       var command = _getCommand(device.type, value.toInt().toString());
//       var attributeType = getDeviceAttributeAccordingToDeviceType(device.type);
//       log("command: $command");
//       log("Attribute Type: $attributeType");

//       // Send frequency/brightness command
//       await _deviceCollection.updateDeviceAttribute(
//           userId, device.deviceId, command, attributeType);

//       Navigator.of(context).pop(); // Close the dialog after the delay.
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Switch is off"),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }
//   }

//   // Get the current state of the switch for a specific device
//   bool getSwitchState(String deviceId) {
//     return deviceSwitchState[deviceId] ??
//         false; // Return false if the state is not set
//   }

//   // Get the current slider value for a specific device
//   double getSliderValue(String deviceId) {
//     return deviceSliderValue[deviceId] ?? 0; // Return 0 if the value is not set
//   }

//   // Helper function to generate a command for each device type and action

// }
String getDeviceAttributeAccordingToDeviceType(String deviceType) {
  switch (deviceType) {
    case "Fan":
      return "Speed";
    case "Bulb":
      return "Brightness";
    default:
      return "";
  }
}

String mapDeviceType(String deviceType) {
  switch (deviceType) {
    case "Fan":
      return "0x0101";
    case "Bulb":
      return "0x0201";
    default:
      return "Off";
  }
}

String getCommand(String deviceType, String action) {
  switch (deviceType) {
    case "Fan":
      return _fanCommands[action] ?? "Unknown";
    case "Bulb":
      return _bulbCommands[action] ?? "Unknown";
    default:
      return "Unsupported Device";
  }
}

const Map<String, String> _fanCommands = {
  "On": "0x0101",
  "Off": "0x0100",
  "0": "0x0110",
  "25": "0x0119",
  "50": "0x0132",
  "75": "0x014B",
  "100": "0x0164",
};

const Map<String, String> _bulbCommands = {
  "On": "0x0201",
  "Off": "0x0200",
  "0": "0x0210",
  "25": "0x0219",
  "50": "0x0232",
  "75": "0x024B",
  "100": "0x0264",
};
