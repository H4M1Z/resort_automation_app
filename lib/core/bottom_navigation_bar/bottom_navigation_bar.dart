import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/core/bottom_navigation_bar/items.dart';
import 'package:resort_automation_app/core/bottom_navigation_bar/notifier_provider.dart';

BottomNavigationBar getBottomNavigationBar(
    BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return BottomNavigationBar(
    currentIndex: ref.watch(bottomBarStateProvider),
    onTap: (value) {
      ref.read(bottomBarStateProvider.notifier).changeIndex(value);
    },
    items: [
      BottomNavigationBarItems.getitem1(isDark),
      BottomNavigationBarItems.getitem2(isDark),
      BottomNavigationBarItems.getitem3(isDark),
      BottomNavigationBarItems.getitem4(isDark),
    ],
    backgroundColor: Theme.of(context).colorScheme.primary,
    elevation: 10,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white, // Highlight selected items
    unselectedItemColor: isDark
        ? const Color.fromARGB(255, 236, 231, 231)
        : Colors.grey.shade400,
    selectedFontSize: 14,
    unselectedFontSize: 12,
    showUnselectedLabels: true, // Ensure labels are always shown
    iconSize: 26,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
  );
}
