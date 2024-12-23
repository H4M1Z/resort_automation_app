import 'package:flutter/material.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:home_automation_app/utils/asset_images.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  bool _isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage(profileImage),
              ),
              title: const Text("Profile"),
              subtitle: const Text("Edit your profile settings"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Profile Settings
              },
            ),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: context.watch<ThemeStateNotifier>().isDarkTheme,
              onChanged: (value) {
                context.read<ThemeStateNotifier>().toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
