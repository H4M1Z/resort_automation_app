import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/model_classes/device.dart';

class AddDeviceTypeAdditionProvider extends ChangeNotifier {
  List<Device> _devicesList = [];
  DeviceCollection deviceCollection = DeviceCollection();
  List<Device> get devicesList => _devicesList;
  final List<Map<String, dynamic>> _devices = [];
  final Map<String, TextEditingController> _controllers = {};

  AddDeviceTypeAdditionProvider() {
    // Add default devices (Fan and Bulb)
    addDeviceType("Fan", "Speed", notify: false);
    addDeviceType("Bulb", "Brightness", notify: false);
  }

  List<Map<String, dynamic>> get devices => _devices;
  // Method for adding more devices
  void addDeviceType(String deviceType, String attribute,
      {bool notify = true}) {
    if (!_controllers.containsKey(deviceType)) {
      _controllers[deviceType] = TextEditingController();
    }
    _devices.add({
      'deviceType': deviceType,
      'attribute': attribute,
      'controller': _controllers[deviceType],
    });
    if (notify) notifyListeners();
  }

  // For removing device from the new device tab Locally
  void removeDeviceType(String deviceType) {
    _devices.removeWhere((device) => device['deviceType'] == deviceType);
    _controllers.remove(deviceType);
    notifyListeners();
  }

// For adding device to the control tab
  void addDevice(
      {required String deviceType,
      required Map<String, dynamic> attribute}) async {
    final deviceName = _controllers[deviceType]?.text ?? '';
    log('Device Added: $deviceType | Name: $deviceName | Attribute: $attribute');
    //Getting all devices
    var listOfDevices = await deviceCollection.getAllDevices("user1");
    Device device = Device(
        type: deviceType,
        group: "Null",
        status: "Off",
        deviceName: deviceName,
        attributes: {'${attribute['attribute']}': 0},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deviceId: "0${listOfDevices.length + 1} ${deviceName}");
    await deviceCollection.addDevice(userId: "user1", device: device);
    await getAllDevices();
    notifyListeners();
  }

  Future<void> getAllDevices() async {
    try {
      _devicesList = await deviceCollection.getAllDevices("user1");
    } catch (e) {
      log("Error getting all devices: $e");
    }
    notifyListeners();
  }

  // For deleting the device from the firebase
  void deleteDevice(String deviceName, String deviceId) async {
    log('Device Deleted: $deviceName | ID: $deviceId');
    await deviceCollection.deleteDevice("user1", deviceId, deviceName);
    notifyListeners();
  }
}
