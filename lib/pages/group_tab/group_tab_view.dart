import 'package:flutter/material.dart';

class GroupTab extends StatelessWidget {
  const GroupTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groups")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Groups",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ListTile(
              title: const Text("Living Room"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Master toggle logic
                },
                child: const Text("Toggle All"),
              ),
            ),
            ListTile(
              title: const Text("Kitchen"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Master toggle logic
                },
                child: const Text("Toggle All"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
