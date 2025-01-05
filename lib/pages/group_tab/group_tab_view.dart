import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_automation_app/pages/device_scaning_tab/device_selection_tab.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:home_automation_app/pages/group_tab/widgets/group_container.dart';

class GroupTab extends ConsumerWidget {
  const GroupTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.read(deviceGroupsProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.only(
                top: 120.0), // Leaves space for the top bar
            child: Builder(builder: (context) {
              if (state is DeviceGroupInitalState) {
                return const Center(
                  child: SpinKitCircle(
                    color:
                        Colors.blue, // Replace with your theme's primary color
                    size: 50.0,
                  ),
                );
              } else if (state is DeviceGroupLoadingState) {
                return const Center(
                  child: SpinKitCircle(
                    color:
                        Colors.blue, // Replace with your theme's primary color
                    size: 50.0,
                  ),
                );
              } else if (state is DeviceGroupLoadedState) {
                return state.list.isEmpty
                    ? Center(
                        child: Text(
                          "No groups added yet",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          itemCount: state.list.length,
                          itemBuilder: (context, index) {
                            return GroupContainer(
                              deviceGroup: state.list[index],
                            );
                          },
                        ),
                      );
              } else {
                final error = (state as DeviceGroupErrorState).error;
                return Center(
                  child: Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              }
            }),
          ),

          // Attractive Top Bar
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    const Text(
                      "Groups",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    // Profile Icon or Action Icon
                    IconButton(
                      onPressed: () {
                        // Handle profile or menu actions
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Button at Bottom Right
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                // Navigate to device scanning tab
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DeviceScanningTab(),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
