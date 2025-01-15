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
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [
                    const Color.fromARGB(255, 249, 247, 247),
                    const Color.fromARGB(255, 234, 228, 228),
                    const Color.fromARGB(255, 249, 247, 247)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black : Colors.grey,
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Name and Master Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Group Icon and Name
                  Row(
                    children: [
                      // Beautiful Group Icon
                      Container(
                        width: size.height * 0.05,
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isDarkMode
                                ? [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.primary
                                  ]
                                : [
                                    const Color.fromRGBO(53, 97, 105, 1),
                                    const Color.fromRGBO(53, 97, 105, 1)
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.group, // Choose your preferred group icon
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10), // Space between icon and text
                      // Group Name
                      Text(
                        deviceGroup.groupName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

                  // SwitchNuemorphic
                  SwitchNuemorphic(
                    groupStatus: deviceGroup.currentStatus,
                    isDarkMode: isDarkMode,
                    theme: theme,
                    groupName: deviceGroup.groupName,
                    groupId: deviceGroup.groupId,
                  )
                ],
              ),
              const SizedBox(height: 35.0),

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
