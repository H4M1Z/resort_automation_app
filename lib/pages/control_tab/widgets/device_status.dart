import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/pages/control_tab/controllers/switch_state_controller.dart';

class DeviceStatus extends ConsumerWidget {
  final Device device;
  final ThemeData theme;
  const DeviceStatus({super.key, required this.device, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(switchStateProvider);
    return Text(
      ref
                  .read(switchStateProvider.notifier)
                  .mapOfSwitchStates[device.deviceId] ==
              true
          ? "ON"
          : "OFF",
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: ref
                    .read(switchStateProvider.notifier)
                    .mapOfSwitchStates[device.deviceId] ==
                true
            ? Colors.green
            : Colors.red,
      ),
    );
  }
}
