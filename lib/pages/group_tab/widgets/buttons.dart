import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/pages/group_devices_page/controllers/group_device_button_controller.dart';
import 'package:home_automation_app/pages/group_devices_page/view/group_addtion.dart';
import 'package:home_automation_app/pages/group_tab/widgets/dialogs.dart';

class GroupDeviceButton extends ConsumerWidget {
  final String groupId;
  final bool isDarkMode;
  final String groupName;
  const GroupDeviceButton(
      {super.key,
      required this.isDarkMode,
      required this.groupId,
      required this.groupName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        showProgressDialog(
            context: context, message: "Getting devices for group $groupName");
        await ref
            .read(groupDevicesPageStateProvider.notifier)
            .onDevicesButtonClick(groupId);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GroupDevicesPage(
            groupId: groupId,
          ),
        ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color(0xFFEFEFEF),
        elevation: 4,
        shadowColor: isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.device_hub,
              color: isDarkMode ? Colors.white : Colors.black),
          const SizedBox(width: 8),
          Text(
            "Devices",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class GroupDeleteButton extends ConsumerWidget {
  final String groupId;
  final bool isDarkMode;
  const GroupDeleteButton(
      {super.key, required this.isDarkMode, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Perform action
        showDeleteConfirmationDialog(context, ref, groupId);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color(0xFFEFEFEF),
        elevation: 4,
        shadowColor: isDarkMode
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete, color: isDarkMode ? Colors.white : Colors.black),
          const SizedBox(width: 8),
          Text(
            "Delete Group",
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
