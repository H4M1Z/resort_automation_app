import 'package:flutter/material.dart';
import 'package:home_automation_app/pages/profile_page/widgets/custom_clipper.dart';
import 'package:home_automation_app/pages/profile_page/widgets/editable_text_fields.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top Clipped Background
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 300),
            painter: CustomClipperWidget(),
          ),

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Profile Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Animated Profile Image
                const Hero(
                  tag: 'profileImage',
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    // Edit Image Functionality
                  },
                  child: const Text("Edit Image"),
                ),
                const SizedBox(height: 30),

                // Styled Text Fields
                const StyledTextField(
                  label: "Name",
                  hint: "Enter your name",
                  icon: Icons.person,
                ),
                const StyledTextField(
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email,
                ),
                const StyledTextField(
                  label: "Password",
                  hint: "Enter new password",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Save Changes Functionality
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
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
          ),
        ],
      ),
    );
  }
}
