import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/model_classes/device_group.dart';
import 'package:resort_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:resort_automation_app/pages/group_tab/widgets/group_container.dart';
import 'package:resort_automation_app/utils/screen_meta_data.dart';
import 'package:resort_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomStream extends ConsumerWidget {
  const RoomStream({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch(deviceGroupsProvider);
    final controller = ref.read(deviceGroupsProvider.notifier);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: controller.listenToRoom(),
      builder: (context, roomSnapshot) {
        if (roomSnapshot.connectionState == ConnectionState.waiting) {
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
        if (roomSnapshot.connectionState == ConnectionState.done ||
            roomSnapshot.connectionState == ConnectionState.active) {
          if (roomSnapshot.hasError) {
            return const Center(child: Text('Error loading room data'));
          }

          if (!roomSnapshot.hasData) {
            return const Center(
              child: Text('Room deleted or not found',
                  style: TextStyle(fontSize: 20)),
            );
          }
          if (!roomSnapshot.data!.exists) {
            serviceLocator
                .get<SharedPreferences>()
                .setString(SharedPrefKeys.kUserRoomNo, '');
            return SizedBox(
                height: ScreenMetaData.getHeight(context) * 0.7,
                child: const Center(child: Text('Please scan the room ID')));
          }
          final room = DeviceGroup.fromMap(roomSnapshot.data!.data()!);
          serviceLocator
              .get<SharedPreferences>()
              .setString(SharedPrefKeys.kUserRoomNo, room.roomNumber);

          return GroupContainer(
            deviceGroup: room,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
