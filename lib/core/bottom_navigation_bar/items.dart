import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarItems {
  static const item1 = BottomBarItem(
    inActiveItem: Icon(
      Icons.toggle_on_outlined,
      color: Colors.blueGrey,
    ),
    activeItem: Icon(
      Icons.toggle_on,
      color: Colors.blueAccent,
    ),
    itemLabel: 'Control',
  );
  static const item2 = BottomBarItem(
    inActiveItem: Icon(
      Icons.group_outlined,
      color: Colors.blueGrey,
    ),
    activeItem: Icon(
      Icons.group,
      color: Colors.blueAccent,
    ),
    itemLabel: 'Group',
  );
  static const item3 = BottomBarItem(
    inActiveItem: Icon(
      Icons.settings_outlined,
      color: Colors.blueGrey,
    ),
    activeItem: Icon(
      Icons.settings,
      color: Colors.blueAccent,
    ),
    itemLabel: 'Setting',
  );
}
