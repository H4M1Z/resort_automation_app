import 'package:flutter/material.dart';
import 'package:home_automation_app/core/model_classes/device.dart';

class DeviceItemTitleAndType extends StatelessWidget {
  final Device device;
  final ThemeData theme;
  final bool isDarkMode;
  const DeviceItemTitleAndType(
      {super.key,
      required this.device,
      required this.isDarkMode,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          device.deviceName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          device.type,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[800],
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
