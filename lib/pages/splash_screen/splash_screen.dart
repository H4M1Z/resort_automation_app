import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
import 'package:home_automation_app/pages/home_page/home_page_view.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  final MqttService _mqttService = MqttService.instance;
  @override
  void initState() {
    super.initState();
    // startListeningToFirestore(
    //     context, "user1", _mqttService); // Listen to Firestore changes
    // // Connect to MQTT and subscribe to topics
    // _mqttService.connect().then((_) {
    //   // Subscribe to user-specific topics using wildcards
    //   final userId =
    //       globalUserId; // Replace with dynamic user ID for multi-user apps
    //   final topic =
    //       'user/$userId/device/+/status'; // Wildcard for all user devices
    //   _mqttService.subscribeToTopic(topic, context);
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllDevices();
  }

  void getAllDevices() async {
    await ref.read(deviceStateProvider.notifier).getAllDevices(ref);
    moveToNextScreen();
  }

  void moveToNextScreen() {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }), // Replace with your next screen
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
