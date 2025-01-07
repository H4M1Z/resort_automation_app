import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_automation_app/core/model_classes/device.dart'; // Assuming this contains the Device model
import 'package:home_automation_app/pages/device_scaning_tab/widgets/dialog_group_name.dart';
import 'package:home_automation_app/pages/group_tab/controller/ids_uploader_controller.dart';
import 'package:home_automation_app/pages/group_tab/controller/scaning_tab_controller.dart';

class DeviceScanningTab extends ConsumerWidget {
  const DeviceScanningTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(scannedDeviceProvider);
    final idsUploader = ref.watch(idsUploadStateProvider);
    final idsUploaderController = ref.read(idsUploadStateProvider.notifier);

    return Builder(builder: (context) {
      if (state is DeviceGettingInitalState) {
        return Center(
          child: SpinKitCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          ),
        );
      } else if (state is DeviceGettingLoadingState) {
        return Center(
          child: SpinKitCircle(
            color: Theme.of(context).colorScheme.primary,
            size: 50.0,
          ),
        );
      } else if (state is DeviceGettingLoadedState) {
        log("Lenght of devices  selection tab ${state.list.length}");
        return state.list.isEmpty
            ? const Center(
                child: Text("No device found"),
              )
            : Scaffold(
                appBar: AppBar(title: const Text("Select Devices")),
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          log("Lenght of bolean array in device selection tab ${idsUploaderController.booleanList.length}");
                          final Device device = state.list[index];
                          return ListTile(
                            leading: Icon(
                                device.type == "Bulb"
                                    ? Icons.lightbulb
                                    : Icons.ac_unit,
                                size: 30),
                            title: Text(device.deviceName),
                            trailing: Checkbox(
                              value: idsUploader[index],
                              onChanged: (bool? value) {
                                idsUploaderController.onDeviceSelection(
                                    index, device.deviceId);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          addGroupNameDialog(context, ref);
                        },
                        child: const Text("Create Group"),
                      ),
                    ),
                  ],
                ));
      } else {
        final error = (state as DeviceGettingErrorState).error;
        return Text(error);
      }
    });
  }
}
