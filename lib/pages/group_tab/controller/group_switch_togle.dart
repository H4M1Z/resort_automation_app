import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/model_classes/device.dart';
import 'package:resort_automation_app/core/protocol/Firestore_mqtt_Bridge.dart';
import 'package:resort_automation_app/core/protocol/mqt_service.dart';
import 'package:resort_automation_app/providers/device_state_change_provider.dart';
import 'package:resort_automation_app/providers/device_state_notifier/firebase_services.dart';
import 'package:resort_automation_app/utils/hexa_into_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/strings/shared_pref_keys.dart';

final groupSwitchTogleProvider =
    NotifierProvider<GroupSwitchTogle, bool>(GroupSwitchTogle.new);

class GroupSwitchTogle extends Notifier<bool> {
  MqttService mqttService = MqttService();
  final FirebaseServices _firebaseServices = FirebaseServices();

  bool isGroupSwitchOn = false;
  Map<String, bool> mapOfGroupSwitchStates = {};
  List<Device> devices = [];
  @override
  bool build() {
    return isGroupSwitchOn;
  }

  void intialGroupSwitchState(bool value) {
    state = value;
  }

  Future<void> onGroupSwitchToggle(bool value, BuildContext context) async {
    log("Value of switch in group toggle method = $value");
    try {
      final sharedPref = serviceLocator.get<SharedPreferences>();
      final roomNumber = sharedPref.getString(SharedPrefKeys.kUserRoomNo);

      final devices = await _firebaseServices.getAllDevices(roomNumber!);

      for (var device in devices) {
        final command = getCommand(value ? "On" : "Off");

        publishDeviceUpdate(roomNumber, device.deviceId, command,
            device.attributes[device.attributes.keys.first], mqttService);

        bool currentDevicestatus =
            GerenrateNumberFromHexa.hexaIntoStringForBulb(device.status) == "On"
                ? true
                : false;
        //Update only if the status is different
        if (currentDevicestatus != value) {
          String action = value ? "On" : "Off";
          String getHexa = getCommand(action);
          //............ROOM NUMBER
          await _firebaseServices.updateDeviceStatus(
              roomNumber, device.deviceId, getHexa);
        }
      }

      //......................ROOM NUMBER
      await _firebaseServices.updateGroupStatus(
        roomNumber,
        value,
      );

      state = value;
    } catch (e) {
      log("Error toggling group devices: $e");
    }
  }
}
