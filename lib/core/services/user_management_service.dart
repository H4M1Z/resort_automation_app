import 'package:home_automation_app/config/service_locator.dart';
import 'package:home_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManagementService {
  static UserManagementService? userService;
  UserManagementService._();

  factory UserManagementService() => userService ??= UserManagementService._();

  Future<bool> insertUserUid(String uid) async {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    bool isInsert =
        await sharedPreferences.setString(SharedPrefKeys.kUserUID, uid);
    return isInsert;
  }

  String? getUserUid() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    String? uid = sharedPreferences.getString(SharedPrefKeys.kUserUID);
    return uid;
  }

  Future<bool> insertIsUserSignedIn(bool isUserSignin) async {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    bool isSingned = await sharedPreferences.setBool(
        SharedPrefKeys.kisUserSignedin, isUserSignin);
    return isSingned;
  }

  Future<bool?> isUserSignedIn() async {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    bool? isSingned = sharedPreferences.getBool(SharedPrefKeys.kisUserSignedin);
    return isSingned;
  }
}
