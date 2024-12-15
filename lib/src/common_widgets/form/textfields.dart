import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textController;
  final String label;
  final String? Function(String?) validator;
  final bool obsecurePassword;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;

  const TextInputField(
      {super.key,
      required this.textController,
      required this.label,
      required this.validator,
      required this.keyboardType,
      this.obsecurePassword = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      obscureText: obsecurePassword,
      keyboardType: keyboardType,
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
            borderSide: const BorderSide(color: Color(0xFFFF4D4F)),
          ),
          floatingLabelStyle: const TextStyle(color: Color(0xFFFF4D4F)),
          suffixIcon: suffixIcon),
      validator: validator,
    );
  }
}
