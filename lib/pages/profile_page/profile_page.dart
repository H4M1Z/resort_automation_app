import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/config/navigation/route_navigation.dart';
import 'package:home_automation_app/pages/profile_page/controller/profile_page_controller.dart';
import 'package:home_automation_app/pages/profile_page/widgets/profile_page_widgets.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  static const pageName = '/profile-page';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilePageArguments =
        ModalRoute.of(context)!.settings.arguments as ProfilePageArguments;
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(profilePageController.notifier).initializeValues(
              name: profilePageArguments.name,
              email: profilePageArguments.email,
              image: profilePageArguments.image,
              isEnabled: profilePageArguments.isEnabled,
            );
      },
    );
    return const Scaffold(
      body: Stack(
        children: [
          // Top Clipped Background
          ProfileBackgroundDesign(),
          // Back Button

          // Profile Content
          ProfilePageForm(),
          ProfilePageBackButton(),
        ],
      ),
    );
  }
}
