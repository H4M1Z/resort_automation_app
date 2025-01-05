import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';
import 'package:home_automation_app/pages/group_tab/widgets/buttons.dart';
import 'package:home_automation_app/pages/group_tab/widgets/switch_nuemorphic.dart';

class GroupContainer extends ConsumerWidget {
  final DeviceGroup deviceGroup;

  const GroupContainer({super.key, required this.deviceGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? const Color(0xFF1A1C35)
              : const Color.fromARGB(255, 239, 245, 245),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Name and Master Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deviceGroup.groupName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SwitchNuemorphic(
                    groupStatus: deviceGroup.currentStatus,
                    isDarkMode: isDarkMode,
                    theme: theme,
                    groupName: deviceGroup.groupName,
                    groupId: deviceGroup.groupId,
                  )
                ],
              ),
              const SizedBox(height: 16.0),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GroupDeleteButton(
                      isDarkMode: isDarkMode, groupId: deviceGroup.groupId),
                  GroupDeviceButton(
                      groupName: deviceGroup.groupName,
                      isDarkMode: isDarkMode,
                      groupId: deviceGroup.groupId),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
