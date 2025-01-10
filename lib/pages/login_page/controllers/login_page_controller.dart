// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_validation/form_validation.dart';
import 'package:home_automation_app/core/commom/mixins/auth_behaviour.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';
import 'package:home_automation_app/core/services/user_profile_service.dart';
import 'package:home_automation_app/main.dart';

import '../../../core/model_classes/sign_in_model.dart';
import '../../../core/model_classes/user_model.dart';
import '../../../core/services/auth_services.dart';

sealed class UserSigninStates {}

class UserSigninInitialState implements UserSigninStates {}

class UserSigninLoadedState implements UserSigninStates {}

class UserSigninLoadingState implements UserSigninStates {}

class UserSigninErrorState implements UserSigninStates {
  final String errorMessage;
  UserSigninErrorState({required this.errorMessage});
}

class LoginPageController extends Notifier<UserSigninStates>
    with AuthBehaviour {
  //.....CONSTANT VALUES
  static const _errorMessage = 'Something went wrong!';

  //......TEXT CONTROLLERS
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
    emailController = TextEditingController();
    passwordController = TextEditingController();

    //....DISPOSE OFF THE CONTROLLERS
    ref.onDispose(
      () {
        emailController.dispose();
        passwordController.dispose();
      },
    );
    return UserSigninInitialState();
  }

  String? emailValidation(String? value) =>
      const EmailValidator().validate(label: 'Email', value: value);

  onLoginClicked() async {
    if (formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: 'Loging in...');
      state = UserSigninLoadingState();
      try {
        //.....SIGN IN THE USER WITH THE EMAIL AND PASSWORD
        final user = await _authService.userSigin(
            signInModel: SignInModel(
          email: emailController.text.trimLeft(),
          password: passwordController.text.trimLeft(),
        ));

        if (user != null) {
          final isUserInserted =
              await _userManagementService.insertUserUid(user.uid);
          final isUserSignedIn =
              await _userManagementService.insertIsUserSignedIn(true);
          final providerInserted = await _userManagementService
              .insertIsUserSignedInUsingProvider(false);
          if (isUserInserted && isUserSignedIn && providerInserted) {
            globalUserId = user.uid;

            state = UserSigninLoadedState();
          } else {
            state = UserSigninErrorState(
                errorMessage: 'Error in shared prefrences');
          }
        } else {
          state = UserSigninErrorState(errorMessage: 'User is null');
          log('user is null');
        }
      } on FirebaseAuthException catch (e) {
        state = UserSigninErrorState(
          errorMessage: handleAuthException(e.code),
        );
      } on FirebaseException catch (e) {
        log(e.toString());
        state = UserSigninErrorState(
          errorMessage: _errorMessage,
        );
      } catch (e) {
        log(e.toString());
        state = UserSigninErrorState(
          errorMessage: _errorMessage,
        );
      }
    }
  }

  onGoogleSignInClicked(BuildContext context) async {
    try {
      //......SIGN IN USER WITH GOOGLE
      User? user = await _authService.userGoogleSignIn();
      if (user != null) {
        //......UPDATE THE DISPLAY NAME TO USE ACROSS THE APP
        user.updateDisplayName(user.displayName);
        //...INSERT USER UID IN SHARED PREFRENCES TO ACCESS ANYWHERE IN THE APP
        await _userManagementService.insertUserUid(user.uid);
        //.....ADD THE USER TO FIREABSE
        await _profileService.addUser(
          UserModel(
            userName: user.displayName!,
            email: user.email!,
            userId: user.uid,
            profilePic: '',
            createdAt: DateTime.now(),
            themePreferences: '${ThemePrefrences.light}',
            lastLogin: DateTime.now(),
          ),
        );
        //.....INSERT THAT THE USER IS SIGNED IN
        var isSignedIn =
            await _userManagementService.insertIsUserSignedIn(true);
        //...........INSERT THAT USER IS SIGNED IN USING PROVIDER
        await _userManagementService.insertIsUserSignedInUsingProvider(true);
        //....IF USER IS SIGNED IN SUCCESSFULLY SET LOADED STATE ELSE ERROR
        switch (isSignedIn) {
          case true:
            globalUserId = user.uid;
            state = UserSigninLoadedState();
            break;
          default:
            state = UserSigninErrorState(errorMessage: 'Something went wrong');
        }
      } else {
        state = UserSigninErrorState(
            errorMessage: 'please choose an existing account');
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      state = UserSigninErrorState(errorMessage: handleAuthException(e.code));
    } catch (e) {
      log(e.toString());
      state = UserSigninErrorState(errorMessage: _errorMessage);
    }
  }

  onAppleSignInClicked() async {
    try {
      state = UserSigninLoadingState();
      await _authService.appleSignIn();
    } on SocketException catch (e) {
      log(e.toString());
      state = UserSigninErrorState(errorMessage: 'Internet connection failed!');
    } catch (e) {
      log(e.toString());
      state = UserSigninErrorState(errorMessage: 'Something went wrong!');
    }
  }

  reinitialzeStateAndClearControllers() {
    state = UserSigninInitialState();
    emailController.clear();
    passwordController.clear();
  }
}

final loginControllerProvider =
    NotifierProvider<LoginPageController, UserSigninStates>(
        LoginPageController.new);
