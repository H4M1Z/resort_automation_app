import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:resort_automation_app/pages/login_page/view/login_page.dart';
import 'package:resort_automation_app/pages/setting_tab/controller/setting_tab_controller.dart';
import 'package:resort_automation_app/utils/strings/shared_pref_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Confirm Logout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to logout?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              SharedPreferences sharedPref =
                  serviceLocator.get<SharedPreferences>();
              await sharedPref
                  .remove(SharedPrefKeys.kisUserSignedInUsingProvider);
              await sharedPref.remove(SharedPrefKeys.kUserUID);
              await sharedPref.remove(SharedPrefKeys.kUserName);
              await sharedPref.remove(SharedPrefKeys.kUserPicUrl);
              await sharedPref.remove(SharedPrefKeys.kThemePrefrences);
              ref.read(bottomBarStateProvider.notifier).restoreState();
              // Perform logout action
              ref.read(settingTabControllerProvider.notifier).onLogOutClicked();
              Navigator.of(context).pop(); // Close the dialog
              Navigator.restorablePushNamedAndRemoveUntil(
                context,
                LoginScreen.pageName,
                (_) => false,
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      );
    },
  );
}
