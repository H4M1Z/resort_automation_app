import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/providers/device_state_change_provider.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

class AddDeviceTypeAdditionProvider extends ChangeNotifier {
  Map<String, bool> deviceSwitchState =
      {}; // Device ID as the key, switch state as value
  Map<String, double> deviceSliderValue =
      {}; // Device ID as the key, slider value as value

  DeviceCollection deviceCollection = DeviceCollection();
  List<Device> _devicesList = [];

  List<Device> get devicesList => _devicesList;
  final List<Map<String, dynamic>> _devices = [];
  final Map<String, TextEditingController> _controllers = {};

  void updateDeviceStateFromFetchedDevices(List<Device> devices) {
    log("Lenght of devices ${devices.length}");
    for (var device in devices) {
      final attribute = getDeviceAttributeAccordingToDeviceType(device.type);
      log("device status = ${device.status}  map Device type = ${mapDeviceType(device.type)}");
      log("Comparing both string ${device.status == mapDeviceType(device.type)}");
      // Initialize the state with the fetched device data
      deviceSwitchState[device.deviceId] =
          device.status == mapDeviceType(device.type);
      deviceSliderValue[device.deviceId] = double.parse(
              GerenrateNumberFromHexa.hexaIntoStringAccordingToDeviceType(
                  device.type, device.attributes[attribute])) ??
          0.0; // Or use appropriate attribute for the device

      log("device switch state at id ${device.deviceId}} = ${deviceSwitchState[device.deviceId]}");
      log("device slider state at id ${device.deviceId}} = ${deviceSliderValue[device.deviceId]}");
    }
    log("Device Switch State all values = ${deviceSwitchState.values.toString()}");
    log("Device Slider State all values = ${deviceSliderValue.values.toString()}");
    notifyListeners();
  }

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
        status: deviceType == "Bulb" ? "0x0200" : "0x0100",
        deviceName: deviceName,
        attributes: {
          '${attribute['attribute']}':
              deviceType == "Bulb" ? "0x0219" : "0x0119"
        },
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deviceId: "0${listOfDevices.length + 1} ${deviceName}");
    await deviceCollection.addDevice(userId: "user1", device: device);
    await getAllDevices();
    notifyListeners();
  }

  Future<void> getAllDevices() async {
    log("In get all Devices method");
    try {
      _devicesList = await deviceCollection.getAllDevices("user1");
      // Update the device state in DeviceStateChangeProvider
      log("Device List ${_devicesList.toString()}");

      updateDeviceStateFromFetchedDevices(_devicesList);
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
