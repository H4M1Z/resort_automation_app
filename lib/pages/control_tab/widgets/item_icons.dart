import 'package:flutter/material.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/utils/icons.dart';

class ItemIcon extends StatelessWidget {
  final Device device;
  final ThemeData theme;
  final bool isDarkMode;
  const ItemIcon(
      {super.key,
      required this.device,
      required this.isDarkMode,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Icon(
      getDeviceIcon(device.type),
      size: 40,
      color: isDarkMode ? const Color(0xFF4FC0E7) : theme.primaryColor,
    );
  }
}

class DeviceItemRemoveIcon extends StatelessWidget {
  const DeviceItemRemoveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.remove_circle,
      size: 30,
      color: Colors.red,
    );
  }
}
