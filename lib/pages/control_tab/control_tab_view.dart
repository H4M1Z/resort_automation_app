// control_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/protocol/Firestore_mqtt_Bridge.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/pages/add_device_tab/new_tab_view.dart';
import 'package:home_automation_app/pages/control_tab/widgets/device_item.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_states.dart';

import 'widgets/sliver_header.dart'; // Custom Sliver header

class ControlTab extends ConsumerStatefulWidget {
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
    return Builder(
      builder: (context) {
        if (state is DeviceDataInitialState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DeviceDataLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DeviceDataLoadedState) {
          return SafeArea(
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: CustomSliverDelegate(
                      expandedHeight: 150,
                      onAddDevice: () {
                        MqttService mqttService = MqttService();

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddDevicesTab()));
                      },
                    ),
                  ),
                  SliverGrid.builder(
                    itemCount: state.list.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.7, crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      var currentDevice = state.list[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeviceItem(
                          device: currentDevice,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        } else {
          var error = state as DeviceDataErrorState;
          return Center(child: Text(error.toString()));
        }
      },
    );
  }
}
