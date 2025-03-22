// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:resort_automation_app/core/Connectivity/connectvity_helper.dart';
// import 'package:resort_automation_app/core/dialogs/progress_dialog.dart';
// import 'package:resort_automation_app/pages/group_devices_page/controllers/group_device_button_controller.dart';
// import 'package:resort_automation_app/pages/group_devices_page/view/group_addtion.dart';

// class GroupDeviceButton extends ConsumerWidget {
//   final String groupId;
//   final bool isDarkMode;
//   final String groupName;
//   const GroupDeviceButton(
//       {super.key,
//       required this.isDarkMode,
//       required this.groupId,
//       required this.groupName});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ElevatedButton(
//       onPressed: () async {
//         final hasInternet =
//             await ConnectivityHelper.hasInternetConnection(context);
//         if (!hasInternet) return;
//         showProgressDialog(
//             context: context, message: "Getting devices for group $groupName");
//         await ref
//             .read(groupDevicesPageStateProvider.notifier)
//             .onDevicesButtonClick(groupId);
//         Navigator.pop(context);
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => GroupDevicesPage(
//             groupId: groupId,
//           ),
//         ));
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 4,
//         shadowColor: isDarkMode
//             ? Colors.black.withOpacity(0.3)
//             : Colors.grey.withOpacity(0.3),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.device_hub,
//               color: isDarkMode ? Colors.white : Colors.white),
//           const SizedBox(width: 8),
//           Text(
//             "Devices",
//             style: TextStyle(
//               color: isDarkMode ? Colors.white : Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
