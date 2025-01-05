import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieRobot extends StatelessWidget {
  const LottieRobot({super.key});

  static const _lottieRobot = 'assets/animations/lottie_robot.json';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Lottie.asset(
      width: size.width * 0.5,
      height: size.height * 0.3,
      _lottieRobot,
    );
  }
}
