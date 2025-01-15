import 'package:home_automation_app/config/service_locator.dart';
import 'package:home_automation_app/core/enums.dart';
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

  bool isUserNameInPrefs() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    String? isUserName = sharedPreferences.getString(SharedPrefKeys.kUserName);
    if (isUserName != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isUserProfileUrlInPrefs() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    String? isUserProfilePicUrl =
        sharedPreferences.getString(SharedPrefKeys.kUserPicUrl);
    if (isUserProfilePicUrl != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> setUserProfilePic(String profilePicUrl) async {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    await sharedPreferences.setString(
        SharedPrefKeys.kUserPicUrl, profilePicUrl);
  }

  Future<void> setUserName(String userName) async {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    await sharedPreferences.setString(SharedPrefKeys.kUserName, userName);
  }

  String getUserName() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    String? userName = sharedPreferences.getString(SharedPrefKeys.kUserName);
    if (userName != null) {
      return userName;
    } else {
      return '';
    }
  }

  String getUserPicUrl() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    String? userPicUrl =
        sharedPreferences.getString(SharedPrefKeys.kUserPicUrl);
    if (userPicUrl != null) {
      return userPicUrl;
    } else {
      return '';
    }
  }

  void setTheme(bool isDarkTheme) {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    sharedPreferences.setBool(SharedPrefKeys.kThemePrefrences, isDarkTheme);
  }

  bool isThemeAddedInPrefs() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    bool? isThemeAdded =
        sharedPreferences.getBool(SharedPrefKeys.kThemePrefrences);
    if (isThemeAdded != null) {
      return isThemeAdded;
    } else {
      return false;
    }
  }

  bool getCurrentTheme() {
    SharedPreferences sharedPreferences =
        serviceLocator.get<SharedPreferences>();
    bool isThemeAdded =
        sharedPreferences.getBool(SharedPrefKeys.kThemePrefrences) ?? false;
    return isThemeAdded;
  }
}
