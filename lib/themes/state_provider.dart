import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the NotifierProvider for managing theme state
final themeStateProvider =
    NotifierProvider<ThemeStateNotifier, ThemeMode>(ThemeStateNotifier.new);

// Implement the Notifier for the theme state
class ThemeStateNotifier extends Notifier<ThemeMode> {
  // Internal variable to track the dark mode status
  bool isDark = false;

  @override
  ThemeMode build() {
    // Default theme mode is light
    return ThemeMode.light;
  }

  // Getter to check if the theme is dark
  bool get isDarkTheme => isDark;

  // Method to toggle the theme mode
  void toggleTheme(bool isDark) {
    isDark = isDark;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
