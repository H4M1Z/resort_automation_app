import 'package:flutter/material.dart';
import 'package:home_automation_app/config/service_locator.dart';
import 'package:home_automation_app/core/services/user_management_service.dart';

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final VoidCallback onAddDevice;

  CustomSliverDelegate({
    required this.expandedHeight,
    required this.onAddDevice,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isCollapsed = shrinkOffset > (expandedHeight - kToolbarHeight);
    final prefs = serviceLocator.get<UserManagementService>();
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Content of the sliver header
          Positioned(
            left: 16.0,
            right: 16.0,
            top: expandedHeight / 2 - shrinkOffset,
            child: Opacity(
              opacity: (1 - shrinkOffset / expandedHeight).clamp(0.0, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    "Hello ${prefs.getUserName()}",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 21,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Welcome back to home",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Button that appears in collapsed and expanded state
          Positioned(
            right: 16.0,
            top: isCollapsed ? kToolbarHeight / 2 : expandedHeight - 56.0,
            child: ElevatedButton.icon(
              onPressed: onAddDevice,
              icon: const Icon(Icons.add, size: 20),
              label: const Text("Add Device"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
