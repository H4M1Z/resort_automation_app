import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/model_classes/device.dart';

class DeviceAdditionProvider extends ChangeNotifier {
  DeviceCollection deviceCollection = DeviceCollection();
  TextEditingController bulbTEC = TextEditingController();
  TextEditingController fanTEC = TextEditingController();

  String deviceType = 'Bulb';
  String deviceGroup = 'Null';
  String deviceCurrentStatus = "Off";

  void addDevice(
      {required String deviceType, required String attribute}) async {
    Device device = Device(
        type: deviceType,
        group: deviceGroup,
        status: deviceCurrentStatus,
        deviceName: fanTEC.text,
        attributes: {'${DeviceAttributes.brightness}': 0},
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deviceId: fanTEC.text);
    await deviceCollection.addDevice(userId: "user1", device: device);
    notifyListeners();
  }
}
