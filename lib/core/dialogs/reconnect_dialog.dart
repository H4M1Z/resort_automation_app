import 'package:flutter/material.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';

Future<bool?> showReconnectionDialog(BuildContext context) async {
  MqttService mqttService = MqttService();
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "You are again connected to the internet",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Do you want to reconnect to MQTT?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return `false` for "Cancel"
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
              mqttService.connect();
              Navigator.of(context).pop(true); // Return `true` for "Reconnect"
            },
            child: const Text("Reconnect"),
          ),
        ],
      );
    },
  );
}
