import 'package:flutter/material.dart';

class LottieRobot extends StatelessWidget {
  const LottieRobot({super.key});

  static const _lottieRobot = 'assets/animations/lottie_robot.json';
  static const logo1 = "assets/images/macha_logo1.png";
  static const logo2 = "assets/images/macha_logo2.png";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Image.asset(
      width: size.width * 0.6,
      height: size.height * 0.3,
      logo2,
    );
  }
}
