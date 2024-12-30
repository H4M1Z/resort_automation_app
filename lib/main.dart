import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:home_automation_app/firebase_options.dart';
import 'package:home_automation_app/pages/splash_screen/splash_screen.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:home_automation_app/providers/device_addition_provder.dart';
import 'package:home_automation_app/providers/device_state_change_provider.dart';
import 'package:home_automation_app/providers/user_addtion_state_provider.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/themes/theme.dart';
import 'package:provider/provider.dart';

String globalUserId = "user1";

void main() async {
  //Initalizing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Function to run the app
  runApp(const ProviderScope(child: IoTApp()));
}

class IoTApp extends ConsumerWidget {
  const IoTApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(themeStateProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: state,
      home: const SplashScreen(),
    );
  }
}
