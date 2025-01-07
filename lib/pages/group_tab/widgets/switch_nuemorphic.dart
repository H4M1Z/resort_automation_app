import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/progress_dialog.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_switch_togle.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';

class SwitchNuemorphic extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final ThemeData theme;
  final String groupName;
  final String groupId;
  final bool groupStatus;
  const SwitchNuemorphic(
      {super.key,
      required this.isDarkMode,
      required this.theme,
      required this.groupName,
      required this.groupId,
      required this.groupStatus});

  @override
  ConsumerState<SwitchNuemorphic> createState() => _SwitchNuemorphicState();
}

class _SwitchNuemorphicState extends ConsumerState<SwitchNuemorphic> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref
          .read(groupSwitchTogleProvider.notifier)
          .intialGroupSwitchState(widget.groupStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    var groupSwitchCurretState = ref.watch(groupSwitchTogleProvider);
    final groupSwitchProvider = ref.read(groupSwitchTogleProvider.notifier);
    return Switch(
      value:
          groupSwitchProvider.mapOfGroupSwitchStates[widget.groupId] ?? false,
      onChanged: (value) async {
        showProgressDialog(context: context, message: "Updating group status");
        await groupSwitchProvider.onGroupSwitchToggle(
            value, widget.groupName, widget.groupId, context);
        await ref.read(deviceStateProvider.notifier).getAllDevices(ref);
        Navigator.pop(context);
      },
      activeColor: widget.isDarkMode
          ? const Color(0xFF4FC0E7)
          : widget.theme.primaryColor,
      inactiveTrackColor:
          widget.isDarkMode ? const Color(0xFF2C2F47) : Colors.grey[300],
      inactiveThumbColor: widget.isDarkMode
          ? const Color(0xFF4FC0E7).withOpacity(0.5)
          : Colors.grey,
    );
  }
}
