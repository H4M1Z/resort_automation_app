import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resort_automation_app/core/extensions/pop_up_messages.dart';
import 'package:resort_automation_app/core/services/user_profile_service.dart';
import 'package:resort_automation_app/pages/setting_tab/controller/setting_tab_controller.dart';

@immutable
sealed class ProfilePageStates {
  const ProfilePageStates();
}

@immutable
final class ProfileLoadingState extends ProfilePageStates {}

@immutable
final class ProfileLoadedState extends ProfilePageStates {
  final String name, email, image;
  const ProfileLoadedState({
    required this.name,
    required this.email,
    required this.image,
  });
}

@immutable
final class ProfilePicPickedState extends ProfilePageStates {
  final String image;
  const ProfilePicPickedState({required this.image});
}

@immutable
final class ProfileErrorState extends ProfilePageStates {
  final String image, message;

  const ProfileErrorState({required this.image, required this.message});
}

class ProfilePageController extends Notifier<ProfilePageStates> {
  //.......CONTROLLERS
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  //..........FORM KEY
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _userImage = '';
  var _name = '';
  var _email = '';
  bool isEnabled = false;

  @override
  build() {
    log('profile controller built');

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    ///....DISPOSE OFF THE CONTROLELRS
    ref.onDispose(() {
      log('profile provider disposed');
      nameController.dispose();
      emailController.dispose();
      passwordController.dispose();
    });

    return ProfileLoadingState();
  }

  //.........SERVICES
  final UserProfileService _userProfileService = UserProfileService();

  fetchUserDetails() async {
    state = ProfileLoadingState();
    final user = await _userProfileService.getUser();

    if (user != null) {
      state = ProfileLoadedState(
        name: user.userName,
        email: user.email,
        image: user.profilePic,
      );
      nameController.text = _name = user.userName;
      emailController.text = _email = user.email;
    } else {
      state =
          const ProfileErrorState(image: '', message: 'Something went wrong!');
    }
  }

  updateUserDetails(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        //....................IF THE FIELDS ARE CHANGED ONLY UPDATE IN THAT CASE OTHER WISE DONOT UPDATE
        if (_isUpdated()) {
          bool shouldUpdateEmail = false;
          final (userName, userEmail, password) = (
            nameController.text.trim(),
            emailController.text.trim(),
            passwordController.text.trim()
          );

          if (_email != emailController.text.trim()) {
            shouldUpdateEmail = true;
            log('email should be updated');
            context.showPopUpMsg(
                'Email reset sent to your mail! Check your inbox.',
                seconds: 10);
          }

          var detailsUpdated = false;
          if (password.isEmpty) {
            detailsUpdated = await _userProfileService.updateUserDetails(
              name: userName,
              email: userEmail,
              image: _userImage,
              updateEmail: shouldUpdateEmail,
            );
          } else {
            detailsUpdated = await _userProfileService.updateUserDetails(
              name: userName,
              email: userEmail,
              image: _userImage,
              password: password,
              updateEmail: shouldUpdateEmail,
            );
            passwordController.clear();
          }

          if (detailsUpdated) {
            FocusManager.instance.primaryFocus?.unfocus();
            fetchUserDetails();
            ref.read(settingTabControllerProvider.notifier).reinitializeState();
          } else {
            state = ProfileErrorState(
              image: _userImage,
              message: "Couldn't update details",
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        state = ProfileErrorState(
          image: _userImage,
          message: e.message ?? 'Something went wrong',
        );
      } catch (e) {
        state = ProfileErrorState(
          image: _userImage,
          message: "Something went wrong!",
        );
      }
    }
  }

  _isUpdated() {
    return _name != nameController.text.trim() ||
        _email != emailController.text.trim() ||
        passwordController.text.trim().isNotEmpty ||
        _userImage.isNotEmpty;
  }

  onEditImageClicked() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _userImage = pickedImage.path;
      state = ProfilePicPickedState(image: _userImage);
    }
  }

  initializeValues(
      {required String name,
      required String email,
      required String image,
      required bool isEnabled}) {
    _name = name;
    _email = email;
    _userImage = image;
    this.isEnabled = !isEnabled;
    state = ProfileLoadedState(name: name, email: email, image: image);
    nameController.text = name;
    emailController.text = email;
  }
}

final profilePageController =
    NotifierProvider<ProfilePageController, ProfilePageStates>(
        ProfilePageController.new);
