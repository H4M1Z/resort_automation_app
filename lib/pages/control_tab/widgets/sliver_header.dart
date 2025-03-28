import 'package:flutter/material.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/services/user_management_service.dart';
import 'package:resort_automation_app/pages/qr_scanning_page/controller/qr_scanning_controller.dart';

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final QrScanningPageController controller;
  CustomSliverDelegate({
    required this.expandedHeight,
    required this.controller,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final textController = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final prefs = serviceLocator.get<UserManagementService>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate opacity for fading effect
    final opacity = (1 - shrinkOffset / expandedHeight).clamp(0.0, 1.0);

    // Adjust the vertical position dynamically
    final verticalPosition = (screenHeight * 0.1) - shrinkOffset * 0.5;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        children: [
          // Content of the sliver header
          Positioned(
            left: screenWidth * 0.04, // 4% padding from the left
            top: verticalPosition.clamp(20.0, screenHeight * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  "Hello ${prefs.getUserName()}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: screenWidth * 0.06, // Responsive font size
                        color: Colors.white,
                      ),
                ),
                SizedBox(height: screenHeight * 0.005), // Responsive spacing
                Text(
                  "Welcome back to home",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: isDark ? Colors.white : Colors.white60,
                      ),
                ),
              ],
            ),
          ),
          // Button that appears in collapsed and expanded state
          Positioned(
            right: screenWidth * 0.05, // 4% padding from the right
            top: verticalPosition.clamp(20.0, screenHeight * 0.1) + 10,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.35,
                      child: AlertDialog(
                        title: const Center(child: Text("Add Devices")),
                        content: SingleChildScrollView(
                          child: StatefulBuilder(
                            builder: (context, setState) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.6,
                                  child: TextFormField(
                                    controller: textController,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Enter the Mac Address Displayed on the Screen',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (textController.text.isNotEmpty) {
                                        Navigator.pop(
                                            context); // CLOSE ADD DEVICE DIALOG
                                        // showProgressDialog(
                                        //   context: context,
                                        //   message: "Fetching Devices",
                                        // );
                                        await controller.onQRCodeScanned(
                                          textController.text.trim(),
                                        );
                                        // await Future.delayed(
                                        //   const Duration(seconds: 2),
                                        //   () => Navigator.pop(context),
                                        // );
                                        // // CLOSE PROGRESS DIALOG
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please enter the Mac Address"),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Fetch Devices'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );

                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return Center(
                //       child: SizedBox(
                //         width: screenWidth * 0.9,
                //         height: screenHeight * 0.35,
                //         child: AlertDialog(
                //           title: const Center(child: Text("Add Devices")),
                //           content: Column(
                //             children: [
                //               Expanded(
                //                 child: SizedBox(
                //                   width: screenWidth * 0.6,
                //                   child: TextFormField(
                //                     controller: textController,
                //                     decoration: const InputDecoration(
                //                         hintText:
                //                             'Enter the Mac Address Displayed on the Screen'),
                //                   ),
                //                 ),
                //               ),
                //               const SizedBox(height: 20),
                //               Center(
                //                   child: GestureDetector(
                //                       onTap: () async {
                //                         if (textController.text.isNotEmpty) {
                //                           Navigator.pop(
                //                               context); // CLOSE THE ADD DEVICE DIALOG
                //                           showProgressDialog(
                //                               context: context,
                //                               message: "Fetching Devices");
                //                           await controller.onQRCodeScanned(
                //                               textController.text.trim());
                //                           Navigator.pop(
                //                               context); //CLOSE THE PROGRESS DIALOG
                //                         } else {
                //                           ScaffoldMessenger.of(context)
                //                               .showSnackBar(
                //                             const SnackBar(
                //                                 content: Text(
                //                                     "Please enter the Mac Address")),
                //                           );
                //                         }
                //                       },
                //                       child: const Text(
                //                         'Fetch Devices',
                //                       ))),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text("Add Devices"),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? Theme.of(context).primaryColor : Colors.white,
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01, // Button padding responsive
                  horizontal: screenWidth * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight * 0.6;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
