import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarItems {
  static const item1 = BottomNavigationBarItem(
    icon: Icon(
      Icons.toggle_on_outlined,
      color: Colors.blueGrey,
    ),
    activeIcon: Icon(
      Icons.toggle_on,
      color: Colors.blue,
    ),
    label: 'Control',
  );
  static const item2 = BottomNavigationBarItem(
    icon: Icon(
      Icons.group_outlined,
      color: Colors.blueGrey,
    ),
    activeIcon: Icon(
      Icons.group,
      color: Colors.blue,
    ),
    label: 'Group',
  );
  static const item3 = BottomNavigationBarItem(
    icon: Icon(
      Icons.settings_outlined,
      color: Colors.blueGrey,
    ),
    activeIcon: Icon(
      Icons.settings,
      color: Colors.blue,
    ),
    label: 'Setting',
  );
}
