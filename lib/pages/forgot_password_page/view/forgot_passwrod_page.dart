import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/commom/widgets/loading_widget.dart';
import 'package:home_automation_app/core/commom/widgets/lottie_robot_widget.dart';
import 'package:home_automation_app/core/extensions/pop_up_messages.dart';
import 'package:home_automation_app/pages/forgot_password_page/controller/forgot_pass_controller.dart';
import 'package:home_automation_app/pages/forgot_password_page/view/widgets/forgot_password_widget.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  static const pageName = '/forgot-password-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey.shade800,
                )),
            const Center(child: LottieRobot()),
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(forgotPasswordControllerProvider);
                switch (state) {
                  case ForgotPasswordInitialState():
                    return const ForgotPasswordForm();
                  case ForgotPasswordLoadingState():
                    return const LoadingWidget(
                      child: ForgotPasswordForm(),
                    );
                  case ForgotPasswordLoadedState():
                    context.showPopUpMsg(state.message);
                    return const ForgotPasswordForm();
                  case ForgotPasswordErrorState():
                    context.showPopUpMsg(state.error);
                    return const ForgotPasswordForm();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
