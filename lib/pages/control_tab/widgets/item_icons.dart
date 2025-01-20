import 'package:flutter/material.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/utils/icons.dart';
import 'package:home_automation_app/utils/screen_meta_data.dart';

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
    return SizedBox(
      width: 60, // Increase the width of the touch area
      height: 60, // Increase the height of the touch area
      child: Align(
        alignment: Alignment.center, // Center the icon within the touch area
        child: Icon(
          Icons.remove_circle,
          size: ScreenMetaData.getWidth(context) *
              0.08, // Icon size remains the same
          color: Colors.red,
        ),
      ),
    );
  }
}
