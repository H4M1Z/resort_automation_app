import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/model_classes/device_group.dart';
import 'package:resort_automation_app/pages/control_tab/controllers/switch_state_controller.dart';
import 'package:resort_automation_app/pages/control_tab/widgets/device_item.dart';
import 'package:resort_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:resort_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:resort_automation_app/utils/hexa_into_number.dart';
import 'package:resort_automation_app/utils/screen_meta_data.dart';
import 'package:resort_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/model_classes/device.dart';

class DevicesStream extends ConsumerWidget {
  const DevicesStream({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(deviceStateProvider);
    final controller = ref.read(deviceStateProvider.notifier);
    final groupController = ref.read(deviceGroupsProvider.notifier);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: groupController.listenToRoom(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: ScreenMetaData.getHeight(context) * 0.7,
            child: const Center(
              child: SpinKitCircle(
                color: Colors.blue, // Replace with your theme's primary color
                size: 50.0,
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done ||
            snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading room data'));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Room deleted or not found',
                  style: TextStyle(fontSize: 20)),
            );
          }
          if (!snapshot.data!.exists) {
            serviceLocator
                .get<SharedPreferences>()
                .setString(SharedPrefKeys.kUserRoomNo, '');
            return SizedBox(
                height: ScreenMetaData.getHeight(context) * 0.7,
                child: const Center(child: Text('Please scan the room ID')));
          }
          final room = DeviceGroup.fromMap(snapshot.data!.data()!);
          serviceLocator
              .get<SharedPreferences>()
              .setString(SharedPrefKeys.kUserRoomNo, room.roomNumber);

          //..........................DEVICES STREAM
          return StreamBuilder<List<Device>>(
            stream: controller.listenToDevices(),
            builder: (context, roomSnapshot) {
              log('Connection state ========= ${roomSnapshot.connectionState}');
              if (roomSnapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: ScreenMetaData.getHeight(context) * 0.7,
                  child: const Center(
                    child: SpinKitCircle(
                      color: Colors
                          .blue, // Replace with your theme's primary color
                      size: 50.0,
                    ),
                  ),
                );
              }
              if (roomSnapshot.hasError) {
                return const Center(child: Text('Error loading room data'));
              }

              if (!roomSnapshot.hasData) {
                return const Center(
                  child:
                      Text('No devices found', style: TextStyle(fontSize: 20)),
                );
              }
              if (roomSnapshot.data!.isEmpty) {
                log('List is empty');
              }
              final list = roomSnapshot.data!;

              for (var device in list) {
                ref
                        .read(switchStateProvider.notifier)
                        .mapOfSwitchStates[device.deviceId] =
                    GerenrateNumberFromHexa.hexaIntoStringForBulb(
                            device.status) ==
                        "On";
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: roomSnapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: ScreenMetaData.getWidth(context) < 700
                        ? const EdgeInsets.only(left: 10.0, right: 10, top: 6)
                        : const EdgeInsets.only(left: 18.0, right: 18, top: 8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        var currentDevice = roomSnapshot.data![index];
                        double containerHeight = constraints.maxWidth *
                            0.4; // Example: Less height for other devices

                        return SizedBox(
                          height: containerHeight,
                          width: constraints.maxWidth,
                          child: DeviceItem(
                            containerHeight: containerHeight,
                            containerWidth: constraints.maxWidth,
                            device: currentDevice,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
