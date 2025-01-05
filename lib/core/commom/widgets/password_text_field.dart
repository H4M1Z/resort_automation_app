import 'package:flutter/material.dart';
import 'package:home_automation_app/core/commom/widgets/auth_text_fields.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField(
      {super.key, required this.controller, required this.validator});
  final TextEditingController controller;
  final ValidationFunction validator;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  static const password = 'Password';
  bool isObscured = true;
  IconData icon = Icons.visibility_off;
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      validator: widget.validator,
      padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.05),
      labelText: password,
      controller: widget.controller,
      suffixIcon: icon,
      isObscured: isObscured,
      onSuffixIconTap: _onSuffixIconTap,
    );
  }

  _onSuffixIconTap() {
    setState(() {
      isObscured = !isObscured;
      icon = isObscured ? Icons.visibility_off : Icons.visibility;
    });
  }
}
