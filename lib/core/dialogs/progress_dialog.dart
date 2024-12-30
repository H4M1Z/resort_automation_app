import 'package:flutter/material.dart';

void showProgressDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dismissal by tapping outside
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      final isDarkMode = theme.brightness == Brightness.dark;

      return AlertDialog(
        backgroundColor: isDarkMode
            ? const Color(0xFF1A1C35)
            : const Color.fromARGB(255, 240, 240, 240),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                isDarkMode ? const Color(0xFF4FC0E7) : theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}
