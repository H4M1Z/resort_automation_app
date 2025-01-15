import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/config/navigation/route_navigation.dart';
import 'package:home_automation_app/core/dialogs/logout_dialog.dart';
import 'package:home_automation_app/pages/profile_page/profile_page.dart';
import 'package:home_automation_app/pages/setting_tab/controller/setting_tab_controller.dart';
import 'package:home_automation_app/themes/state_provider.dart';

import 'widgets/setting_tab_widget.dart';

class SettingsTab extends ConsumerStatefulWidget {
  static const pageName = '/settings';
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends ConsumerState<SettingsTab> {
  final bool _isDarkTheme = false;

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
    final settingsController = ref.read(settingTabControllerProvider.notifier);
    final themeProvider = ref.read(themeStateProvider.notifier);
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(settingTabControllerProvider.notifier).reinitializeState();
      },
    );
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProfilePage.pageName,
                    arguments: ProfilePageArguments(
                        image: settingsController.image,
                        name: settingsController.name,
                        email: settingsController.email,
                        isEnabled: settingsController.isEnabled),
                  );
                },
                child: const ListTile(
                  leading: Hero(
                    tag: 'profileImage',
                    child: ProfileWidget(),
                  ),
                  title: Text("Profile"),
                  subtitle: Text("Edit your profile settings"),
                  trailing: Icon(Icons.arrow_forward),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  // Watch the current theme mode from the provider
                  final isDarkTheme =
                      ref.watch(themeStateProvider) == ThemeMode.dark;

                  return SwitchListTile(
                    title: const Text("Dark Mode"),
                    value: isDarkTheme,
                    onChanged: (value) {
                      // Use ref to call the toggleTheme method
                      themeProvider.toggleTheme(value);
                    },
                  );
                },
              ),
              // App Version
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About App"),
                subtitle: const Text("View app version and details"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  // Show App Info Dialog
                  showAboutDialog(
                    context: context,
                    applicationName: "Home Automation App",
                    applicationVersion: "1.0.0",
                    applicationIcon: const Icon(Icons.home),
                    children: [
                      const Text("This app helps manage your IoT devices."),
                    ],
                  );
                },
              ),
              // Help List Tile
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text("Help"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  _launchURL(
                      'https://yourapphelpurl.com'); // Replace with your actual help URL
                },
              ),
              // Rate Us List Tile
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text("Rate Us"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  _launchURL(
                      'https://play.google.com/store/apps/details?id=com.yourapp'); // Replace with your app's URL
                },
              ),
              // Logout Option
              Consumer(
                builder: (context, ref, child) {
                  return ListTile(
                    leading: const Icon(Icons.logout),
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
      ),
    );
  }
}
