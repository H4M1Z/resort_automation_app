import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:provider/provider.dart';

void showRemoveDialog(BuildContext context, Device device, WidgetRef ref) {
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
            ref
                .read(deviceStateProvider.notifier)
                .deleteAllDevices(device, ref);
            Navigator.of(context).pop();
          },
          child: const Text("Remove"),
        ),
      ],
    ),
  );
}
