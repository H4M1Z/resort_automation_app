import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_switch_togle.dart';

class SwitchNuemorphic extends ConsumerWidget {
  final bool isDarkMode;
  final ThemeData theme;
  final String groupName;
  final String groupId;
  const SwitchNuemorphic(
      {super.key,
      required this.isDarkMode,
      required this.theme,
      required this.groupName,
      required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var groupSwitchCurretState = ref.watch(groupSwitchTogleProvider);
    final groupSwitchProvider = ref.read(groupSwitchTogleProvider.notifier);
    return Switch(
      value: groupSwitchCurretState,
      onChanged: (value) {
        groupSwitchProvider.onGroupSwitchToggle(value, groupName, groupId);
      },
      activeColor: isDarkMode ? const Color(0xFF4FC0E7) : theme.primaryColor,
      inactiveTrackColor:
          isDarkMode ? const Color(0xFF2C2F47) : Colors.grey[300],
      inactiveThumbColor:
          isDarkMode ? const Color(0xFF4FC0E7).withOpacity(0.5) : Colors.grey,
    );
  }
}
