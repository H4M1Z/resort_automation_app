import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/commom/widgets/password_text_field.dart';
import 'package:resort_automation_app/pages/forgot_password_page/view/forgot_passwrod_page.dart';
import 'package:resort_automation_app/pages/login_page/controllers/login_page_controller.dart';
import 'package:resort_automation_app/pages/sign_up_page/view/signup_page.dart';

import '../../../../core/commom/functions/common_functions.dart';
import '../../../../core/commom/widgets/auth_buttons.dart';
import '../../../../core/commom/widgets/auth_pages_container_design.dart';
import '../../../../core/commom/widgets/auth_text_fields.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final controller = ref.read(loginControllerProvider.notifier);
    return BackgroundContainerDesign(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginText(
              height: height,
            ),

            //...............TEXT FIELDS
            LoginTextFields(
              height: height,
              width: width,
              controller: controller,
            ),

            //...............FORGOT PASSWORD
            ForgetPasswordText(
              height: height,
              width: width,
            ),

            //...............LOGIN BUTTON
            LoginSignupButton(
              text: 'Login',
              height: height,
              width: width,
              onTap: controller.onLoginClicked,
            ),

            //...............SIGNUP PAGE BUTTON TEXT
            SignupText(
              height: height,
            ),

            //..................DIVIDER
            DividerWithText(
              height: height,
            ),

            //..........PROVIDER BUTTONS
            ProviderButtons(
              height: height,
              width: width,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginText extends StatelessWidget {
  const LoginText({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.05),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: height * 0.05,
        ),
      ),
    );
  }
}

class LoginTextFields extends ConsumerWidget {
  const LoginTextFields(
      {super.key,
      required this.height,
      required this.width,
      required this.controller});
  final double height, width;
  final LoginPageController controller;
  static const email = 'Email';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
            padding: EdgeInsets.only(top: height * 0.1),
            labelText: email,
            controller: controller.emailController,
            validator: emailValidation,
          ),
          PasswordTextField(
            lalbel: 'Password',
            controller: controller.passwordController,
            validator: passwordValidation,
          ),
        ],
      ),
    );
  }
}

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText(
      {super.key, required this.height, required this.width});
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.02,
        left: width * 0.5,
      ),
      child: GestureDetector(
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: const Color.fromARGB(255, 217, 209, 209),
            fontSize: height * 0.018,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, ForgotPasswordPage.pageName),
      ),
    );
  }
}

class SignupText extends StatelessWidget {
  const SignupText({super.key, required this.height});
  final double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.03,
      ),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Don't have an account? ",
              style: TextStyle(color: Color.fromARGB(255, 217, 209, 209)),
            ),
            TextSpan(
              text: 'SignUp.',
              style: const TextStyle(
                color: Color.fromARGB(255, 232, 222, 133),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.popAndPushNamed(context, SignUpScreen.pageName);
                },
            ),
          ],
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, required this.height});

  final double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.025),
      child: const Row(
        children: [
          Spacer(),
          Expanded(
            flex: 2,
            child: Divider(
              color: Color.fromARGB(255, 223, 216, 216),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or',
              style: TextStyle(
                color: Color.fromARGB(179, 225, 219, 219),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Divider(
              color: Color.fromARGB(255, 223, 216, 216),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class ProviderButtons extends ConsumerWidget {
  const ProviderButtons({super.key, required this.height, required this.width});

  final double height, width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonHeight = height * 0.1;
    final controller = ref.read(loginControllerProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(top: height * 0.02),
      child: Column(
        children: [
          SizedBox(
            height: buttonHeight,
            width: width,
            child: Center(
              child: SignInProviderButtons(
                iconPath: 'assets/images/apple_icon.png',
                providerName: 'Apple',
                onTap: controller.onAppleSignInClicked,
              ),
            ),
          ),
          SizedBox(
            height: buttonHeight,
            width: width,
            child: Center(
              child: SignInProviderButtons(
                iconPath: 'assets/images/google_icon.png',
                providerName: 'Google',
                onTap: () => controller.onGoogleSignInClicked(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
