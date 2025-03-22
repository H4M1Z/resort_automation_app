// Updated Firestore Listener
import 'dart:convert';
import 'dart:developer';

import 'package:resort_automation_app/core/protocol/mqt_service.dart';

// Future<void> startListeningToFirestore(
//     BuildContext context, String userId, MqttService mqttService) async {
//   if (!mqttService.isConnected) {
//     await mqttService.connect();
//   }

//   UserCollection.userCollection
//       .doc(userId)
//       .collection(DeviceCollection.deviceCollection)
//       .snapshots()
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       if (change.type == DocumentChangeType.modified) {
//         final deviceData = change.doc.data();

//         if (deviceData != null) {
//           final deviceId = deviceData['deviceId'];
//           final status = deviceData['status'];
//           final attributes = deviceData['attributes'];

//           if (deviceId != null && status != null && attributes != null) {
//             final deviceType = deviceData['type'];
//             String? attributeValue;

//             switch (deviceType) {
//               case 'Bulb':
//                 attributeValue = attributes['Brightness'];
//                 break;
//               case 'Fan':
//                 attributeValue = attributes['Speed'];
//                 break;
//               default:
//                 attributeValue = attributes['CustomAttribute'];
//                 break;
//             }

//             // if (mqttService.isConnected) {
//             //   publishDeviceUpdate(
//             //     userId,
//             //     deviceId,
//             //     status,
//             //     deviceType,
//             //     attributeValue,
//             //     mqttService,
//             //   );
//             // } else {
//             //   Fluttertoast.showToast(
//             //       msg: 'MQTT not connected. Skipping update for $deviceId.');
//             // }
//           }
//         }
//       }
//     }
//   });
// }

void publishDeviceUpdate(
  String roomNumber,
  String deviceId,
  String status,
  String? attributeValue,
  MqttService mqttService,
) {
  final topic = 'roomNo/$roomNumber/device/$deviceId/status';
  final message = {
    'deviceId': deviceId,
    'status': status,
    'attribute': attributeValue ?? '',
  };
  final jsonMessage = jsonEncode(message);
  mqttService.publishMessage(topic, jsonMessage);
  log('Published device update: $message');
}
