import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/buttons.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/common_widgets/textfields.dart';
import 'package:myapp/src/features/onboarding/onboarding_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordValid(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      items: [
        // Title and Subtitle
        const Center(
          child: Column(
            children: [
              Text(
                'CardinalKit',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B5BA6),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Stanford Byers Center for Biodesign',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name Field
              TextInputField(
                  textController: _firstNameController,
                  label: 'First Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  }),

              const SizedBox(height: 16),

              // Last Name Field
              TextInputField(
                  textController: _lastNameController,
                  label: 'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  }),

              const SizedBox(height: 16),

              // Email Field
              TextInputField(
                textController: _emailController,
                label: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Password Requirements Text
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    'Your password should contain a minimum of 8 characters with at least 1 uppercase, 1 lowercase, 1 number, and 1 special character.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.justify,
                  )),

              const SizedBox(height: 16),

              // Password Field
              TextInputField(
                textController: _passwordController, 
                label: 'Password', 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (!_isPasswordValid(value)) {
                    return 'Password does not meet requirements';
                  }
                  return null;
                },
                obsecurePassword: _obscurePassword,
                suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      }
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Confirm Password Field
              TextInputField(
                textController: _confirmPasswordController, 
                label: 'Confirm Password', 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obsecurePassword: _obscureConfirmPassword,
                suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  )
              ),

              const SizedBox(height: 32),

              // Register Button
              Center(
                  child: RoundButton(
                      label: "Next",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OnboardingScreen()));
                        }
                      },
                      color: const Color(0xFF4B5BA6))),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
