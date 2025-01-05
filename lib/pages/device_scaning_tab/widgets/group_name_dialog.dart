import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/pages/group_tab/controller/ids_uploader_controller.dart';

void addGroupNameDialog(BuildContext context, WidgetRef ref) {
  showDialog(
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
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            ref
                .read(idsUploadStateProvider.notifier)
                .onCreateGroupButtonClick();
          },
          child: const Text("Create"),
        ),
      ],
    ),
  );
}
