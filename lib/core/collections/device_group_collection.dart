import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_automation_app/core/collections/user_collection.dart';
import 'package:home_automation_app/core/model_classes/device_group.dart';

class DeviceGroupCollection {
  static final DeviceGroupCollection instance =
      DeviceGroupCollection._internal();
  DeviceGroupCollection._internal();
  static const deviceGroupCollection = "Device Group Collection";
  factory DeviceGroupCollection() {
    return instance;
  }

  Future<bool> addDeviceGroup(
      {required String userId, required DeviceGroup group}) async {
    try {
      await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(group.groupId)
          .set(group.toJson());
      return true;
    } catch (e) {
      log("Error adding device group: $e");
      return false;
    }
  }

  Future<bool> updateDeviceGroup(String userId, DeviceGroup group) async {
    try {
      await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(group.groupId)
          .update(group.toJson());
      return true;
    } catch (e) {
      log("Error updating device group: $e");
      return false;
    }
  }

  Future<bool> deleteDeviceGroup(String userId, String groupId) async {
    try {
      await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(groupId)
          .delete();
      return true;
    } catch (e) {
      log("Error deleting device group: $e");
      return false;
    }
  }

  Future<dynamic> getDeviceGroup(String userId, String groupId) async {
    try {
      DocumentSnapshot groupSnapshot = await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(groupId)
          .get();
      Map<String, dynamic> groupData =
          groupSnapshot.data() as Map<String, dynamic>;
      return DeviceGroup.fromJson(groupData);
    } catch (e) {
      log("Error getting device group: $e");
      return false;
    }
  }

  Future<bool> updateGroupStatus(
      String userId, String groupId, bool currentStatus) async {
    try {
      UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(groupId)
          .update({"currentStatus": currentStatus});
      return true;
    } catch (e) {
      log("Error updating group status: ${e.toString()}");
      return false;
    }
  }

  Future<bool> updateGroupIDs(
      String userId, String groupId, List<String> listOfIds) async {
    try {
      UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(groupId)
          .update({"deviceIds": listOfIds});
      return true;
    } catch (e) {
      log("Error updating group status: ${e.toString()}");
      return false;
    }
  }

  Future<dynamic> getDeviceGroupByName(String userId, String groupName) async {
    try {
      // Query Firestore to find a device group with the given name
      QuerySnapshot querySnapshot = await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .where("groupName", isEqualTo: groupName)
          .limit(1) // Assuming group names are unique, limit to one result
          .get();

      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> groupData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        return DeviceGroup.fromJson(groupData);
      }

      // If no group is found, return null
      return null;
    } catch (e) {
      log("Error getting device group by name: $e");
      return null;
    }
  }

  Future<DeviceGroup?> getDeviceGroupById(String userId, String groupId) async {
    try {
      // Query Firestore to find a device group with the given name
      DocumentSnapshot documentSnapshot = await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .doc(groupId)
          .get();
      // Assuming group names are unique, limit to one result

      // Check if any documents are returned
      if (documentSnapshot.exists) {
        var groupData = documentSnapshot.data() as Map<String, dynamic>;

        return DeviceGroup.fromJson(groupData);
      }

      // If no group is found, return null
      return null;
    } catch (e) {
      log("Error getting device group by name: $e");
      return null;
    }
  }

  Future<List<DeviceGroup>> getAllDeviceGroups(String userId) async {
    List<DeviceGroup> groups = [];
    try {
      QuerySnapshot groupSnapshot = await UserCollection.userCollection
          .doc(userId)
          .collection(deviceGroupCollection)
          .get();
      for (var doc in groupSnapshot.docs) {
        Map<String, dynamic> groupData = doc.data() as Map<String, dynamic>;
        groups.add(DeviceGroup.fromJson(groupData));
      }
      return groups;
    } catch (e) {
      log("Error getting all device groups: $e");
      return [];
    }
  }


  Future<bool> removeDeviceIdFromGroup({
  required String userId,
  required String groupId,
  required int index,
}) async {
  try {
    // Get the group document to fetch the current deviceIds
    DocumentSnapshot groupSnapshot = await UserCollection.userCollection
        .doc(userId)
        .collection(deviceGroupCollection)
        .doc(groupId)
        .get();

    // Check if the group document exists
    if (!groupSnapshot.exists) {
      log("Group not found");
      return false;
    }

    // Extract the deviceIds list
    Map<String, dynamic> groupData =
        groupSnapshot.data() as Map<String, dynamic>;
    List<dynamic> deviceIds = groupData['deviceIds'] ?? [];

    // Check if the index is within the bounds of the list
    if (index < 0 || index >= deviceIds.length) {
      log("Invalid index");
      return false;
    }

    // Remove the device ID at the specified index
    deviceIds.removeAt(index);

    // Update the Firestore document with the modified list
    await UserCollection.userCollection
        .doc(userId)
        .collection(deviceGroupCollection)
        .doc(groupId)
        .update({'deviceIds': deviceIds});

    return true;
  } catch (e) {
    log("Error in removing device ID from group: $e");
    return false;
  }
}

}
