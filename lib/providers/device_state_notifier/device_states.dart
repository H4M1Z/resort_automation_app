// Through RriverPod
import 'package:resort_automation_app/core/model_classes/device.dart';

abstract class DeviceDataStates {}

class DeviceDataInitialState extends DeviceDataStates {}

class DeviceDataLoadingState extends DeviceDataStates {}

class DeviceDataLoadedState extends DeviceDataStates {
  final List<Device> list;
  DeviceDataLoadedState({required this.list});
}

class DeviceDataErrorState extends DeviceDataStates {
  final String error;
  DeviceDataErrorState({required this.error});
}

class DevicesDataCodeScannedState extends DeviceDataStates {}
