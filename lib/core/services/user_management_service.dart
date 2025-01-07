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

  Future<bool> insertIsUserSignedInUsingProvider(
      bool isSignedInUsingProvider) async {
    SharedPreferences sharedPref = serviceLocator.get<SharedPreferences>();
    return await sharedPref.setBool(
        SharedPrefKeys.kisUserSignedInUsingProvider, isSignedInUsingProvider);
  }

  Future<bool> isUserSignedInUsingProvider() async {
    SharedPreferences sharedPref = serviceLocator.get<SharedPreferences>();
    bool? isSignedInUsingProvider =
        sharedPref.getBool(SharedPrefKeys.kisUserSignedInUsingProvider);
    if (isSignedInUsingProvider != null) {
      return isSignedInUsingProvider;
    } else {
      return false;
    }
  }

  Future<bool> isUserSignedIn() async {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    bool? isSignedIn =
        sharedPreferences.getBool(SharedPrefKeys.kisUserSignedin);
    if (isSignedIn != null) {
      return isSignedIn;
    } else {
      return false;
    }
  }
}
