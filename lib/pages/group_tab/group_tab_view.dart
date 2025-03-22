import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/pages/group_tab/widgets/room_stream.dart';

class GroupTab extends ConsumerWidget {
  const GroupTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Main Content
            const Padding(
              padding:
                  EdgeInsets.only(top: 120.0), // Leaves space for the top bar
              child: RoomStream(),

              // Builder(builder: (context) {
              //   final state = ref.watch(deviceGroupsProvider);
              //   if (state is DeviceGroupInitalState) {
              //     return Center(
              //       child: Text(
              //         "Please scan the QR Code to get your group",
              //         style: TextStyle(
              //             color: Theme.of(context).colorScheme.primary,
              //             fontSize: 18),
              //       ),
              //     );
              //   } else if (state is DeviceGroupLoadingState) {
              //     return const Center(
              //       child: SpinKitCircle(
              //         color: Colors
              //             .blue, // Replace with your theme's primary color
              //         size: 50.0,
              //       ),
              //     );
              //   } else if (state is DeviceGroupLoadedState) {
              //     return Center(
              //       child: GroupContainer(
              //         deviceGroup: state.group,
              //       ),
              //     );
              //   } else if (state is DeviceGroupErrorState) {
              //     final error = state.error;
              //     return Center(
              //       child: Text(
              //         error,
              //         style: const TextStyle(
              //           color: Colors.red,
              //           fontSize: 16,
              //         ),
              //       ),
              //     );
              //   } else {
              //     return const Center(
              //       child: Text(
              //         "Something went wrong",
              //         style: TextStyle(color: Colors.red, fontSize: 16),
              //       ),
              //     );
              //   }
              // }),
            ),

            // Attractive Top Bar
            Container(
              height: size.height * 0.12,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        "Your Group",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // Profile Icon or Action Icon
                    ],
                  ),
                ),
              ),
            ),

            // Floating Button at Bottom Right
            // Positioned(
            //   bottom: 20,
            //   right: 20,
            //   child: FloatingActionButton(
            //     onPressed: () async {
            //       final hasInternet =
            //           await ConnectivityHelper.hasInternetConnection(context);
            //       if (!hasInternet) return;
            //       showProgressDialog(
            //           context: context,
            //           message: "Getting devices for grouping");
            //       await ref
            //           .read(scannedDeviceProvider.notifier)
            //           .onClickAddDevices(ref);
            //       // Navigate to device scanning tab
            //       Navigator.of(context).pop();
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const DeviceScanningTab(),
            //         ),
            //       );
            //     },
            //     backgroundColor: Theme.of(context).colorScheme.primary,
            //     child: Icon(
            //       Icons.add,
            //       color: Theme.of(context).iconTheme.color,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
