import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/config/navigation/route_navigation.dart';
import 'package:home_automation_app/config/service_locator.dart';
import 'package:home_automation_app/core/services/navigation_service.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';
import 'package:home_automation_app/firebase_options.dart';
import 'package:home_automation_app/pages/login_page/view/login_page.dart';
import 'package:home_automation_app/pages/splash_screen/splash_screen.dart';
import 'package:home_automation_app/providers/user_addtion_state_provider.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/themes/theme.dart';

String globalUserId = "user1";

void main() async {
  //Initalizing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //......SET UP THE LOCATOR TO ACCESS SERVICE ACCROSS THE APP
  await setupLocator();
  var sl = serviceLocator.get<UserManagementService>();
  final isUserSignedIn = await sl.isUserSignedIn();
  Widget? widget;

  if (isUserSignedIn) {
    globalUserId = sl.getUserUid()!;
    widget = const SplashScreen();
  } else {
    widget = const LoginScreen();
  }

// Function to run the app
  runApp(ProviderScope(
      child: IoTApp(
    widget: widget,
  )));
}

class IoTApp extends ConsumerWidget {
  const IoTApp({super.key, required this.widget});
  final Widget widget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(themeStateProvider);
    var sl = serviceLocator.get<UserManagementService>();

    // For adding user meta data in prefs
    if (!sl.isUserNameInPrefs()) {
      ref.read(userStateProvider.notifier).setUserData();
    }
    // For adding theme
    if (!sl.isThemeAddedInPrefs()) {
      sl.setTheme(false);
    }

    return MaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: onGenerateRoute,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: state,
      home: widget,
    );
  }
}
