// control_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
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
  final MqttService _mqttService = MqttService.instance;

  @override
  void initState() {
    super.initState();

    // startListeningToFirestore(
    //     context, "user1", _mqttService); // Listen to Firestore changes
    // // Connect to MQTT and subscribe to topics
    // _mqttService.connect().then((_) {
    //   // Subscribe to user-specific topics using wildcards
    //   const userId =
    //       "user1"; // Replace with dynamic user ID for multi-user apps
    //   const topic =
    //       'user/$userId/device/+/status'; // Wildcard for all user devices
    //   _mqttService.subscribeToTopic(topic, context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.read(deviceStateProvider);
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
