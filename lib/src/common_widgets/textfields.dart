import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textController;
  final String label;
  final String? Function(String?) validator;
  final bool obsecurePassword;
  final IconButton? suffixIcon;

  const TextInputField(
      {super.key,
      required this.textController,
      required this.label,
      required this.validator,
      this.obsecurePassword = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      obscureText: obsecurePassword,
      keyboardType: label == "Email" ? TextInputType.emailAddress : null,
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4B5BA6)),
          ),
          floatingLabelStyle: const TextStyle(color: Color(0xFF4B5BA6)),
          suffixIcon: suffixIcon),
      validator: validator,
    );
  }
}
