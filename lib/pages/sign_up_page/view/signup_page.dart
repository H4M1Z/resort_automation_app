import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/commom/widgets/loading_widget.dart';
import 'package:resort_automation_app/core/extensions/pop_up_messages.dart';
import 'package:resort_automation_app/pages/login_page/view/login_page.dart';
import 'package:resort_automation_app/pages/sign_up_page/controllers/sign_up_controller.dart';
import 'package:resort_automation_app/pages/sign_up_page/view/widgets/signup_screen_widgets/signup_page_widgets.dart';

import '../../../core/commom/widgets/lottie_robot_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static const pageName = '/sign-up-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const LottieRobot(),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(signupControllerProvider);
                  final controller =
                      ref.read(signupControllerProvider.notifier);
                  switch (state) {
                    case SignupInitialState():
                      return const SignUpForm();
                    case SignupLoadingState():
                      return const LoadingWidget(
                        child: SignUpForm(),
                      );
                    case SignupSuccessState():
                      _navigate(
                        () {
                          Navigator.popAndPushNamed(
                              context, LoginScreen.pageName);
                          controller.reinitializeStateAndClearControllers();
                        },
                      );

                      return const SignUpForm();
                    case SignupErrorState():
                      context.showPopUpMsg(
                        state.errorMessage,
                        seconds: 2,
                      );
                      return const SignUpForm();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _navigate(VoidCallback func) {
    SchedulerBinding.instance.addPostFrameCallback((_) => func());
  }
}
