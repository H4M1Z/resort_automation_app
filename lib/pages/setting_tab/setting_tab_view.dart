import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/pages/profile_page/profile_page.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/utils/asset_images.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  bool _isDarkTheme = false;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const ListTile(
                leading: Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(profileImage),
                  ),
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
                    ref.read(themeStateProvider.notifier).toggleTheme(value);
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              subtitle: const Text("Sign out of your account"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Perform logout operation
              },
            ),
          ],
        ),
      ),
    );
  }
}
