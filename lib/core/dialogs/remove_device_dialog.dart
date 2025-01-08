import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';

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
          onPressed: () async {
            showProgressDialog(context: context, message: "Removing device");
            await ref
                .read(deviceStateProvider.notifier)
                .deleteAllDevices(device);
            await ref.read(deviceStateProvider.notifier).getAllDevices();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text("Remove"),
        ),
      ],
    ),
  );
}
