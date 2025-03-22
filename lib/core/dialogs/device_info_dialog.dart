// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:resort_automation_app/core/dialogs/widgets/device_slider.dart';
// import 'package:resort_automation_app/core/dialogs/widgets/device_switch.dart';
// import 'package:resort_automation_app/providers/add_device_type_provider.dart';
// import 'package:resort_automation_app/providers/device_state_change_provider.dart';
// import 'package:provider/provider.dart';

// void showDeviceInfoDialog(BuildContext context, int index, String userId) {
//   final deviceProvider = context.read<DeviceStateChangeProvider>();
//   final device =
//       context.read<AddDeviceTypeAdditionProvider>().devicesList[index];

//   // deviceProvider.sliderValue = device.attributes.values.first.toDouble();
//   // deviceProvider.isSwitchOn = device.status == "On";

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text(device.deviceName),
//         content: const Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // DeviceSlider(
//             //   value: deviceProvider.sliderValue,
//             //   onChanged: (value) {
//             //     log("Slider value changed to $value");
//             //     deviceProvider.updateSliderValue(value, device, userId);
//             //   },
//             // ),
//             SizedBox(height: 16),
//             // DeviceSwitch(
//             //   value: deviceProvider.isSwitchOn,
//             //   onChanged: (value) =>
//             //       deviceProvider.toggleSwitch(value, device, userId),
//             // ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               // await deviceProvider.saveDeviceAttributes(device, userId);
//               Navigator.pop(context);
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       );
//     },
//   );
// }
