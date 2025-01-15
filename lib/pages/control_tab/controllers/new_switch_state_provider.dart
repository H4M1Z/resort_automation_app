import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/model_classes/device.dart';
import 'package:home_automation_app/pages/control_tab/controllers/switch_state_controller.dart';

final newSwitchStateProvider =
    NotifierProvider<NewSwitchStateProvider, bool>(NewSwitchStateProvider.new);

class NewSwitchStateProvider extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void intiallizeSwitchState(bool value) {
    state = value;
  }

  void onChangeSwitchState(bool value , Device device) async{
    state = value;
     await ref
        .read(switchStateProvider.notifier)
        .updateSwitchState(value, device);
  }
}
