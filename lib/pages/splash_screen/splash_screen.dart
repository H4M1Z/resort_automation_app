import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_automation_app/pages/home_page/home_page_view.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AddDeviceTypeAdditionProvider>().getAllDevices();
    // Navigate to the next screen after 3 seconds
    moveToNextScreen();
  }

  void moveToNextScreen() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const HomeScreen()), // Replace with your next screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SizedBox(
          height: 250,
          child: Lottie.asset(
            "assets/animations/animation12.json",
          ),
        ),
      ),
    );
  }
}
