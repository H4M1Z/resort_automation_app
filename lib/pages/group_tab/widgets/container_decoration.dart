import 'package:flutter/material.dart';

BoxDecoration containerBoxDecoration(bool isDarkMode) {
  return BoxDecoration(
    color: isDarkMode ? const Color(0xFF1A1C35) : const Color(0xFFEFEFEF),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: isDarkMode
            ? Colors.black.withOpacity(0.5)
            : Colors.grey.withOpacity(0.5),
        blurRadius: 10,
        offset: const Offset(-4, -4),
      ),
      BoxShadow(
        color: isDarkMode
            ? Colors.grey.withOpacity(0.2)
            : Colors.white.withOpacity(0.8),
        blurRadius: 10,
        offset: const Offset(4, 4),
      ),
    ],
  );
}
