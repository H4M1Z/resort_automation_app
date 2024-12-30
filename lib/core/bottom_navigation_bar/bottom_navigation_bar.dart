import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/items.dart';
import 'package:home_automation_app/core/bottom_navigation_bar/notifier_provider.dart';
import 'package:provider/provider.dart';

BottomNavigationBar getBottomNavigationBar(
    BuildContext context, WidgetRef ref) {
  return BottomNavigationBar(
    currentIndex: ref.watch(bottomBarStateProvider),
    onTap: (value) {
      ref.read(bottomBarStateProvider.notifier).changeIndex(value);
    },
    items: const [
      BottomNavigationBarItems.item1,
      BottomNavigationBarItems.item2,
      BottomNavigationBarItems.item3,
    ],
    backgroundColor: Theme.of(context).colorScheme.primary,
    elevation: 10,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white, // Highlight selected items
    unselectedItemColor: Colors.grey.shade400,
    selectedFontSize: 14,
    unselectedFontSize: 12,
    showUnselectedLabels: true, // Ensure labels are always shown
    iconSize: 26,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
  );
}
