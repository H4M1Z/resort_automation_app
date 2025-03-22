import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/model_classes/device_group.dart';
import 'package:resort_automation_app/providers/device_state_notifier/firebase_services.dart';
import 'package:resort_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import '../../../config/service_locator.dart';

final deviceGroupsProvider =
    NotifierProvider<GroupStateController, DeviceGroupStates>(
        GroupStateController.new);

class GroupStateController extends Notifier<DeviceGroupStates> {
  final _firebaseServices = FirebaseServices();

  @override
  DeviceGroupStates build() {
    return DeviceGroupInitalState();
  }

  showGroup() {
    state = DeviceGroupRoomIdScennedState();
  }

  listenToRoom() {
    final sharedPref = serviceLocator.get<SharedPreferences>();
    final roomNumber = sharedPref.getString(SharedPrefKeys.kUserRoomNo);
    return _firebaseServices.listenToRoom(roomNumber!);
  }

  getGroup() async {
    try {
      state = DeviceGroupLoadingState();
      final sharedPref = serviceLocator.get<SharedPreferences>();
      final roomNumber = sharedPref.getString(SharedPrefKeys.kUserRoomNo);
      if (roomNumber != null) {
        final room = await _firebaseServices.getRoom(roomNumber);
        log('room fetched from firebase');
        state = DeviceGroupLoadedState(
          group: room,
        );
      } else {
        state = DeviceGroupInitalState();
      }
    } catch (e) {
      //..........................RUN AND CKECK
      log('error fetching room : ${e.toString()}');
      state = DeviceGroupErrorState(error: e.toString());
    }
  }
}

abstract class DeviceGroupStates {
  const DeviceGroupStates();
}

class DeviceGroupInitalState extends DeviceGroupStates {}

class DeviceGroupLoadingState extends DeviceGroupStates {}

class DeviceGroupLoadedState extends DeviceGroupStates {
  final DeviceGroup group;
  const DeviceGroupLoadedState({required this.group});
}

class DeviceGroupErrorState extends DeviceGroupStates {
  final String error;
  const DeviceGroupErrorState({required this.error});
}

class DeviceGroupRoomIdScennedState extends DeviceGroupStates {}
