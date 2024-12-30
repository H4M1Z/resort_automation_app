import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';

class DeviceSlider extends ConsumerWidget {
  final Device device;
  final bool isDarkMode;
  final ThemeData theme;

  const DeviceSlider({
    super.key,
    required this.device,
    required this.isDarkMode,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(deviceStateProvider);

    // Get the current slider value for the device
    double value = device.attributes['sliderValue']?.toDouble() ?? 0;

    return Slider(
      value: value,
      min: 0,
      max: 100,
      divisions: 4,
      label: value.round().toString(),
      onChanged: (newValue) {
        ref
            .read(deviceStateProvider.notifier)
            .updateSliderValue(newValue, device, globalUserId, context);
      },
      activeColor: isDarkMode ? const Color(0xFF4FC0E7) : theme.primaryColor,
      inactiveColor: Colors.grey,
    );
  }
}
