import 'package:flutter/material.dart';
import 'package:home_automation_app/core/commom/widgets/auth_text_fields.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.validator,
    this.height = 0.05,
    required this.lalbel,
  });
  final TextEditingController controller;
  final ValidationFunction validator;
  final double height;
  final String lalbel;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscured = true;
  IconData icon = Icons.visibility_off;
  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      validator: widget.validator,
      padding: EdgeInsets.only(
          top: MediaQuery.sizeOf(context).height * widget.height),
      labelText: widget.lalbel,
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
