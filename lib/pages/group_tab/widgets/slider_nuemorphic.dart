// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

Widget sliderTheme(bool isDarkMode, ThemeData theme) {
  return SliderTheme(
    data: SliderThemeData(
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      activeTrackColor:
          isDarkMode ? const Color(0xFF4FC0E7) : theme.primaryColor,
      inactiveTrackColor:
          isDarkMode ? const Color(0xFF2C2F47) : Colors.grey[300],
      thumbColor: isDarkMode ? const Color(0xFF4FC0E7) : theme.primaryColor,
      overlayColor: isDarkMode
          ? const Color(0xFF4FC0E7).withOpacity(0.3)
          : theme.primaryColor.withOpacity(0.3),
    ),
    child: Slider(
      value: 50,
      min: 0,
      max: 100,
      divisions: 4,
      label: 50.round().toString(),
      onChanged: (newValue) {},
    ),
  );
}
