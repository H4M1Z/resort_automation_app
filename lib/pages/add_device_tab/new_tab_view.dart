import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:home_automation_app/providers/device_addition_provder.dart';
import 'package:home_automation_app/providers/device_local_state/new_deviceType_addition_notifier.dart';
import 'package:home_automation_app/utils/icons.dart';
import 'package:provider/provider.dart';

class AddDevicesTab extends ConsumerWidget {
  const AddDevicesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(newDevicetypeAdditionProvider);

    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Devices"),
        backgroundColor: theme.appBarTheme
            .backgroundColor, // AppBar background color based on theme
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: theme.cardColor, // Adapt Card color based on theme
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme
                            .primaryColor, // Adapt background color of CircleAvatar
                        child: Icon(
                          getDeviceIcon(device['deviceType']),
                          color: theme.iconTheme
                              .color, // Adapt icon color based on theme
                        ),
                      ),
                      title: TextField(
                        controller: device['controller'],
                        decoration: InputDecoration(
                          labelText: "${device['deviceType']} Name",
                          labelStyle: TextStyle(
                              color: theme.primaryColor), // Adapt label color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          ref.read(deviceAdditionProvider.notifier).addDevice(
                              deviceType: device['deviceType'],
                              ref: ref,
                              context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              theme.primaryColor, // Button color based on theme
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: theme.buttonTheme.colorScheme
                                  ?.onPrimary), // Adapt text color of the button
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                showDeviceTypeSelector(context, ref);
              },
              icon: Icon(Icons.add,
                  color: theme.iconTheme.color), // Adapt icon color
              label: Text("Add Device Type",
                  style: TextStyle(
                      color: theme
                          .textTheme.bodyLarge?.color)), // Adapt text color
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    theme.primaryColor, // Button color based on theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDeviceTypeSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.ac_unit_outlined,
                    color: Theme.of(context).primaryColor),
                title: const Text("AC"),
                onTap: () {
                  ref
                      .read(newDevicetypeAdditionProvider.notifier)
                      .addDeviceType("AC", "Cooling");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.tv, color: Theme.of(context).primaryColor),
                title: const Text("TV"),
                onTap: () {
                  ref
                      .read(newDevicetypeAdditionProvider.notifier)
                      .addDeviceType("TV", "Channel");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.kitchen, color: Theme.of(context).primaryColor),
                title: const Text("Oven"),
                onTap: () {
                  ref
                      .read(newDevicetypeAdditionProvider.notifier)
                      .addDeviceType("Oven", "Temperature");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.local_laundry_service,
                    color: Theme.of(context).primaryColor),
                title: const Text("Washing Machine"),
                onTap: () {
                  ref
                      .read(newDevicetypeAdditionProvider.notifier)
                      .addDeviceType("Washing Machine", "Mode");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
