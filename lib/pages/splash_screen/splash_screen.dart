import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/protocol/Firestore_mqtt_Bridge.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/pages/home_page/home_page_view.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    super.key,
  });

  static const pageName = '/splash-screen';
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  final MqttService _mqttService = MqttService();

  @override
  void initState() {
    super.initState();
    startListeningToFirestore(
        context, "user1", _mqttService); // Listen to Firestore changes
    // Connect to MQTT and subscribe to topics
    _mqttService.connect().then((_) {
      // Subscribe to user-specific topics using wildcards
      final userId =
          globalUserId; // Replace with dynamic user ID for multi-user apps
      final topic =
          'user/$userId/device/+/status'; // Wildcard for all user devices
      // await Future.delayed(const Duration(seconds: 3));
      _mqttService.subscribeToTopic(topic);
    });
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
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        HomeScreen.pageName,
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
