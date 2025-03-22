import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/commom/functions/common_functions.dart';
import 'package:resort_automation_app/core/commom/widgets/auth_buttons.dart';
import 'package:resort_automation_app/core/commom/widgets/auth_pages_container_design.dart';
import 'package:resort_automation_app/core/commom/widgets/auth_text_fields.dart';
import 'package:resort_automation_app/core/commom/widgets/password_text_field.dart';
import 'package:resort_automation_app/pages/forgot_password_page/controller/forgot_pass_controller.dart';

class ForgotPasswordForm extends ConsumerWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final controller = ref.read(forgotPasswordControllerProvider.notifier);
    return BackgroundContainerDesign(
        child: Column(
      children: [
        ResetPasswordText(
          height: height,
          size: 0.03,
        ),
        ForgotPasswordFields(
          controller: controller,
          height: height,
        ),
        LoginSignupButton(
            value: 0.1,
            text: 'Reset Password',
            height: height,
            width: width,
            onTap: controller.onChangedPasswordClicked),
        SizedBox(
          height: height * 0.1,
        )
      ],
    ));
  }
}

class ResetPasswordText extends StatelessWidget {
  const ResetPasswordText({super.key, required this.height, this.size = 0.05});
  final double height;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.08),
      child: Text(
        'Reset Password',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: height * size,
        ),
      ),
    );
  }
}

class ForgotPasswordFields extends StatelessWidget {
  const ForgotPasswordFields(
      {super.key, required this.controller, required this.height});
  final ForgotPasswordPageController controller;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
              padding: EdgeInsets.only(top: height * 0.1),
              labelText: 'Email',
              controller: controller.emailController,
              validator: emailValidation),
          PasswordTextField(
            lalbel: 'Enter new password',
            controller: controller.passwordController,
            validator: passwordValidation,
          ),
          PasswordTextField(
            lalbel: 'Confirm password',
            controller: controller.confirmPasswordController,
            validator: passwordValidation,
          )
        ],
      ),
    );
  }
}
