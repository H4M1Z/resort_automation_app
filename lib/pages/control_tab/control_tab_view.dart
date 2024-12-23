import 'package:flutter/material.dart';
import 'package:home_automation_app/pages/add_device_tab/new_tab_view.dart';

class ControlTab extends StatelessWidget {
  const ControlTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Control Devices")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Devices",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text("Living Room Light"),
                trailing: Switch(value: false, onChanged: (value) {}),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.ac_unit),
                title: const Text("Fan"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(value: false, onChanged: (value) {}),
                    const SizedBox(width: 8),
                    Slider(
                      value: 50,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: "50%",
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Add Devices Tab
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddDevicesTab()));
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Devices"),
            ),
          ],
        ),
      ),
    );
  }
}
