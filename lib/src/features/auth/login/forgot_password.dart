import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/form/emailfield.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/features/auth/login/signin_method.dart'; // Import the SignInMethod screen

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

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text,
        );
        setState(() {
          _emailSent = true;
        });
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignInMethod()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(
      items: [
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
                EmailField(emailController: _emailController),
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
                RoundButton(
                  label: 'Resend Email',
                  onPressed: () {
                    setState(() {
                      _emailSent = false;
                    });
                  },
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
                RoundButton(
                  label: 'I\'ve Reset My Password',
                  onPressed: _navigateToSignIn,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}