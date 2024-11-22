import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/form/emailfield.dart';
import 'package:myapp/src/common_widgets/form/passwordfield.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/common_widgets/form/textfields.dart';
import 'package:myapp/src/features/auth/login/signin_screen.dart';
import 'package:myapp/src/features/onboarding/review_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': _emailController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'role': 'patient',
        });

        if (!mounted) return; 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReviewScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account already exists for that email.';
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
                'Telehealth',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B5BA6),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Wireless and Mobile Programming Final Project',
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
                  keyboardType: null,
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
                  keyboardType: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  }),

              const SizedBox(height: 16),

              // Email Field
              EmailField(emailController: _emailController),

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
              PasswordField(
                  passwordController: _passwordController,
                  label: "Password",
                  confirmPassword: false,
              ),

              const SizedBox(height: 16),

              // Confirm Password Field
              PasswordField(
                  passwordController: _confirmPasswordController,
                  label: "Confirm Password",
                  confirmPassword: _passwordController.text == _confirmPasswordController.text ? false : true
              ),

              const SizedBox(height: 16),
              Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Have an Account?',
                      style: TextStyle(
                        color: Color(0xFF4B5BA6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ),

              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                  width: 400,
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : RoundButton(
                      label: 'Sign Up',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register();
                        }
                      },
                      color: const Color(0xFF4B5BA6),
                    ),
                  )),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
