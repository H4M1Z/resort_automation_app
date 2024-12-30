import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/model_classes/device.dart';

// Define the NotifierProvider
final deviceAdditionProvider = NotifierProvider<DeviceAdditionNotifier, void>(
  DeviceAdditionNotifier.new,
);

// DeviceAdditionNotifier class
class DeviceAdditionNotifier extends Notifier<void> {
  final DeviceCollection deviceCollection = DeviceCollection();
  final TextEditingController bulbTEC = TextEditingController();
  final TextEditingController fanTEC = TextEditingController();

  String deviceType = 'Bulb';
  String deviceGroup = 'Null';
  String deviceCurrentStatus = "Off";

  @override
  void build() {
    // No state to initialize since this is a side-effect notifier
  }

  // Method to add a device
  Future<void> addDevice({
    required String deviceType,
    required String attribute,
  }) async {
    final device = Device(
      type: deviceType,
      group: deviceGroup,
      status: deviceCurrentStatus,
      deviceName: fanTEC.text,
      attributes: {attribute: deviceType == "Fan" ? "0x0100" : "0x0200"},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deviceId: fanTEC.text,
    );

    await deviceCollection.addDevice(userId: "user1", device: device);

    // Notify UI components to update, if needed
    state = null;
  }
}
