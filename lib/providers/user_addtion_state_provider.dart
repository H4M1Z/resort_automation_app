import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/user_collection.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/model_classes/user.dart';
import 'package:home_automation_app/utils/asset_images.dart';

class UserAddtionStateProvider extends ChangeNotifier {
  UserCollection userCollection = UserCollection();
  void addUser() async {
    User user = User(
        userName: "Umair",
        userId: "user1",
        email: "programmerUmair29@gmail.com",
        profilePic: profileImage,
        createdAt: DateTime.now(),
        themePreferences: "${ThemePrefrences.light}",
        lastLogin: DateTime.now());
    await userCollection.addUser(user);
    notifyListeners();
  }
}
