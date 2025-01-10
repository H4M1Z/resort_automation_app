import 'dart:developer';

import 'package:home_automation_app/core/protocol/mqt_service.dart';

// void sendUserIdToHardware(String userId, MqttService mqttService) {
//   final topic = 'user/$userId/init';
//   final message = {'userId': userId};

//   if (mqttService.isConnected) {
//     mqttService.publishMessage(topic, message.toString());
//     log('User ID sent to hardware: $message');
//   } else {
//     log('Failed to send User ID. MQTT is not connected.');
//   }
// }
