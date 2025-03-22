import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/commom/mixins/auth_behaviour.dart';
import 'package:resort_automation_app/core/services/auth_services.dart';

@immutable
sealed class ForgotPasswordStates {
  const ForgotPasswordStates();
}

@immutable
final class ForgotPasswordInitialState extends ForgotPasswordStates {}

@immutable
final class ForgotPasswordLoadingState extends ForgotPasswordStates {}

@immutable
final class ForgotPasswordLoadedState extends ForgotPasswordStates {
  final String message = 'Password reset email sent! Check your inbox.';
}

@immutable
final class ForgotPasswordErrorState extends ForgotPasswordStates {
  final String error;
  const ForgotPasswordErrorState({required this.error});
}

class ForgotPasswordPageController extends Notifier<ForgotPasswordStates>
    with AuthBehaviour {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  ForgotPasswordStates build() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    ref.onDispose(
      () {
        emailController.dispose();
        passwordController.dispose();
        confirmPasswordController.dispose();
      },
    );

    return ForgotPasswordInitialState();
  }

  //...........SERVICES
  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);

  onChangedPasswordClicked() async {
    if (formKey.currentState!.validate()) {
      try {
        state = ForgotPasswordLoadingState();
        if (passwordController.text.trim() ==
            confirmPasswordController.text.trim()) {
          await _authService.changeUserPassword(emailController.text.trim());
          state = ForgotPasswordLoadedState();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        } else {
          state =
              const ForgotPasswordErrorState(error: "Passwords Doesn't match");
        }
      } on FirebaseAuthException catch (e) {
        state = ForgotPasswordErrorState(error: handleAuthException(e.code));
      } on FirebaseException catch (e) {
        log('[error] : ${e.message}');
        state = const ForgotPasswordErrorState(error: 'Something went wrong!');
      } catch (e) {
        log(e.toString());
        state = const ForgotPasswordErrorState(error: 'Something went wrong!');
      }
    }
  }
}

final forgotPasswordControllerProvider =
    NotifierProvider<ForgotPasswordPageController, ForgotPasswordStates>(
        ForgotPasswordPageController.new);
