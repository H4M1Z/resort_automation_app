import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/commom/widgets/loading_widget.dart';
import 'package:home_automation_app/pages/setting_tab/controller/setting_tab_controller.dart';

class ProfileWidget extends ConsumerWidget {
  final String profileImageUrl;
  const ProfileWidget({super.key, required this.profileImageUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingTabControllerProvider);
    final controller = ref.read(settingTabControllerProvider.notifier);
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return switch (state) {
      SettingsTabLoadigState() => SizedBox(
          height: height * 0.1,
          width: width * 0.15,
          child: LoadingWidget(
            event: controller.fetchUserDetails,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              radius: 30,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ),
      SettingsTabLoadedState() => CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 30,
          backgroundImage: switch (state.image.isEmpty) {
            true => null,
            _ => FileImage(File(state.image)),
          },
          child: switch (state.image.isEmpty) {
            true => const Icon(
                Icons.person,
                color: Colors.white,
              ),
            _ => null,
          },
        ),
      _ => CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 30,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
    };
  }
}
