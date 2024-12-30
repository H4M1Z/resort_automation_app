import 'package:flutter/material.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:provider/provider.dart';

void showRemoveDialog(BuildContext context, Device device) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Remove Device"),
      content:
          Text("Are you sure you want to remove \"${device.deviceName}\"?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            context
                .read<AddDeviceTypeAdditionProvider>()
                .deleteDevice(device.deviceName, device.deviceId);
            Navigator.of(context).pop();
          },
          child: const Text("Remove"),
        ),
      ],
    ),
  );
}
