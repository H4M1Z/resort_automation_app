import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device.dart';

final newDevicetypeAdditionProvider =
    NotifierProvider<NewDevicetypeAdditionNotifier, List<Map<String, dynamic>>>(
        NewDevicetypeAdditionNotifier.new);

class NewDevicetypeAdditionNotifier
    extends Notifier<List<Map<String, dynamic>>> {
  final Map<String, TextEditingController> controllers = {};
  final List<Map<String, dynamic>> devices = [];
  @override
  List<Map<String, dynamic>> build() {
    addDeviceType("Fan", "Speed");
    addDeviceType("Bulb", "Brightness");
    return devices;
  }

  void addDeviceType(String deviceType, String attribute) {
    // Check if the device type already exists in the list
    if (devices.any((device) => device['deviceType'] == deviceType)) {
      // You can show a message or handle the case where the device type already exists
      log('Device type already added');
      return; // Exit the method without adding a duplicate
    }

    // If the device type does not exist, add it
    if (!controllers.containsKey(deviceType)) {
      controllers[deviceType] = TextEditingController();
    }

    // Adding the new device type to the list
    devices.add({
      'deviceType': deviceType,
      'attribute': attribute,
      'controller': controllers[deviceType],
    });

    // Updating the state
    state = List.from(devices);
  }

  void removeDeviceType(String deviceType) {
    // Remove the device type and its controller
    devices.removeWhere((device) => device['deviceType'] == deviceType);
    controllers[deviceType]
        ?.dispose(); // Dispose of the controller to prevent memory leaks
    controllers.remove(deviceType);

    // Update the state
    state = List.from(devices);
  }

  // Optionally, you can add a method to clear all devices and controllers
  void clearDevices() {
    devices.clear();
    controllers.forEach((_, controller) => controller.dispose());
    controllers.clear();

    state = [];
  }
}
