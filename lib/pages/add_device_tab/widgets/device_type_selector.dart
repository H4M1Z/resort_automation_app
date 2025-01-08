import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/providers/device_local_state/new_deviceType_addition_notifier.dart';

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
