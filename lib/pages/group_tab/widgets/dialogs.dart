import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_state_controller.dart';

void showDeleteConfirmationDialog(
    BuildContext context, WidgetRef ref, String groupId) {
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
            showProgressDialog(context: context, message: "Deleting group");
            await ref.read(deviceGroupsProvider.notifier).deleteGroup(groupId);
            await ref.read(deviceGroupsProvider.notifier).getAllDeviceGroups();
            Navigator.pop(context);
            Navigator.pop(context); // Perform delete logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Delete"),
        ),
      ],
    ),
  );
}
