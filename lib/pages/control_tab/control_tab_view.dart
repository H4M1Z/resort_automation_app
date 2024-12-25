import 'package:flutter/material.dart';
import 'package:home_automation_app/core/dialogs/dialogs.dart';
import 'package:home_automation_app/pages/add_device_tab/new_tab_view.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:provider/provider.dart';

class ControlTab extends StatefulWidget {
  const ControlTab({super.key});

  @override
  State<ControlTab> createState() => _ControlTabState();
}

class _ControlTabState extends State<ControlTab> {
  @override
  void initState() {
    super.initState();
    context.read<AddDeviceTypeAdditionProvider>().getAllDevices();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<AddDeviceTypeAdditionProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Control Devices")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                "Devices",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Spacer(flex: 5),
            Expanded(
              flex: 70,
              child: ListView.builder(
                itemCount: deviceProvider.devicesList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                          Icons.device_hub), // Add custom icons if needed
                      title: Text(
                        deviceProvider.devicesList[index].deviceName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: const Icon(Icons.settings),
                      onTap: () => showDeviceDialog(context, index),
                    ),
                  );
                },
              ),
            ),
            const Spacer(flex: 5),
            Expanded(
              flex: 10,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddDevicesTab(),
                  ));
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Devices"),
              ),
            ),
            const Spacer(flex: 15),
          ],
        ),
      ),
    );
  }
}
