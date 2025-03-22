import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/services/user_management_service.dart';

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
    return intiallizeTheme();
  }

  ThemeMode intiallizeTheme() {
    bool isDark = serviceLocator.get<UserManagementService>().getCurrentTheme();
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  // Getter to check if the theme is dark
  bool get isDarkTheme => isDark;

  // Method to toggle the theme mode
  void toggleTheme(bool isDark) {
    isDark = isDark;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
