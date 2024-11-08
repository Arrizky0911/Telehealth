import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/form/textfields.dart';

bool _isPasswordValid(String password) {
  if (password.length < 8) return false;
  if (!password.contains(RegExp(r'[A-Z]'))) return false;
  if (!password.contains(RegExp(r'[a-z]'))) return false;
  if (!password.contains(RegExp(r'[0-9]'))) return false;
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
  return true;
}

class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.passwordController, required this.label, required this.confirmPassword});

  final bool confirmPassword;
  final TextEditingController passwordController;
  final String label;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextInputField(
      textController: widget.passwordController,
      label: widget.label,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return widget.label == "Password" ? 'Please enter your password' : 'Please confirm your password';
        }
        if (widget.label == "Password" ? !_isPasswordValid(value) : false) {
          return 'Password does not meet requirements';
        }

        if (widget.confirmPassword) {
          return 'Passwords do not match';
        }

        return null;
      },
      obsecurePassword: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}