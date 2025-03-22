// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:resort_automation_app/core/collections/device_collection.dart';
// import 'package:resort_automation_app/core/model_classes/device.dart';
// import 'package:resort_automation_app/main.dart';
// import 'package:resort_automation_app/utils/hexa_into_number.dart';

// final sliderValueProvider =
//     NotifierProvider<SlideValueController, double>(SlideValueController.new);

// class SlideValueController extends Notifier<double> {
//   Map<String, double> mapOfSliderValues = {};
//   DeviceCollection deviceCollection = DeviceCollection();
//   double sliderCurrentValue = 0;
//   @override
//   double build() {
//     return sliderCurrentValue;
//   }

//   void intialSliderValue(double intialValue) {
//     state = intialValue;
//   }

//   Future<void> updateSliderValue(double data, Device device) async {
//     var mapOfAttributes = await deviceCollection.getDeviceAttributes(
//         globalUserId, device.deviceId, device.deviceName);
//     String hexaCode = mapOfAttributes[
//         GerenrateNumberFromHexa.getDeviceAttributeAccordingToDeviceType(
//             device.type)];

//     double value = double.parse(
//         GerenrateNumberFromHexa.hexaIntoStringAccordingToDeviceType(
//             device.type, hexaCode));

//     mapOfSliderValues[device.deviceId] = value.toDouble();

//     log("Slider value at update slider value method = $value");
//     state = value;
//   }
// }
