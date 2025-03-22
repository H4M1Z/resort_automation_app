import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:resort_automation_app/core/protocol/mqt_service.dart';
import 'package:resort_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:resort_automation_app/pages/home_page/home_page_view.dart';
import 'package:resort_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';

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
    // Connect to MQTT and subscribe to topics
    // _mqttService.connect().then((_) {
    //   // Subscribe to user-specific topics using wildcards
    //   final userId =
    //       globalUserId; // Replace with dynamic user ID for multi-user apps
    //   final topic = 'user/$userId/device/+/status'; // Wildcard for all devices
    //   const topic2 = "user123/+/init";

    //   _mqttService.subscribeToTopic(topic);
    //   _mqttService.subscribeToTopic(topic2);
    // });

    Connectivity().onConnectivityChanged.listen((result) {
      if (result[0] != ConnectivityResult.none && !_mqttService.isConnected) {
        log('Internet connection restored. Attempting to reconnect...');
        Fluttertoast.showToast(
          msg: 'Internet restored. Reconnecting to MQTT...',
        );
        _mqttService.connect();
        // // Attempt reconnection
      } else if (result == ConnectivityResult.values) {
        Fluttertoast.showToast(
          msg: 'No internet connection.',
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => getAllDevicesAndGroups());
  }

  void getAllDevicesAndGroups() async {
    await ref.read(deviceStateProvider.notifier).getAllDevices();

    /// Retrieves all device data from Firestore and updates the local state.
    /// After retrieving all data, it navigates to the next screen (HomeScreen).
    // await ref.read(deviceGroupsProvider.notifier).getAllDeviceGroups();
    await ref.read(deviceGroupsProvider.notifier).getGroup();
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
      backgroundColor: Theme.of(context).colorScheme.primary,
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
