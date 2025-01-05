import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/config/navigation/roue_navigation.dart';
import 'package:home_automation_app/config/service_locator.dart';
import 'package:home_automation_app/firebase_options.dart';
import 'package:home_automation_app/pages/login_page/view/login_page.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/themes/theme.dart';

String globalUserId = "user1";

void main() async {
  //Initalizing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
// Function to run the app
  runApp(const ProviderScope(child: IoTApp()));
}

class IoTApp extends ConsumerWidget {
  const IoTApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(themeStateProvider);
    return MaterialApp(
      onGenerateRoute: onGenerateRoute,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: state,
      home: const LoginScreen(),
    );
  }
}
