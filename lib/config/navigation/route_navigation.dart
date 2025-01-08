import 'package:flutter/material.dart';
import 'package:home_automation_app/pages/add_device_tab/new_tab_view.dart';
import 'package:home_automation_app/pages/control_tab/control_tab_view.dart';
import 'package:home_automation_app/pages/device_scaning_tab/device_selection_tab.dart';
import 'package:home_automation_app/pages/home_page/home_page_view.dart';
import 'package:home_automation_app/pages/login_page/view/login_page.dart';
import 'package:home_automation_app/pages/profile_page/profile_page.dart';
import 'package:home_automation_app/pages/setting_tab/view/setting_tab_view.dart';
import 'package:home_automation_app/pages/sign_up_page/view/signup_page.dart';

import '../../pages/splash_screen/splash_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  return switch (settings.name) {
    LoginScreen.pageName => MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    SignUpScreen.pageName => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    HomeScreen.pageName => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    ProfilePage.pageName => MaterialPageRoute(
        builder: (context) {
          return const ProfilePage();
        },
        settings: settings,
      ),
    AddDevicesTab.pageName => MaterialPageRoute(
        builder: (context) => const AddDevicesTab(),
      ),
    ControlTab.pageName => MaterialPageRoute(
        builder: (context) => const ControlTab(),
      ),
    DeviceScanningTab.pageName => MaterialPageRoute(
        builder: (context) => const DeviceScanningTab(),
      ),
    SplashScreen.pageName => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      ),
    SettingsTab.pageName => MaterialPageRoute(
        builder: (context) => const SettingsTab(),
      ),
    _ => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      )
  };
}

class ProfilePageArguments {
  final String image, name, email;
  final bool isEnabled;
  ProfilePageArguments(
      {required this.image,
      required this.name,
      required this.email,
      required this.isEnabled});
}
