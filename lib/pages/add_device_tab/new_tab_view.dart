import 'package:flutter/material.dart';

class AddDevicesTab extends StatelessWidget {
  const AddDevicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Devices")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const TextField(
                decoration: InputDecoration(labelText: "Device Name"),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Add light device logic
                },
                child: const Text("Add"),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.ac_unit),
              title: const TextField(
                decoration: InputDecoration(labelText: "Device Name"),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  // Add fan device logic
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
