import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/Connectivity/connectvity_helper.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/pages/control_tab/controllers/new_switch_state_provider.dart';
import 'package:home_automation_app/pages/control_tab/controllers/switch_state_controller.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

class DeviceSwitch extends ConsumerStatefulWidget {
  final Device device;

  const DeviceSwitch({
    super.key,
    required this.device,
  });

  @override
  ConsumerState<DeviceSwitch> createState() => _DeviceSwitchState();
}

class _DeviceSwitchState extends ConsumerState<DeviceSwitch> {
  bool isSwitchOn = false;
  @override
  void initState() {
    super.initState();
    isSwitchOn = GerenrateNumberFromHexa.hexaIntoStringAccordingToDeviceType(
            widget.device.type, widget.device.status) ==
        "On";
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(switchStateProvider.notifier).intialSwitchState(isSwitchOn);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(switchStateProvider);

    return Switch(
      value: isSwitchOn,
      onChanged: (value) async {
        final hasInternet =
            await ConnectivityHelper.hasInternetConnection(context);
        if (!hasInternet) return;

        setState(() {
          isSwitchOn = value;
          ref
              .read(switchStateProvider.notifier)
              .updateSwitchState(value, widget.device);
        });
        ref
            .read(deviceStateProvider.notifier)
            .toggleSwitch(value, widget.device, globalUserId, context, ref);
      },
    );
  }
}
