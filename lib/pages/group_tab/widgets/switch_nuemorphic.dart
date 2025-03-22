import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/Connectivity/connectvity_helper.dart';
import 'package:resort_automation_app/core/dialogs/progress_dialog.dart';
import 'package:resort_automation_app/core/protocol/mqt_service.dart';
import 'package:resort_automation_app/pages/group_tab/controller/group_switch_togle.dart';

class SwitchNuemorphic extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final ThemeData theme;
  final bool groupStatus;
  const SwitchNuemorphic(
      {super.key,
      required this.isDarkMode,
      required this.theme,
      required this.groupStatus});

  @override
  ConsumerState<SwitchNuemorphic> createState() => _SwitchNuemorphicState();
}

class _SwitchNuemorphicState extends ConsumerState<SwitchNuemorphic> {
  bool currentGroupStatus = false;
  final MqttService mqttService = MqttService();
  @override
  void initState() {
    super.initState();
    log("In it state of group switch ${widget.groupStatus}");
    currentGroupStatus = widget.groupStatus;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref
          .read(groupSwitchTogleProvider.notifier)
          .intialGroupSwitchState(widget.groupStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    log("rebuild Group Switch $currentGroupStatus");
    // var groupSwitchCurretState = ref.watch(groupSwitchTogleProvider);
    final groupSwitchProvider = ref.read(groupSwitchTogleProvider.notifier);
    return Switch(
      value: currentGroupStatus,
      onChanged: (value) async {
        final hasInternet =
            await ConnectivityHelper.hasInternetConnection(context);
        if (!hasInternet) return;
        if (mqttService.isConnected) {
          ////////
          setState(() {
            currentGroupStatus = value;
          });
          ////////
          showProgressDialog(
              context: context, message: "Updating All devices in group");
          await groupSwitchProvider.onGroupSwitchToggle(value, context);
          // await ref.read(deviceStateProvider.notifier).getAllDevices();
          // await ref.read(deviceGroupsProvider.notifier).getAllDeviceGroups();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("MQTT is not connected. Cannot send the command."),
            duration: Duration(seconds: 1),
          ));
        }
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
