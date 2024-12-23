import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:home_automation_app/themes/state_provider.dart';
import 'package:provider/provider.dart';

final listOfAllProviders = [
  ChangeNotifierProvider(
    create: (context) => BottomStateChangeNotifier(),
  ),
  ChangeNotifierProvider(
    create: (context) => ThemeStateNotifier(),
  )
];
