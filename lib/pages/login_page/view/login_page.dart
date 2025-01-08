import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/commom/widgets/loading_widget.dart';
import 'package:home_automation_app/core/extensions/pop_up_messages.dart';
import 'package:home_automation_app/pages/login_page/controllers/login_page_controller.dart';
import 'package:home_automation_app/pages/login_page/view/widgets/login_screen_widgets.dart';
import 'package:home_automation_app/pages/splash_screen/splash_screen.dart';

import '../../../core/commom/widgets/lottie_robot_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const pageName = '/login-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LottieRobot(),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(loginControllerProvider);
                  final controller = ref.read(loginControllerProvider.notifier);
                  switch (state) {
                    case UserSigninInitialState():
                      return const LoginForm();
                    case UserSigninLoadingState():
                      return const LoadingWidget(
                        child: LoginForm(),
                      );
                    case UserSigninLoadedState():
                      _navigate(
                        () {
                          Navigator.popAndPushNamed(
                              context, SplashScreen.pageName);
                          controller.reinitialzeStateAndClearControllers();
                        },
                      );

                      return const LoginForm();
                    case UserSigninErrorState():
                      context.showPopUpMsg(state.errorMessage);
                      return const LoginForm();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _navigate(VoidCallback func) =>
      SchedulerBinding.instance.addPostFrameCallback((_) => func());
}
