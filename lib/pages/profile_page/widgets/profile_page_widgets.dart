import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validation/form_validation.dart';
import 'package:home_automation_app/core/commom/functions/common_functions.dart';
import 'package:home_automation_app/core/commom/widgets/auth_text_fields.dart';
import 'package:home_automation_app/core/extensions/pop_up_messages.dart';
import 'package:home_automation_app/pages/profile_page/controller/profile_page_controller.dart';
import 'package:home_automation_app/pages/setting_tab/controller/setting_tab_controller.dart';

import 'custom_clipper.dart';

class ProfileBackgroundDesign extends StatelessWidget {
  const ProfileBackgroundDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 300),
      painter: CustomClipperWidget(context: context),
    );
  }
}

class ProfilePageBackButton extends ConsumerWidget {
  const ProfilePageBackButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
            ref.read(settingTabControllerProvider.notifier).reinitializeState();
          },
        ),
      ),
    );
  }
}

class ProfilePageForm extends ConsumerWidget {
  const ProfilePageForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(profilePageController.notifier);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 100),
          // Animated Profile Image
          const Hero(
            tag: 'profileImage',
            child: ProfilePicWidget(),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: controller.onEditImageClicked,
            child: const Text("Edit Image"),
          ),
          const SizedBox(height: 30),

          // Styled Text Fields
          ProfileTextFields(
            controller: controller,
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.updateUserDetails(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Save Changes",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePicWidget extends ConsumerWidget {
  const ProfilePicWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profilePageController);
    return switch (state) {
      ProfileLoadingState() => CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: MediaQuery.sizeOf(context).height * 0.15,
          ),
        ),
      ProfileLoadedState() => CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          backgroundImage: switch (state.image.isEmpty) {
            true => null,
            false => FileImage(
                File(
                  state.image,
                ),
              )
          },
          child: switch (state.image.isEmpty) {
            true => Icon(
                Icons.person,
                color: Colors.grey.shade600,
                size: MediaQuery.sizeOf(context).height * 0.15,
              ),
            false => null,
          },
        ),
      ProfileErrorState() => switch (state.image.isEmpty) {
          true => CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              child: Icon(
                Icons.person,
                color: Colors.grey.shade600,
                size: MediaQuery.sizeOf(context).height * 0.15,
              ),
            ),
          false => CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 60,
              backgroundImage: FileImage(
                File(
                  state.image,
                ),
              )),
        },
      ProfilePicPickedState() => CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60,
          backgroundImage: FileImage(
            File(
              state.image,
            ),
          )),
    };
  }
}

class ProfileTextFields extends ConsumerWidget {
  const ProfileTextFields({super.key, required this.controller});
  final ProfilePageController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profilePageController);
    final controller = ref.read(profilePageController.notifier);
    return Form(
        key: controller.formKey,
        child: Column(
          children: [
            StyledTextField(
              controller: controller.nameController,
              label: "Name",
              hint: "Enter your name",
              icon: Icons.person,
              validator: (value) =>
                  Validator(validators: [const RequiredValidator()])
                      .validate(label: 'Name', value: value),
            ),
            StyledTextField(
              controller: controller.emailController,
              label: "Email",
              hint: "Enter your email",
              icon: Icons.email,
              enabled: controller.isEnabled,
              validator: emailValidation,
            ),
            ProfilePagePasswordField(
              controller: controller.passwordController,
              enabled: controller.isEnabled,
            ),
          ],
        ));
  }
}

class ProfilePagePasswordField extends StatefulWidget {
  const ProfilePagePasswordField(
      {super.key, required this.controller, required this.enabled});
  final TextEditingController controller;
  final bool enabled;
  @override
  State<ProfilePagePasswordField> createState() =>
      _ProfilePagePasswordFieldState();
}

class _ProfilePagePasswordFieldState extends State<ProfilePagePasswordField> {
  var icon = Icons.visibility_off;
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return StyledTextField(
      controller: widget.controller,
      label: "Password",
      enabled: widget.enabled,
      hint: "Enter new password",
      icon: Icons.lock,
      isPassword: isObscured,
      onSuffixIconTap: _onsuffixIconTap,
      suffixIcon: icon,
    );
  }

  _onsuffixIconTap() {
    setState(() {
      isObscured = !isObscured;
      icon = isObscured ? Icons.visibility_off : Icons.visibility;
    });
  }
}

class StyledTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;

  const StyledTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.validator,
    this.onSuffixIconTap,
    this.suffixIcon,
    required this.controller,
    this.enabled = true,
  });
  final ValidationFunction? validator;
  final VoidCallback? onSuffixIconTap;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: TextFormField(
          obscureText: isPassword,
          enabled: enabled,
          controller: controller,
          onTap: () {
            if (!enabled) {
              context.showPopUpMsg(
                  'Login through email and password to modify this field!');
            }
          },
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: onSuffixIconTap,
              icon: Icon(
                suffixIcon,
                color: Colors.grey.shade600,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
