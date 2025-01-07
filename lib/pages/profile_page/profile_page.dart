import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_automation_app/core/commom/widgets/loading_widget.dart';
import 'package:home_automation_app/core/extensions/pop_up_messages.dart';
import 'package:home_automation_app/pages/profile_page/controller/profile_page_controller.dart';
import 'package:home_automation_app/pages/profile_page/widgets/profile_page_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top Clipped Background
          const ProfileBackgroundDesign(),
          // Back Button
          const ProfilePageBackButton(),
          // Profile Content
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(profilePageController);
              final controller = ref.read(profilePageController.notifier);
              switch (state) {
                case ProfileLoadingState():
                  return LoadingWidget(
                    event: controller.fetchUserDetails,
                    child: const ProfilePageForm(),
                  );
                case ProfileErrorState():
                  context.showPopUpMsg(state.message);
                  return const ProfilePageForm();
                default:
                  return const ProfilePageForm();
              }
            },
          )
        ],
      ),
    );
  }
}
