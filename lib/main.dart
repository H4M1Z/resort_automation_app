import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/core/all_providers.dart';
import 'package:home_automation_app/firebase_options.dart';
import 'package:home_automation_app/pages/splash_screen/splash_screen.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/themes/theme.dart';
import 'package:provider/provider.dart';

void main() async {
  //Initalizing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Function to run the app
  runApp(multiProvider(const IoTApp()));
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
        home: const SplashScreen(),
      ),
    );
  }
}
