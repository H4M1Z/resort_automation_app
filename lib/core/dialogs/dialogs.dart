import 'package:flutter/material.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:provider/provider.dart';

void showDeviceDialog(BuildContext context, int index) {
  final deviceProvider = context.read<AddDeviceTypeAdditionProvider>();
  final device = deviceProvider.devicesList[index];
  double attributeValue =
      (device.attributes.values.first as num).toDouble(); // Slider value

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(device.deviceName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Slider for controlling the attribute
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(device.attributes.keys.first),
                Text(attributeValue.toInt().toString()),
              ],
            ),
            Slider(
              value: attributeValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: attributeValue.toInt().toString(),
              onChanged: (value) {
                // setState(() {
                //   attributeValue = value;
                // });
              },
            ),
            const SizedBox(height: 16),
            // Toggle status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Status"),
                Switch(
                  value: device.status == "On",
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              device.attributes[device.attributes.keys.first] =
                  attributeValue.toInt();
              deviceProvider.notifyListeners();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          IconButton(
            onPressed: () {
              deviceProvider.devicesList.removeAt(index);
              context
                  .read<AddDeviceTypeAdditionProvider>()
                  .deleteDevice(device.deviceName, device.deviceId);
              deviceProvider.notifyListeners();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      );
    },
  );
}
