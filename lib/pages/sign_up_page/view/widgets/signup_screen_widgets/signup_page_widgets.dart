import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validation.dart';
import 'package:resort_automation_app/core/commom/functions/common_functions.dart';
import 'package:resort_automation_app/core/commom/widgets/auth_buttons.dart';
import 'package:resort_automation_app/pages/login_page/view/login_page.dart';
import 'package:resort_automation_app/pages/sign_up_page/controllers/profile_pic_controller.dart';
import 'package:resort_automation_app/pages/sign_up_page/controllers/sign_up_controller.dart';

import '../../../../../core/commom/widgets/auth_pages_container_design.dart';
import '../../../../../core/commom/widgets/auth_text_fields.dart';
import '../../../../../core/commom/widgets/password_text_field.dart';

class SignUpForm extends ConsumerWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final controller = ref.read(signupControllerProvider.notifier);
    return BackgroundContainerDesign(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignUpText(
              height: height,
            ),

            const ProfilePicWidget(),

            //...............TEXT FIELDS
            SignUpTextFields(
              height: height,
              width: width,
              controller: controller,
            ),

            //...............SIGNUP BUTTON
            LoginSignupButton(
              text: 'SignUp',
              height: height,
              width: width,
              value: 0.05,
              onTap: controller.onSignUpClicked,
            ),

            //...............SIGNUP PAGE BUTTON TEXT
            LoginText(
              height: height,
            ),

            SizedBox(
              height: height * 0.01,
            )
          ],
        ),
      ),
    );
  }
}

class ProfilePicWidget extends ConsumerWidget {
  const ProfilePicWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final controller = ref.read(profileImageProvider.notifier);
    return Padding(
      padding: EdgeInsets.only(top: height * 0.05),
      child: Container(
        width: height * 0.15,
        height: height * 0.15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color.fromARGB(255, 217, 209, 209),
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ProfilePic(),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.onPickImageClicked,
                child: Icon(
                  color: const Color.fromARGB(255, 217, 209, 209),
                  Icons.add_a_photo_outlined,
                  size: height * 0.03,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends ConsumerWidget {
  const ProfilePic({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileImageProvider);
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: switch (state) {
        ImagePickedState() => FileImage(File(state.imagePath)),
        _ => null,
      },
      child: switch (state) {
        ImagePickedState() => null,
        _ => Icon(
            Icons.person,
            color: const Color.fromARGB(255, 217, 209, 209),
            size: MediaQuery.sizeOf(context).height * 0.15,
          ),
      },
    );
  }
}

class SignUpText extends StatelessWidget {
  const SignUpText({super.key, required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.05),
      child: Text(
        'SignUp',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: height * 0.05,
        ),
      ),
    );
  }
}

class SignUpTextFields extends StatelessWidget {
  const SignUpTextFields(
      {super.key,
      required this.height,
      required this.width,
      required this.controller});
  final double height, width;
  final SignupController controller;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        children: [
          CustomTextField(
            padding: EdgeInsets.only(top: height * 0.1),
            labelText: 'Name',
            controller: controller.nameController,
            validator: (value) =>
                Validator(validators: [const RequiredValidator()])
                    .validate(label: 'Name', value: value),
          ),
          CustomTextField(
            padding: EdgeInsets.only(top: height * 0.05),
            labelText: 'Email',
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

class LoginText extends StatelessWidget {
  const LoginText({super.key, required this.height});
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
              text: "Already have an account? ",
              style: TextStyle(color: Color.fromARGB(255, 217, 209, 209)),
            ),
            TextSpan(
              text: 'Login.',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 233, 222, 124),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.popAndPushNamed(context, LoginScreen.pageName);
                },
            ),
          ],
        ),
      ),
    );
  }
}
