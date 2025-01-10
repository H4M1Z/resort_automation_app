import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/core/commom/mixins/auth_behaviour.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/model_classes/sign_up_model.dart';
import 'package:home_automation_app/core/model_classes/user_model.dart';
import 'package:home_automation_app/pages/sign_up_page/controllers/profile_pic_controller.dart';

import '../../../core/services/auth_services.dart';
import '../../../core/services/user_management_service.dart';
import '../../../core/services/user_profile_service.dart';

@immutable
sealed class SignupStates {
  const SignupStates();
}

@immutable
final class SignupInitialState extends SignupStates {}

@immutable
final class SignupLoadingState extends SignupStates {}

@immutable
final class SignupSuccessState extends SignupStates {}

@immutable
final class SignupErrorState extends SignupStates {
  final String errorMessage;

  const SignupErrorState({required this.errorMessage});
}

class SignupController extends Notifier<SignupStates> with AuthBehaviour {
  //.....CONSTANT VALUES
  static const _errorMessage = 'Something went wrong!';
  static const _userNotCreatedMsg = 'User not created!';
  //......TEXT CONTROLLERS
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  //....FORM VALIDATION KEY
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //.....SERVICES
  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);
  final UserManagementService _userManagementService = UserManagementService();
  final UserProfileService _profileService = UserProfileService();

  @override
  build() {
    //.........INITIALIZE THE CONTROLLERS
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    //.............DISPOSE THE CONTROLLERS
    ref.onDispose(
      () {
        nameController.dispose();
        emailController.dispose();
        passwordController.dispose();
      },
    );

    return SignupInitialState();
  }

  //.......FUNCTION TO VERIFY USER EMAIL
  _verifyUserEmail(User user) async {
    await user.sendEmailVerification();
    return user.emailVerified;
  }

  onSignUpClicked() async {
    if (formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: 'Check your email for verification...');
      state = SignupLoadingState();
      try {
        final (userName, email, password) = (
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        //...........CREATE USER WITH EMAIL AND PASSWORD
        final user = await _authService.createUserWithEmailAndPassword(
            SignUpModel(email: email, password: password));

        //...........UPDATE USER DISPLAY NAME AND INSERT IN FIREBASE
        if (user != null) {
          user.updateDisplayName(userName);

          _userManagementService.insertUserUid(user.uid);

          if (ref.read(profileImageProvider) is ImagePickedState) {
            log('[image path ] : ${(ref.read(profileImageProvider) as ImagePickedState).imagePath}');
            _profileService.addUser(
              UserModel(
                userId: user.uid,
                userName: userName,
                email: email,
                profilePic: (ref.read(profileImageProvider) as ImagePickedState)
                    .imagePath,
                themePreferences: '${ThemePrefrences.light}',
                createdAt: DateTime.now(),
                lastLogin: DateTime.now(),
              ),
            );
          } else {
            log('no profile pic selected');
            _profileService.addUser(
              UserModel(
                userId: user.uid,
                userName: userName,
                email: email,
                profilePic: '',
                themePreferences: '${ThemePrefrences.light}',
                createdAt: DateTime.now(),
                lastLogin: DateTime.now(),
              ),
            );
          }

          await _verifyUserEmail(user);
          state = SignupSuccessState();
        } else {
          state = const SignupErrorState(errorMessage: _userNotCreatedMsg);
        }
      } on FirebaseAuthException catch (e) {
        state = SignupErrorState(errorMessage: handleAuthException(e.code));
      } on FirebaseException catch (e) {
        log(e.toString());
        state = const SignupErrorState(errorMessage: _errorMessage);
      } catch (e) {
        state = const SignupErrorState(errorMessage: _errorMessage);
        log(e.toString());
      }
    }
  }

  reinitializeStateAndClearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    formKey.currentState?.reset();
    state = SignupInitialState();
  }
}

final signupControllerProvider =
    NotifierProvider<SignupController, SignupStates>(SignupController.new);
