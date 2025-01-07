import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/services/auth_services.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';

class SettingTabController extends Notifier<void> {
  @override
  build() {}

  //........SERVICES
  final UserManagementService _userManagementService = UserManagementService();
  final AuthService _authService = AuthService(auth: FirebaseAuth.instance);

  onLogOutClicked() {
    _authService.signOut();
    _userManagementService.insertIsUserSignedIn(false);
  }
}

final settingTabControllerProvider =
    NotifierProvider<SettingTabController, void>(SettingTabController.new);
