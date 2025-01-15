import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/config/service_locator.dart';
import 'package:home_automation_app/core/collections/user_collection.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/model_classes/user_model.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';
import 'package:home_automation_app/utils/asset_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define the NotifierProvider
final userStateProvider = NotifierProvider<UserStateNotifier, void>(
  UserStateNotifier.new,
);

// UserAdditionNotifier class
class UserStateNotifier extends Notifier<void> {
  final UserCollection userCollection = UserCollection();

  @override
  void build() {
    // No state to initialize since this is a side-effect notifier
  }

  // Method to add a user

  void setUserData() async {
    try {
      var sr = serviceLocator.get<UserManagementService>();
      if (await sr.isUserSignedIn()) {
        UserModel user = await userCollection.getUser(sr.getUserUid()!);
        sr.setUserName(user.userName);
        sr.setUserProfilePic(user.profilePic);
      }
    } catch (e) {
      log("Error getting user data: ${e.toString()}");
    }
  }
}

abstract class UserDataStates {}

class UserDataInitialState {}

class UserDataLoadingState {}

class UserDataLoadedState {
  final UserModel user;
  UserDataLoadedState({required this.user});
}

class UserDataErrorState {
  final String data;
  UserDataErrorState({required this.data});
}
