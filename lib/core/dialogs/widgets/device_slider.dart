import 'package:flutter/material.dart';
import 'package:home_automation_app/providers/device_state_change_provider.dart';
import 'package:provider/provider.dart';

class DeviceSlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const DeviceSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    double sliderValue = context.watch<DeviceStateChangeProvider>().sliderValue;
    return Slider(
      value: sliderValue,
      min: 0,
      max: 100,
      divisions: 4,
      label: sliderValue.round().toString(),
      onChanged: onChanged,
    );
  }
}
