import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resort_automation_app/core/model_classes/user_model.dart';

class UserCollection {
  static final UserCollection instance = UserCollection._internal();
  UserCollection._internal();
  static var userCollection =
      FirebaseFirestore.instance.collection('User Collection');
  factory UserCollection() {
    return instance;
  }

  Future<bool> addUser(UserModel user) async {
    try {
      await userCollection.doc(user.userId).set(user.toJson());
      return true;
    } catch (e) {
      log("Error adding user: $e");
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.userId).update(user.toJson());
      return true;
    } catch (e) {
      log("Error updating user: $e");
      return false;
    }
  }

  Future<bool> deleteUser(UserModel user) async {
    try {
      await userCollection.doc(user.userId).delete();
      return true;
    } catch (e) {
      log("Error updating user: $e");
      return false;
    }
  }

  Future<dynamic> getUser(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await userCollection.doc(userId).get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return UserModel.fromJson(userData);
    } catch (e) {
      log("Error getting user: $e");
      return false;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> users = [];
    try {
      QuerySnapshot userSnapshot = await userCollection.get();
      for (var doc in userSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
        users.add(UserModel.fromJson(userData));
      }
      return users;
    } catch (e) {
      log("Error getting all users: $e");
      return [];
    }
  }
}
