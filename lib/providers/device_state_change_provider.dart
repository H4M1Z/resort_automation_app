import 'dart:developer';

import 'package:flutter/material.dart';

import '../core/collections/device_collection.dart';
import '../core/model_classes/device.dart';

class DeviceStateChangeProvider with ChangeNotifier {
  final DeviceCollection _deviceCollection = DeviceCollection.instance;

  bool isSwitchOn = false;
  double sliderValue = 0;

  void toggleSwitch(bool value, Device device, String userId) {
    isSwitchOn = value;
    // if (value) {
    //   // Send "On" command
    //   _sendCommand(device.type, "On", userId, device.deviceId);
    // } else {
    //   // Send "Off" command
    //   _sendCommand(device.type, "Off", userId, device.deviceId);
    // }
    notifyListeners();
  }

  void updateSliderValue(double value, Device device, String userId) {
    if (isSwitchOn) {
      // Send frequency/brightness command
      sliderValue = value;
      _sendCommand(
          device.type, value.toInt().toString(), userId, device.deviceId);
    }
    notifyListeners();
  }

  Future<void> saveDeviceAttributes(Device device, String userId) async {
    var command = _getCommand(device.type, sliderValue.toInt().toString());
    var attributeType = getDeviceAttributeAccordingToDeviceType(device.type);
    try {
      if (isSwitchOn) {
        // If the switch is on we will update the attribute
        _deviceCollection.updateDeviceAttribute(
            userId, device.deviceId, command, attributeType);
      }
    } catch (e) {
      log("Error saving device attributes: $e");
    }
  }

  void _sendCommand(
      String deviceType, String action, String userId, String deviceId) {
    final command = _getCommand(deviceType, action);
    log("Sending command: $command for deviceId: $deviceId");
    if (deviceType == "Bulb") {
    } else if (deviceType == "Fan") {}
    // Here you can add functionality to send the command to the backend or perform other tasks.
  }

  String checkSwitchAndSendCommand() {
    if (isSwitchOn) {
      return sliderValue.toInt().toString();
    }
    return "";
  }

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

  String _getCommand(String deviceType, String action) {
    switch (deviceType) {
      case "Fan":
        return _fanCommands[action] ?? "Unknown";
      case "Bulb":
        return _bulbCommands[action] ?? "Unknown";
      default:
        return "Unsupported Device";
    }
  }

  static const Map<String, String> _fanCommands = {
    "On": "0x0101",
    "Off": "0x0100",
    "25": "0x0119",
    "50": "0x0132",
    "75": "0x014B",
    "100": "0x0164",
  };

  static const Map<String, String> _bulbCommands = {
    "On": "0x0201",
    "Off": "0x0200",
    "25": "0x0219",
    "50": "0x0232",
    "75": "0x024B",
    "100": "0x0264",
  };
}
