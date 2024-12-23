import 'package:flutter/material.dart';

class ThemeStateNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDark = false;

  bool get isDarkTheme => _isDark;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _isDark = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
