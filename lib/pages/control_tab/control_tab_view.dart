// control_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_automation_app/pages/add_device_tab/new_tab_view.dart';
import 'package:home_automation_app/pages/control_tab/widgets/device_item.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_states.dart';
import 'package:home_automation_app/utils/screen_meta_data.dart';

import 'widgets/sliver_header.dart'; // Custom Sliver header

class ControlTab extends ConsumerStatefulWidget {
  static const pageName = "/controlTab";
  const ControlTab({super.key});

  @override
  ConsumerState<ControlTab> createState() => _ControlTabState();
}

class _ControlTabState extends ConsumerState<ControlTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(deviceStateProvider);
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: CustomSliverDelegate(
                expandedHeight: ScreenMetaData.getHeight(context) * 0.20,
                onAddDevice: () {
                  //Navigate to the devices tab
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddDevicesTab()));
                },
              ),
            ),
            Builder(builder: (context) {
              if (state is DeviceDataInitialState ||
                  state is DeviceDataLoadingState) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SpinKitCircle(
                      color: Colors
                          .blue, // Replace with your theme's primary color
                      size: 50.0,
                    ),
                  ),
                );
              } else if (state is DeviceDataLoadedState) {
                return state.list.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                            child: Text(
                          "No device found",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18),
                        )),
                      )
                    : SliverList.builder(
                        itemCount: state.list.length,
                        itemBuilder: (context, index) {
                          var currentDevice = state.list[index];
                          return Padding(
                            padding: ScreenMetaData.getWidth(context) < 700
                                ? const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 6)
                                : const EdgeInsets.only(
                                    left: 18.0, right: 18, top: 8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Adjust container size dynamically
                                double containerHeight = currentDevice.type ==
                                        "Fan"
                                    ? constraints.maxWidth *
                                        0.5 // Example: More height for fans
                                    : constraints.maxWidth *
                                        0.4; // Example: Less height for other devices

                                return SizedBox(
                                  height: containerHeight,
                                  width: constraints.maxWidth,
                                  child: DeviceItem(
                                    containerHeight: containerHeight,
                                    containerWidth: constraints.maxWidth,
                                    device: currentDevice,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
              } else if (state is DeviceDataErrorState) {
                var error = state.error;
                return SliverToBoxAdapter(
                    child: Center(child: Text(error.toString())));
              } else {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("Something went wrong"),
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
