import 'package:flutter/material.dart';
import 'package:home_automation_app/providers/device_state_change_provider.dart';
import 'package:provider/provider.dart';

class DeviceSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const DeviceSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSwitchOn = context.watch<DeviceStateChangeProvider>().isSwitchOn;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Status"),
        Switch(
          value: isSwitchOn,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
