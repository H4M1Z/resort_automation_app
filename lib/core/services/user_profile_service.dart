import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';

import '../model_classes/user_model.dart';

class UserProfileService {
  //......User Collection Ref
  static const _userCollection = 'User Collection';

  static UserProfileService? _userProfileService;

  final UserManagementService _userService = UserManagementService();

  UserProfileService._();

  factory UserProfileService() =>
      _userProfileService ??= UserProfileService._();

  Future<void> addUser(UserModel model) async {
    await FirebaseFirestore.instance
        .collection(_userCollection)
        .doc(model.userId)
        .set(model.toJson());
  }

  Future<UserModel?> getUser() async {
    var userId = _userService.getUserUid();
    UserModel? userModel;
    if (userId != null) {
      var user = await FirebaseFirestore.instance
          .collection(_userCollection)
          .doc(userId)
          .get();
      userModel = UserModel.fromJson(user.data()!);
      return userModel;
    } else {
      log('error fetching user');
      return userModel;
    }
  }

  updateUserDetails(
      {required String name,
      required String phoneNumber,
      required String email,
      required String image}) async {
    final userId = _userService.getUserUid();
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection(_userCollection)
            .doc(userId)
            .update({
          'email': email,
          'image': image,
          'name': name,
          'phoneNo': phoneNumber,
        });
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
