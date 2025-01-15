import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:home_automation_app/pages/group_tab/controller/ids_uploader_controller.dart';

void addGroupNameDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Enter Group Name"),
      content: TextField(
        controller:
            ref.read(idsUploadStateProvider.notifier).groupNameController,
        decoration: const InputDecoration(
          hintText: "Group Name",
        ),
        onChanged: (value) {
          // Capture group name logic
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(idsUploadStateProvider.notifier).clearGroupController();
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            showProgressDialog(context: context, message: "Creating group");
            await ref
                .read(idsUploadStateProvider.notifier)
                .onCreateGroupButtonClick(ref);
            await ref.read(deviceGroupsProvider.notifier).getAllDeviceGroups();

            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Group created successfully")));
            ref.read(idsUploadStateProvider.notifier).clearGroupController();
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("Create"),
        ),
      ],
    ),
  );
}
