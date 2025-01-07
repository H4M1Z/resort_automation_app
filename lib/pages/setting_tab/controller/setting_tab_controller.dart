import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/services/auth_services.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';

import '../../../core/services/user_profile_service.dart';

@immutable
sealed class SettingsTabStates {
  const SettingsTabStates();
}

@immutable
final class SettingsTabInitialState extends SettingsTabStates {}

@immutable
final class SettingsTabLoadigState extends SettingsTabStates {}

@immutable
final class SettingsTabLoadedState extends SettingsTabStates {
  final String image;
  const SettingsTabLoadedState({required this.image});
}

@immutable
final class SettingsTabErrorState extends SettingsTabStates {}

class SettingTabController extends Notifier<SettingsTabStates> {
  @override
  build() {
    return SettingsTabLoadigState();
  }

  //........SERVICES
  final UserManagementService _userManagementService = UserManagementService();
  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);
  final UserProfileService _userProfileService = UserProfileService();

  //............VARIABLES
  var name, email, isEnabled, image;

  onLogOutClicked() {
    try {
      _authService.signOut();
      _userManagementService.insertIsUserSignedIn(false);
      state = SettingsTabInitialState();
    } catch (e) {
      log(e.toString());
    }
  }

  /////.................PROFILE PAGE KO SMABHALNA HAY AB

  //...........FETCH USER DETAILS
  fetchUserDetails() async {
    state = SettingsTabLoadigState();
    final user = await _userProfileService.getUser();
    isEnabled = await _userManagementService.isUserSignedInUsingProvider();
    if (user != null) {
      name = user.userName;
      email = user.email;
      image = user.profilePic;
      state = SettingsTabLoadedState(
        image: user.profilePic,
      );
    } else {
      state = SettingsTabErrorState();
    }
  }

  reinitializeState() {
    state = SettingsTabLoadigState();
  }
}

final settingTabControllerProvider =
    NotifierProvider<SettingTabController, SettingsTabStates>(
        SettingTabController.new);
