import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:home_automation_app/core/Connectivity/connectvity_helper.dart';
import 'package:home_automation_app/pages/device_scaning_tab/device_selection_tab.dart';
import 'package:home_automation_app/pages/group_tab/controller/group_state_controller.dart';
import 'package:home_automation_app/pages/group_tab/controller/ids_uploader_controller.dart';
import 'package:home_automation_app/pages/group_tab/controller/scaning_tab_controller.dart';
import 'package:home_automation_app/pages/group_tab/widgets/group_container.dart';

class GroupTab extends ConsumerStatefulWidget {
  const GroupTab({super.key});

  @override
  ConsumerState<GroupTab> createState() => _GroupTabState();
}

class _GroupTabState extends ConsumerState<GroupTab> {
  @override
  void initState() {
    super.initState();
    intializeBoleanList();
  }

  void intializeBoleanList() async {
    await ref.read(idsUploadStateProvider.notifier).initializeBooleanList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var state = ref.watch(deviceGroupsProvider);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Main Content
            Padding(
              padding: const EdgeInsets.only(
                  top: 120.0), // Leaves space for the top bar
              child: Builder(builder: (context) {
                if (state is DeviceGroupInitalState ||
                    state is DeviceGroupLoadingState) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Colors
                          .blue, // Replace with your theme's primary color
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
                } else if (state is DeviceGroupErrorState) {
                  final error = state.error;
                  return Center(
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Something went wrong",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }
              }),
            ),

            // Attractive Top Bar
            Container(
              height: size.height * 0.12,
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
              child: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title
                      Text(
                        "Your Groups",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      // Profile Icon or Action Icon
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
                onPressed: () async {
                  final hasInternet =
                      await ConnectivityHelper.hasInternetConnection(context);
                  if (!hasInternet) return;
                  await ref
                      .read(scannedDeviceProvider.notifier)
                      .onClickAddDevices(ref);
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
      ),
    );
  }
}
