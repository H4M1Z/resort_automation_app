import 'package:flutter/material.dart';
import 'package:home_automation_app/pages/group_tab/widgets/dialogs.dart';

Widget deviceButton(bool isDarkMode) {
  return ElevatedButton(
    onPressed: () {
      // Perform action
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
        Icon(Icons.device_hub, color: isDarkMode ? Colors.white : Colors.black),
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

Widget deleteButton(bool isDarkMode, BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      // Perform action
      showDeleteConfirmationDialog(context);
      ;
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
