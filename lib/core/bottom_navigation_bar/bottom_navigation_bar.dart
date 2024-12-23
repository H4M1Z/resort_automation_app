import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/items.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:home_automation_app/utils/screen_meta_data.dart';
import 'package:provider/provider.dart';

AnimatedNotchBottomBar animatedNotchBottomNavigationBar(BuildContext context) {
  return AnimatedNotchBottomBar(
      notchBottomBarController: NotchBottomBarController(),
      bottomBarItems: const [
        BottomNavigationBarItems.item1,
        BottomNavigationBarItems.item2,
        BottomNavigationBarItems.item3
      ],
      onTap: (value) {
        context.read<BottomStateChangeNotifier>().changeIndex(value);
      },
      kIconSize: 20,
      bottomBarWidth: ScreenMetaData.getWidth(context),
      kBottomRadius: 0);
}
