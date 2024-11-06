import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/buttons.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/common_widgets/textfields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _emailSent = false;
  bool _isLoading = false;

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement actual password reset logic here
      await Future.delayed(
          const Duration(seconds: 2)); // Simulating network request

      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(items: [
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Text(
              'Forgot Password',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              _emailSent
                  ? 'Check your email for password reset instructions.'
                  : 'Enter your email address to reset your password.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (!_emailSent) ...[
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
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ),
            ] else ...[
              RespondButton(
                  label: 'Resend Email',
                  onPressed: () {
                    setState(() {
                      _emailSent = false;
                    });
                  })
            ],
          ],
        ),
      ),
    ]);
  }
}
