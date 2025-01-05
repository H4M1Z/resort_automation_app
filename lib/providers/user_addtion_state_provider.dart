import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/collections/user_collection.dart';
import 'package:home_automation_app/core/enums.dart';
import 'package:home_automation_app/core/model_classes/user_model.dart';
import 'package:home_automation_app/utils/asset_images.dart';

// Define the NotifierProvider
final userAdditionProvider = NotifierProvider<UserAdditionNotifier, void>(
  UserAdditionNotifier.new,
);

// UserAdditionNotifier class
class UserAdditionNotifier extends Notifier<void> {
  final UserCollection userCollection = UserCollection();

  @override
  void build() {
    // No state to initialize since this is a side-effect notifier
  }

  // Method to add a user
  Future<void> addUser() async {
    final user = UserModel(
      userName: "Umair",
      userId: "user1",
      email: "programmerUmair29@gmail.com",
      profilePic: profileImage,
      createdAt: DateTime.now(),
      themePreferences: "${ThemePrefrences.light}",
      lastLogin: DateTime.now(),
    );

    await userCollection.addUser(user);

    // Notify listeners if needed by triggering a rebuild
    state = null;
  }
}
