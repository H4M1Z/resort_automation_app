import 'package:flutter/material.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:home_automation_app/providers/add_device_type_provider.dart';
import 'package:home_automation_app/providers/device_addition_provder.dart';
import 'package:home_automation_app/providers/user_addtion_state_provider.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:provider/provider.dart';

//MultiProvider (Providing all Change Notifiers)
MultiProvider multiProvider(Widget child) {
  return MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => BottomStateChangeNotifier(),
    ),
    ChangeNotifierProvider(
      create: (_) => ThemeStateNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => DeviceAdditionProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => UserAddtionStateProvider(),
    ),
    ChangeNotifierProvider(create: (context) => AddDeviceTypeAdditionProvider())
  ], child: child);
}
