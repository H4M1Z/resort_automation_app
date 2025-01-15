import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_automation_app/core/model_classes/device.dart'; // Assuming this contains the Device model
import 'package:home_automation_app/pages/device_scaning_tab/widgets/dialog_group_name.dart';
import 'package:home_automation_app/pages/group_tab/controller/ids_uploader_controller.dart';
import 'package:home_automation_app/pages/group_tab/controller/scaning_tab_controller.dart';

class DeviceScanningTab extends ConsumerWidget {
  static const pageName = "/device_selection_tab";
  const DeviceScanningTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    var state = ref.watch(scannedDeviceProvider);
    final idsUploader = ref.watch(idsUploadStateProvider);
    final idsUploaderController = ref.read(idsUploadStateProvider.notifier);

    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
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
            log("Length of devices selection tab ${state.list.length}");
            return state.list.isEmpty
                ? Center(
                    child: Text(
                      "No device found",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Scaffold(
                    body: Stack(
                      children: [
                        // Main Content (Device List)
                        Column(
                          children: [
                            // Top Container for displaying header or description
                            Center(
                              child: Container(
                                width: double.infinity,
                                height: size.height * 0.1,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 12.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        var boolList = ref
                                            .read(
                                                idsUploadStateProvider.notifier)
                                            .booleanList;
                                        boolList =
                                            List.filled(boolList.length, false);
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(
                                            8.0), // Adjust the padding as needed
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            16), // Space between the icon and the text
                                    Expanded(
                                      child: Text(
                                        "Select devices",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8), // Spacing
                            // List of devices
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.list.length,
                                itemBuilder: (context, index) {
                                  log("Length of boolean array in device selection tab ${idsUploaderController.booleanList.length}");
                                  final Device device = state.list[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            device.type == "Bulb"
                                                ? Icons.lightbulb
                                                : Icons.ac_unit,
                                            size: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          title: Text(
                                            device.deviceName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          trailing: Checkbox(
                                            value: idsUploader[index],
                                            onChanged: (bool? value) {
                                              idsUploaderController
                                                  .onDeviceSelection(
                                                      index, device.deviceId);
                                            },
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // Floating Create Group Button
                        Positioned(
                          bottom: 20.0,
                          right: 16.0,
                          left: 16.0,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              var boolList = ref
                                  .read(idsUploadStateProvider.notifier)
                                  .booleanList;

                              // Count the number of `true` values in the boolean list
                              int selectedCount =
                                  boolList.where((item) => item == true).length;

                              if (selectedCount >= 2) {
                                // Open the dialog if at least two items are selected
                                addGroupNameDialog(context, ref);
                              } else {
                                // Show a ScaffoldMessenger message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    showCloseIcon: true,
                                    content: const Text(
                                        "Please select at least 2 items."),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 8.0, // Elevation for floating effect
                            ),
                            icon: const Icon(
                              Icons.group_add,
                              size: 20.0,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Create Group",
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          } else {
            final error = (state as DeviceGettingErrorState).error;
            return Center(
              child: Text(
                error,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }
        }),
      ),
    );
  }
}
