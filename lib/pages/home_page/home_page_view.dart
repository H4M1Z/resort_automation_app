import 'package:flutter/material.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:home_automation_app/pages/control_tab/control_tab_view.dart';
import 'package:home_automation_app/pages/group_tab/group_tab_view.dart';
import 'package:home_automation_app/pages/setting_tab/setting_tab_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = const [
    ControlTab(),
    GroupTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BottomStateChangeNotifier>(
          builder: (context, value, child) => _pages[value.currentIndex]),
      bottomNavigationBar: animatedNotchBottomNavigationBar(context),
    );
  }
}
