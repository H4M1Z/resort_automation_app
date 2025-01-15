import 'package:flutter/material.dart';

typedef ValidationFunction = String? Function(String?)?;

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.padding = const EdgeInsets.all(0.0),
    required this.labelText,
    required this.controller,
    this.suffixIcon,
    this.isObscured = false,
    this.onSuffixIconTap,
    required this.validator,
  });
  final EdgeInsetsGeometry padding;
  final String labelText;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final bool isObscured;
  final VoidCallback? onSuffixIconTap;
  final ValidationFunction validator;
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFFCCCCCC),
        ));
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Padding(
          padding: padding,
          child: SizedBox(
            width: width * 0.8,
            child: TextFormField(
              cursorErrorColor: Colors.grey.shade700,
              validator: validator,
              obscureText: isObscured,
              cursorColor: Colors.grey.shade700,
              controller: controller,
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.sizeOf(context).height * 0.02,
              ),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: onSuffixIconTap,
                    icon: Icon(
                      suffixIcon,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  fillColor: Color(0xFFF2F2F2),
                  filled: true,
                  labelText: labelText,
                  labelStyle: TextStyle(
                    fontSize: MediaQuery.sizeOf(context).height * 0.02,
                    color: const Color.fromARGB(255, 188, 179, 179),
                    fontWeight: FontWeight.bold,
                  ),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border,
                  focusedErrorBorder: border,
                  suffixIconColor: const Color.fromARGB(255, 188, 179, 179)),
            ),
          ),
        );
      },
    );
  }
}
