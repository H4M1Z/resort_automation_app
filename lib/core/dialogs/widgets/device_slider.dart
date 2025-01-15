import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/Connectivity/connectvity_helper.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/core/protocol/mqt_service.dart';
import 'package:home_automation_app/main.dart';
import 'package:home_automation_app/pages/control_tab/controllers/slide_value_controller.dart';
import 'package:home_automation_app/pages/control_tab/controllers/switch_state_controller.dart';
import 'package:home_automation_app/providers/device_state_notifier/device_state_change_notifier.dart';
import 'package:home_automation_app/utils/hexa_into_number.dart';

class DeviceSlider extends ConsumerStatefulWidget {
  final Device device;
  final bool isDarkMode;
  final ThemeData theme;

  const DeviceSlider({
    super.key,
    required this.device,
    required this.isDarkMode,
    required this.theme,
  });

  @override
  ConsumerState<DeviceSlider> createState() => _DeviceSliderState();
}

class _DeviceSliderState extends ConsumerState<DeviceSlider> {
  double sliderValue = 0;
  @override
  void initState() {
    super.initState();

    sliderValue = double.parse(
        GerenrateNumberFromHexa.hexaIntoStringAccordingToDeviceType(
            widget.device.type, widget.device.attributes.values.first));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(sliderValueProvider.notifier).intialSliderValue(sliderValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sliderValueProvider);
    double value = sliderValue;
    return Slider(
      value: value,
      min: 0,
      max: 100,
      divisions: 4,
      label: value.round().toString(),
      onChanged: (newValue) async {
        MqttService mqttService = MqttService();
        if (mqttService.isConnected) {
          //Checking for internet
          final hasInternet =
              await ConnectivityHelper.hasInternetConnection(context);
          if (!hasInternet) return;
          //Checking if the switch is on
          bool isSwitchOn = ref
                  .read(switchStateProvider.notifier)
                  .mapOfSwitchStates[widget.device.deviceId] ??
              false;
          if (isSwitchOn) {
            setState(() {
              sliderValue = newValue;
              ref
                  .read(sliderValueProvider.notifier)
                  .updateSliderValue(value, widget.device);
            });
            ref.read(deviceStateProvider.notifier).updateSliderValue(
                newValue, widget.device, globalUserId, context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Switch is off"),
                duration: Duration(seconds: 1),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("MQTT is not connected. Cannot send the command."),
              duration: Duration(seconds: 1),
            ),
          );
          log('MQTT is not connected. Cannot send the command.');
        }
      },
      activeColor: widget.isDarkMode
          ? const Color(0xFF4FC0E7)
          : widget.theme.primaryColor,
      inactiveColor: Colors.grey,
    );
  }
}
