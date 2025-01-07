import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_automation_app/pages/group_devices_page/controllers/group_device_button_controller.dart';
import 'package:home_automation_app/pages/group_devices_page/widgets/remove_dialog.dart';
import 'package:home_automation_app/utils/icons.dart';

class GroupDevicesPage extends ConsumerWidget {
  final String groupId;
  const GroupDevicesPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(groupDevicesPageStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Group Devices")),
      body: Builder(builder: (context) {
        if (state is GroupDeviceButtonInitialState) {
          return Center(
              child: SpinKitCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          ));
        } else if (state is GroupDeviceButtonLoadingState) {
          return Center(
              child: SpinKitCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          ));
        } else if (state is GroupDeviceButtonLoadedState) {
          return state.listOfDevices.isEmpty
              ? Center(
                  child: Text(
                  "No device found",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary),
                ))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.listOfDevices
                              .length, // Placeholder for device count
                          itemBuilder: (context, index) {
                            final device = state.listOfDevices[index];
                            return ListTile(
                              leading: Icon(getDeviceIcon(device.type)),
                              title: Text(device.deviceName),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () {
                                  showRemoveConfirmationDialog(
                                      context, ref, groupId, index);
                                  // Remove device from group logic
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
        } else {
          return Center(
              child: Text(
            "Something went wrong",
            style: TextStyle(
                fontSize: 18, color: Theme.of(context).colorScheme.primary),
          ));
        }
      }),
    );
  }
}
