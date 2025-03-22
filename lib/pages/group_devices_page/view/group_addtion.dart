// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:resort_automation_app/pages/group_devices_page/controllers/group_device_button_controller.dart';
// import 'package:resort_automation_app/pages/group_devices_page/widgets/remove_dialog.dart';
// import 'package:resort_automation_app/utils/icons.dart';

// class GroupDevicesPage extends ConsumerWidget {
//   final String groupId;
//   const GroupDevicesPage({super.key, required this.groupId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final size = MediaQuery.sizeOf(context);
//     var state = ref.watch(groupDevicesPageStateProvider);
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             // Top Header Section
//             Container(
//               width: double.infinity,
//               height: size.height * 0.1,
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(20.0),
//                   bottomRight: Radius.circular(20.0),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.arrow_back,
//                         size: 25,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16,),
//                   Text(
//                     "Group Lights",
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Body Content
//             Expanded(
//               child: Builder(builder: (context) {
//                 if (state is GroupDeviceButtonInitialState ||
//                     state is GroupDeviceButtonLoadingState) {
//                   return Center(
//                     child: SpinKitCircle(
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 50.0,
//                     ),
//                   );
//                 } else if (state is GroupDeviceButtonLoadedState) {
//                   return state.listOfDevices.isEmpty
//                       ? Center(
//                           child: Text(
//                             "No device found",
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Theme.of(context).colorScheme.primary,
//                             ),
//                           ),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: ListView.builder(
//                             itemCount: state.listOfDevices.length,
//                             itemBuilder: (context, index) {
//                               final device = state.listOfDevices[index];
//                               return Card(
//                                 elevation: 3,
//                                 margin: const EdgeInsets.only(bottom: 12.0),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12.0),
//                                 ),
//                                 child: ListTile(
//                                   leading: Container(
//                                     padding: const EdgeInsets.all(8.0),
//                                     decoration: BoxDecoration(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .primary
//                                           .withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.lightbulb,
//                                       size: 30,
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                     ),
//                                   ),
//                                   title: Text(
//                                    'bulb',
//                                     style:
//                                         Theme.of(context).textTheme.bodyLarge,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         );
//                 } else {
//                   return Center(
//                     child: Text(
//                       "Something went wrong",
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                   );
//                 }
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
