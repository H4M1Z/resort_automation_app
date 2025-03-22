import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:resort_automation_app/providers/device_state_notifier/device_state_change_notifier.dart'
    show deviceStateProvider;
import 'package:resort_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/service_locator.dart';

final qrScanningProvider =
    NotifierProvider<QrScanningPageController, QRScanningStates>(
        QrScanningPageController.new);

class QrScanningPageController extends Notifier<QRScanningStates> {
  @override
  build() {
    return QRScanningInitialState();
  }

  onQRCodeScanned(String roomNumber) async {
    try {
      final sharedPref = serviceLocator.get<SharedPreferences>();
      final roomId = sharedPref.getString(SharedPrefKeys.kUserRoomNo);
      if (roomId == null || roomId.isEmpty) {
        log('room id is null');
        log('roomNumber : $roomNumber');
        state = QRScanningLoadingState();
        await sharedPref.setString(SharedPrefKeys.kUserRoomNo, roomNumber);
        await sharedPref.setBool(SharedPrefKeys.kIsRoomIdScanned, true);
        await sharedPref.setBool(SharedPrefKeys.kShouldCheckRoom, false);
        // ref.read(deviceStateProvider.notifier).getAllDevices();
        // ref.read(deviceGroupsProvider.notifier).getGroup();
        ref.read(deviceStateProvider.notifier).showDevices();
        ref.read(deviceGroupsProvider.notifier).showGroup();
        state = QRScannedState(
          roomNumber: roomNumber,
        );
      } else {
        state = QRScanningErrorState(
            error: 'Code already scanned for room number $roomId');
      }
    } catch (e) {
      log('error on qr code scanned : ${e.toString()}');
      state = const QRScanningErrorState(error: 'Error scanning QR code');
    }
  }
}

sealed class QRScanningStates {
  const QRScanningStates();
}

final class QRScanningInitialState extends QRScanningStates {}

final class QRScanningLoadingState extends QRScanningStates {}

final class QRScanningErrorState extends QRScanningStates {
  final String error;
  const QRScanningErrorState({required this.error});
}

final class QRScannedState extends QRScanningStates {
  final String roomNumber;
  const QRScannedState({required this.roomNumber});
}
