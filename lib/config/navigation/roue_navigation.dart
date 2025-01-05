import 'package:flutter/material.dart';
import 'package:home_automation_app/pages/login_page/view/login_page.dart';
import 'package:home_automation_app/pages/sign_up_page/view/signup_page.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  return switch (settings.name) {
    LoginScreen.pageName => MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    _ => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      )
  };
}
