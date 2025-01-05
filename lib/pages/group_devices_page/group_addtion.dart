import 'package:flutter/material.dart';

class GroupDevicesPage extends StatelessWidget {
  const GroupDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group Devices")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Placeholder for device count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.device_hub),
                    title: Text("Device ${index + 1}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        // Remove device from group logic
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to add more devices page
              },
              icon: const Icon(Icons.add),
              label: const Text("Add More Devices"),
            ),
          ],
        ),
      ),
    );
  }
}
