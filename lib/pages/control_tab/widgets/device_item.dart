import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/dialogs/widgets/device_switch.dart';
import 'package:resort_automation_app/core/model_classes/device.dart';
import 'package:resort_automation_app/pages/control_tab/widgets/device_status.dart';
import 'package:resort_automation_app/pages/control_tab/widgets/item_icons.dart';
import 'package:resort_automation_app/pages/control_tab/widgets/title_and_icon.dart';

class DeviceItem extends ConsumerWidget {
  final Device device;
  final double containerWidth;
  final double containerHeight;
  const DeviceItem({
    super.key,
    required this.device,
    required this.containerWidth,
    required this.containerHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [
                    const Color.fromARGB(255, 249, 247, 247),
                    const Color.fromARGB(255, 234, 228, 228),
                    const Color.fromARGB(255, 249, 247, 247)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black : Colors.grey,
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(
                  flex: 5,
                ),
                Expanded(
                  flex: 40,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 70,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                    flex: 30,
                                    child: ItemIcon(
                                        device: device,
                                        isDarkMode: isDarkMode,
                                        theme: theme)),
                                const Spacer(
                                  flex: 70,
                                )
                              ],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: DeviceItemTitleAndType(
                                    device: device,
                                    isDarkMode: isDarkMode,
                                    theme: theme)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 80,
                              child: DeviceSwitch(
                                device: device,
                              ),
                            ),
                            const Spacer(
                              flex: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // device.type == "Fan"
                //     ? Expanded(
                //         flex: 25,
                //         child: Row(
                //           children: [
                //             Expanded(
                //               flex: 75,
                //               child: DeviceSlider(
                //                 device: device,
                //                 isDarkMode: isDarkMode,
                //                 theme: theme,
                //               ),
                //             ),
                //             Expanded(
                //               flex: 15,
                //               child: SliderPercentageValue(
                //                   device: device,
                //                   theme: theme,
                //                   isDarkMode: isDarkMode),
                //             ),
                //             const Spacer(
                //               flex: 10,
                //             )
                //           ],
                //         ),
                //       )
                //     : const SizedBox(),
                const Spacer(
                  flex: 5,
                ),
                // Status and Attributes Section
                Expanded(
                  flex: 25,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(
                              flex: 5,
                            ),
                            Expanded(
                              flex: 30,
                              child: Text(
                                "Status:",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 20,
                                child:
                                    DeviceStatus(device: device, theme: theme)),
                            const Spacer(
                              flex: 20,
                            )
                          ],
                        ),
                      ),
                      // device.type == "Fan"
                      //     ? Expanded(
                      //         flex: 50,
                      //         child: Row(
                      //           children: [
                      //             const Spacer(
                      //               flex: 25,
                      //             ),
                      //             Expanded(
                      //               flex: 50,
                      //               child: Text(
                      //                 " ${device.attributes.keys.first}:",
                      //                 style:
                      //                     theme.textTheme.bodyMedium?.copyWith(
                      //                   fontWeight: FontWeight.bold,
                      //                   color: isDarkMode
                      //                       ? Colors.grey[400]
                      //                       : Colors.grey[800],
                      //                 ),
                      //               ),
                      //             ),
                      //             Expanded(
                      //                 flex: 20,
                      //                 child: AttributeValue(
                      //                     device: device,
                      //                     theme: theme,
                      //                     isDarkMode: isDarkMode)),
                      //             const Spacer(
                      //               flex: 5,
                      //             )
                      //           ],
                      //         ))
                      //     : const Spacer(
                      //         flex: 50,
                      //       )
                      const Spacer(
                        flex: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Positioned(
            //   top: MediaQuery.of(context).size.height * -0.04,
            //   right: MediaQuery.of(context).size.width * -0.05,
            //   child: InkWell(
            //       onTap: () async {
            //         showRemoveDialog(context, device, ref);
            //       },
            //       child: const DeviceItemRemoveIcon()),
            // ),
          ],
        ),
      ),
    );
  }
}
