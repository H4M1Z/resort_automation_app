import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/pages/control_tab/controllers/slide_value_controller.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

class AttributeValue extends ConsumerWidget {
  final Device device;
  final ThemeData theme;
  final bool isDarkMode;
  const AttributeValue(
      {super.key,
      required this.device,
      required this.theme,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(sliderValueProvider);
    return Text(
      "${ref.read(sliderValueProvider.notifier).mapOfSliderValues[device.deviceId] ?? 0} ",
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black87,
      ),
    );
  }
}
