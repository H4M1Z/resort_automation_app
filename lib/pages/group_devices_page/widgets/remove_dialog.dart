import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/pages/group_devices_page/controllers/group_device_button_controller.dart';

void showRemoveConfirmationDialog(
    BuildContext context, WidgetRef ref, String groupId, int index) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text("Confirm Deletion"),
      content: const Text("Are you sure you want to delete this group?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close dialog
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            showProgressDialog(
                context: context, message: "Removing device from the group");
            await ref
                .read(groupDevicesPageStateProvider.notifier)
                .removeDeviceIdFromGroup(groupId, index);
            await ref
                .read(groupDevicesPageStateProvider.notifier)
                .onDevicesButtonClick(groupId);
            Navigator.pop(context);
            Navigator.pop(context); // Perform delete logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}
