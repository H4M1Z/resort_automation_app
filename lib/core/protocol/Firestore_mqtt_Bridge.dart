// Updated Firestore Listener
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/core/collections/device_collection.dart';
import 'package:home_automation_app/core/collections/user_collection.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';

Future<void> startListeningToFirestore(
    BuildContext context, String userId, MqttService mqttService) async {
  if (!mqttService.isConnected) {
    await mqttService.connect();
  }

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

            switch (deviceType) {
              case 'Bulb':
                attributeValue = attributes['Brightness'];
                break;
              case 'Fan':
                attributeValue = attributes['Speed'];
                break;
              default:
                attributeValue = attributes['CustomAttribute'];
                break;
            }

            // if (mqttService.isConnected) {
            //   publishDeviceUpdate(
            //     userId,
            //     deviceId,
            //     status,
            //     deviceType,
            //     attributeValue,
            //     mqttService,
            //   );
            // } else {
            //   Fluttertoast.showToast(
            //       msg: 'MQTT not connected. Skipping update for $deviceId.');
            // }
          }
        }
      }
    }
  });
}

void publishDeviceUpdate(
  String deviceName,
  String userId,
  String deviceId,
  String status,
  String deviceType,
  String? attributeValue,
  MqttService mqttService,
) {
  final topic = 'user/$userId/device/$deviceId/status';
  final message = {
    'deviceId': deviceId,
    'deviceName': deviceName,
    'status': status,
    'type': deviceType,
    'attribute': attributeValue ?? '',
  };
  mqttService.publishMessage(topic, message.toString());
  log('Published device update: $message');
}
