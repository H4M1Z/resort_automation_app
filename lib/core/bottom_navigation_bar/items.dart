import 'package:flutter/material.dart';

class BottomNavigationBarItems {
  static BottomNavigationBarItem getitem1(bool isDark) =>
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.toggle_on_outlined,
          color: Colors.blueGrey,
        ),
        activeIcon: Icon(
          Icons.toggle_on,
          color: Color.fromARGB(255, 7, 149, 173),
        ),
        label: 'Control',
      );

  static BottomNavigationBarItem getitem2(bool isDark) =>
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.group_outlined,
          color: Colors.blueGrey,
        ),
        activeIcon: Icon(
          Icons.group,
          color: Color.fromARGB(255, 7, 149, 173),
        ),
        label: 'Group',
      );

  static BottomNavigationBarItem getitem3(bool isDark) =>
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.qr_code_scanner_outlined,
          color: Colors.blueGrey,
        ),
        activeIcon: Icon(
          Icons.qr_code_scanner_sharp,
          color: Color.fromARGB(255, 7, 149, 173),
        ),
        label: 'QR Code',
      );

  static BottomNavigationBarItem getitem4(bool isDark) =>
      const BottomNavigationBarItem(
        icon: Icon(
          Icons.settings_outlined,
          color: Colors.blueGrey,
        ),
        activeIcon: Icon(
          Icons.settings,
          color: Color.fromARGB(255, 7, 149, 173),
        ),
        label: 'Settings',
      );
}
