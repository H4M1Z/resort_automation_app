import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/model_classes/device.dart';
import 'package:resort_automation_app/providers/device_state_notifier/firebase_services.dart';
import 'package:resort_automation_app/utils/hexa_into_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/strings/shared_pref_keys.dart';

final switchStateProvider =
    NotifierProvider<SwitchStateController, bool>(SwitchStateController.new);

class SwitchStateController extends Notifier<bool> {
  Map<String, bool> mapOfSwitchStates = {};
  // DeviceCollection deviceCollection = DeviceCollection();
  final firebaseService = FirebaseServices();
  bool isSwitchOn = false;
  @override
  bool build() {
    return isSwitchOn;
  }

  void intialSwitchState(bool value) {
    state = value;
  }

  Future<void> updateSwitchState(bool value, Device device) async {
    final sharedPref = serviceLocator.get<SharedPreferences>();
    final roomId = sharedPref.getString(SharedPrefKeys.kUserRoomNo);

    var status = await firebaseService.getDeviceStatus(
      roomId!,
      device.deviceId,
    );
    var genNo = GerenrateNumberFromHexa.hexaIntoStringForBulb(status);

    mapOfSwitchStates[device.deviceId] = genNo == "On";
    log("Length of map in updateSwitchState method = ${mapOfSwitchStates.length}");

    log("genNo in Update swtich State method = $genNo");
    log("value = ${genNo == "On"}");
    state = genNo == "On";
  }
}
