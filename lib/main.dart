import 'package:flutter/material.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:home_automation_app/pages/home_page/home_page_view.dart';

import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/themes/theme.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'control_tab.dart';
// import 'add_devices_tab.dart';
// import 'group_tab.dart';
// import 'settings_tab.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => BottomStateChangeNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeStateNotifier(),
    )
  ], child: const IoTApp()));
}

class IoTApp extends StatelessWidget {
  const IoTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateNotifier>(
      builder: (context, theme, child) => MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: theme.themeMode,
        home: const HomeScreen(),
      ),
    );
  }
}
