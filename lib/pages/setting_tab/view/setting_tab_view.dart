import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/config/navigation/route_navigation.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/dialogs/logout_dialog.dart';
import 'package:resort_automation_app/core/services/user_management_service.dart';
import 'package:resort_automation_app/pages/profile_page/profile_page.dart';
import 'package:resort_automation_app/pages/setting_tab/controller/setting_tab_controller.dart';
import 'package:resort_automation_app/themes/state_provider.dart';
import 'package:resort_automation_app/utils/asset_images.dart';

import 'widgets/setting_tab_widget.dart';

class SettingsTab extends ConsumerStatefulWidget {
  static const pageName = '/settings';
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends ConsumerState<SettingsTab> {
  // Function to launch a URL (for Help or Rate Us)
  Future<void> _launchURL(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    String userProfilePic = "";
    var sl = serviceLocator.get<UserManagementService>();
    if (sl.isUserProfileUrlInPrefs()) {
      userProfilePic = sl.getUserPicUrl();
    }
    log("User image Url in Prefs: $userProfilePic");

    final size = MediaQuery.sizeOf(context); // Responsive screen size
    final height = size.height;
    final width = size.width;

    final settingsController = ref.read(settingTabControllerProvider.notifier);
    final themeProvider = ref.read(themeStateProvider.notifier);

    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(settingTabControllerProvider.notifier).reinitializeState();
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, // Dynamic horizontal padding
              vertical: height * 0.02, // Dynamic vertical padding
            ),
            child: Column(
              children: [
                SizedBox(height: height * 0.15), // Top space is dynamic
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProfilePage.pageName,
                      arguments: ProfilePageArguments(
                        image: settingsController.image,
                        name: settingsController.name,
                        email: settingsController.email,
                        isEnabled: settingsController.isEnabled,
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Hero(
                      tag: 'profileImage',
                      child: ProfileWidget(
                        profileImageUrl: profileImage,
                      ),
                    ),
                    title: Text("Profile"),
                    subtitle: Text("Edit your profile settings"),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
                // Custom Dark Mode Tile with Icon
                ListTile(
                  leading: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color:
                        isDark ? Colors.amber : Theme.of(context).primaryColor,
                    size: 28, // Adjust the size of the icon
                  ),
                  title: const Text(
                    "Dark Mode",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  trailing: Switch(
                    value: isDark,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveThumbColor: Colors.grey.shade300,
                    inactiveTrackColor: Colors.grey.shade400,
                    onChanged: (value) {
                      sl.setTheme(value);
                      themeProvider.toggleTheme(value);
                    },
                  ),
                  onTap: () {
                    // Trigger the theme change when the user taps the tile
                    // sl.setTheme(isDark);
                    // themeProvider.toggleTheme(!isDark);
                  },
                ),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ListTile(
                        leading: Icon(Icons.info,
                            color: isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        title: const Text("About App"),
                        subtitle: const Text("View app version and details"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: "Home Automation App",
                            applicationVersion: "1.0.0",
                            applicationIcon: const Icon(Icons.home),
                            children: [
                              const Text(
                                  "This app helps manage your IoT devices."),
                            ],
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.help,
                          color: isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        title: const Text("Help"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          _launchURL('https://yourapphelpurl.com');
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.qr_code,
                          color: isDark
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                        ),
                        title: const Text("Qr Code"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.star,
                            color: isDark
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        title: const Text("Rate Us"),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          _launchURL(
                              'https://play.google.com/store/apps/details?id=com.yourapp');
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return ListTile(
                            leading: Icon(Icons.logout,
                                color: isDark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
                            title: const Text("Logout"),
                            subtitle: const Text("Sign out of your account"),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              showLogoutConfirmationDialog(context, ref);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.15, // Dynamic header height
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: width * 0.04),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
