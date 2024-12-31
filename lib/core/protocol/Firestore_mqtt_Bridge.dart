import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/user_collection.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';

Future<void> startListeningToFirestore(
    BuildContext context, String userId, MqttService mqttService) async {
  await mqttService.connect();

  UserCollection.userCollection
      .doc(userId)
      .collection(DeviceCollection.deviceCollection)
      .snapshots()
      .listen((snapshot) {
    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.modified) {
        final deviceData = change.doc.data();

        if (deviceData != null) {
          final deviceId = deviceData['deviceId'];
          final status = deviceData['status'];
          final attributes = deviceData['attributes'];

          if (deviceId != null && status != null && attributes != null) {
            final deviceType = deviceData['type'];

            String? attributeValue;
            if (deviceType == 'Bulb') {
              attributeValue = attributes['Brightness'];
            } else if (deviceType == 'Fan') {
              attributeValue = attributes['Speed'];
            }

            if (mqttService.isConnected) {
              publishDeviceUpdate(
                userId,
                deviceId,
                status,
                deviceType,
                attributeValue,
                mqttService,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'MQTT not connected. Skipping device update for $deviceId.'),
                ),
              );
            }
          }
        }
      }
    }
  });
}

void publishDeviceUpdate(
  String userId,
  String deviceId,
  String status,
  String deviceType,
  String? attributeValue,
  MqttService mqttService,
) {
  final topic = 'user/$userId/device/$deviceId/status';
  final message = {
    'status': status,
    'type': deviceType,
    'attribute': attributeValue ?? '',
  };
  mqttService.publishMessage(topic, message.toString());
  log('Published device update: $message');
}
