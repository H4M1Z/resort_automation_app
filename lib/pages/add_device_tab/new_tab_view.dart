import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/core/Connectivity/connectvity_helper.dart';
import 'package:home_automation_app/providers/device_addition_provder.dart';
import 'package:home_automation_app/providers/device_local_state/new_deviceType_addition_notifier.dart';
import 'package:home_automation_app/utils/icons.dart';

class AddDevicesTab extends ConsumerWidget {
  static const pageName = '/add-devices';
  const AddDevicesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final devices = ref.watch(newDevicetypeAdditionProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                    height:
                        size.height * 0.1), // Add space for the upper container
                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? [Colors.grey[900]!, Colors.grey[800]!]
                                  : [
                                      const Color.fromARGB(255, 249, 247, 247),
                                      const Color.fromARGB(255, 234, 228, 228),
                                      const Color.fromARGB(255, 249, 247, 247)
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: isDarkMode ? Colors.black : Colors.grey,
                                blurRadius: 10,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isDarkMode
                                  ? theme.colorScheme.primary
                                  : theme.primaryColor,
                              child: Icon(
                                getDeviceIcon(device['deviceType']),
                                color: Colors.white,
                              ),
                            ),
                            title: TextField(
                              controller: device['controller'],
                              decoration: InputDecoration(
                                labelText: "${device['deviceType']} Name",
                                labelStyle:
                                    TextStyle(color: theme.primaryColor),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                if (device['controller'].text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter device name"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } else {
                                  final hasInternet = await ConnectivityHelper
                                      .hasInternetConnection(context);
                                  if (!hasInternet) return;
                                  ref
                                      .read(deviceAdditionProvider.notifier)
                                      .addDevice(
                                          deviceType: device['deviceType'],
                                          ref: ref,
                                          context: context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? theme.colorScheme.primary
                                    : theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
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
                    Fluttertoast.showToast(msg: "Available soon");
                  },
                  icon: Icon(Icons.add, color: theme.iconTheme.color),
                  label: const Text("Add Device Type",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () {
                        ref
                            .read(newDevicetypeAdditionProvider.notifier)
                            .clearAllControllers();
                        Navigator.pop(context); // Pop the page
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),

                    // Title
                    const Text(
                      "Add devices",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Placeholder for any other action icon
                    const SizedBox(width: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
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
