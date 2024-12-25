import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:provider/provider.dart';

class AddDevicesTab extends StatelessWidget {
  const AddDevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<AddDeviceTypeAdditionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Devices")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: deviceProvider.devices.length,
                itemBuilder: (context, index) {
                  final device = deviceProvider.devices[index];
                  return ListTile(
                    leading: Icon(getDeviceIcon(device['deviceType'])),
                    title: TextField(
                      controller: device['controller'],
                      decoration: InputDecoration(
                        labelText: "${device['deviceType']} Name",
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        log("clicked on Button");
                        deviceProvider.addDevice(
                          deviceType: device['deviceType'],
                          attribute: device,
                        );
                      },
                      child: const Text("Add"),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                _showDeviceTypeSelector(context);
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Device Type"),
            ),
          ],
        ),
      ),
    );
  }

  static IconData getDeviceIcon(String deviceType) {
    switch (deviceType) {
      case 'Bulb':
        return Icons.lightbulb;
      case 'Fan':
        return Icons.ac_unit;
      case 'AC':
        return Icons.ac_unit_outlined;
      case 'TV':
        return Icons.tv;
      case 'Oven':
        return Icons.kitchen;
      case 'Washing Machine':
        return Icons.local_laundry_service;
      default:
        return Icons.device_unknown;
    }
  }

  void _showDeviceTypeSelector(BuildContext context) {
    final deviceProvider = context.read<AddDeviceTypeAdditionProvider>();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.ac_unit_outlined),
              title: const Text("AC"),
              onTap: () {
                deviceProvider.addDeviceType("AC", "Cooling");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text("TV"),
              onTap: () {
                deviceProvider.addDeviceType("TV", "Channel");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.kitchen),
              title: const Text("Oven"),
              onTap: () {
                deviceProvider.addDeviceType("Oven", "Temperature");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_laundry_service),
              title: const Text("Washing Machine"),
              onTap: () {
                deviceProvider.addDeviceType("Washing Machine", "Mode");
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
