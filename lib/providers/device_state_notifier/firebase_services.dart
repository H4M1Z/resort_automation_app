import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resort_automation_app/core/model_classes/device.dart';
import 'package:resort_automation_app/core/model_classes/device_group.dart';

class FirebaseServices {
  static FirebaseServices? _instance;

  FirebaseServices._();

  factory FirebaseServices() => _instance ??= FirebaseServices._();

  // static DeviceCollection deviceCollection = DeviceCollection();
  final _firestore = FirebaseFirestore.instance;
  static const roomsCollection = 'Rooms';

  Future<List<Device>> getAllDevices(String roomNo) async {
    log("In get all Devices method");
    // Set loading state before fetching data
    try {
      final devices = await _firestore
          .collection(roomsCollection)
          .doc('Room No. $roomNo')
          .collection('Devices')
          .get();
      return devices.docs.map((e) {
        return Device.fromJson(e.data());
      }).toList();
    } catch (e) {
      log("Error getting all devices in firebase class: ${e.toString()}");
      return [];
    }
  }

  listenToDevices(String roomNo) {
    log('listening to devices');
    return _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomNo')
        .collection('Devices')
        .snapshots()
        .map(
      (event) {
        List<Device> devices = [];

        for (var deviceDoc in event.docs) {
          final device = Device.fromJson(deviceDoc.data());
          devices.add(device);
        }
        return devices;
      },
    );
  }

  // // Update device state
  // void updateDeviceStateFromFetchedDevices(Device device) {
  //   final attribute = getDeviceAttributeAccordingToDeviceType(device.type);
  //   log("Device status = ${device.status}, map Device type = ${mapDeviceType(device.type)}");
  // }

  updateDeviceStatus(String roomNo, String deviceId, String status) async {
    return await _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomNo')
        .collection('Devices')
        .doc(deviceId)
        .update({
      'status': status,
    });
  }

  updateGroupStatus(String roomNumber, bool value) async {
    await _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomNumber')
        .update({'groupValue': value});
  }

  Future<void> updateDeviceStatusOnToggleSwtich(
      String roomNo, String deviceId, String status) async {
    log("command in update Device status method: $status");
    log("device Id  update Device status method: $deviceId");
    return await _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomNo')
        .collection('Devices')
        .doc(deviceId)
        .update({
      'status': status,
    });
  }

  getDeviceStatus(String roomNo, String deviceId) async {
    final device = await _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomNo')
        .collection('Devices')
        .doc(deviceId)
        .get();

    return device.data()!['status'];
  }

  // static Future<void> updateDeviceStatusOnChangingSlider(String userId,
  //     Device device, String command, String attributeType) async {
  //   await deviceCollection.updateDeviceAttribute(
  //       userId, device.deviceId, command, attributeType);
  // }

  getRoom(String roomNumber) async {
    final roomMap = await _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomNumber')
        .get();
    return DeviceGroup.fromMap(roomMap.data()!);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenToRoom(String roomId) {
    log('room id in listening room : $roomId');
    return _firestore
        .collection(roomsCollection)
        .doc('Room No. $roomId')
        .snapshots()
        .asBroadcastStream();
  }
}
