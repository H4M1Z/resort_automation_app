import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:resort_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:resort_automation_app/pages/control_tab/control_tab_view.dart';
import 'package:resort_automation_app/pages/group_tab/group_tab_view.dart';
import 'package:resort_automation_app/pages/qr_scanning_page/view/qr_scanning_page.dart';
import 'package:resort_automation_app/pages/setting_tab/view/setting_tab_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String pageName = '/home';

  final List<Widget> _pages = const [
    ControlTab(),
    GroupTab(),
    QrScanningTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(bottomBarStateProvider);
    return Scaffold(
      body: _pages[state],
      bottomNavigationBar: getBottomNavigationBar(context, ref),
    );
  }
}
