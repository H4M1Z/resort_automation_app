import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/dialogs/remove_device_dialog.dart';
import 'package:home_automation_app/core/dialogs/widgets/device_slider.dart';
import 'package:home_automation_app/core/dialogs/widgets/device_switch.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';
import 'package:home_automation_app/utils/icons.dart';

class DeviceItem extends ConsumerWidget {
  final Device device;

  const DeviceItem({
    super.key,
    required this.device,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF1A1C35)
            : const Color.fromARGB(255, 239, 232, 232),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                                child: Icon(
                                  getDeviceIcon(device.type),
                                  size: 40,
                                  color: isDarkMode
                                      ? const Color(0xFF4FC0E7)
                                      : theme.primaryColor,
                                ),
                              ),
                              const Spacer(
                                flex: 70,
                              )
                            ],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  device.deviceName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  device.type,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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

              Expanded(
                flex: 25,
                child: Row(
                  children: [
                    Expanded(
                      flex: 75,
                      child: DeviceSlider(
                        device: device,
                        isDarkMode: isDarkMode,
                        theme: theme,
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Text(
                        "${double.parse(GerenrateNumberFromHexa.hexaIntoStringAccordingToDeviceType(device.type, device.attributes.values.first)) ?? 0}%",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const Spacer(
                      flex: 10,
                    )
                  ],
                ),
              ),
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
                            child: Text(
                              GerenrateNumberFromHexa
                                  .hexaIntoStringAccordingToDeviceType(
                                      device.type, device.status),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GerenrateNumberFromHexa
                                            .hexaIntoStringAccordingToDeviceType(
                                                device.type, device.status) ==
                                        "On"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                          const Spacer(
                            flex: 20,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 50,
                        child: Row(
                          children: [
                            const Spacer(
                              flex: 25,
                            ),
                            Expanded(
                              flex: 55,
                              child: Text(
                                " ${device.attributes.keys.first}:",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: Text(
                                GerenrateNumberFromHexa
                                    .hexaIntoStringAccordingToDeviceType(
                                        device.type,
                                        device.attributes.values.first),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -10,
            right: 0,
            child: InkWell(
              onTap: () {
                showRemoveDialog(context, device);
              },
              child: const Icon(
                Icons.remove_circle,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
