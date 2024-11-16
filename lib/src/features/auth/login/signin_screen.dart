import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/form/emailfield.dart';
import 'package:myapp/src/common_widgets/form/passwordfield.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/features/auth/login/forgot_password.dart';
import 'package:myapp/src/features/auth/register/register_screen.dart';
import 'package:myapp/src/features/main/main_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return; 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormLayout(items: [
      // Illustration
      Center(
        child: Image.asset(
          'assets/login.png', // Add this to your assets
          width: 280,
          fit: BoxFit.contain,
        ),
      ),

      const SizedBox(height: 12),

      // Title and Subtitle
      const Text(
        "Let's Sign in to Telehealth",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4B5BA6),
        ),
        textAlign: TextAlign.center,
      ),

      const SizedBox(height: 8),

      const Text(
        'Enter your email and password',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
        textAlign: TextAlign.center,
      ),

      const SizedBox(height: 32),

      // Form
      Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Email Field
            EmailField(emailController: _emailController),
            const SizedBox(height: 16),
            // Password Field
            PasswordField(passwordController: _passwordController, label: "Password", confirmPassword: false,),

            const SizedBox(height: 16),

            // Forgot Password Link
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF4B5BA6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Create an Account',
                    style: TextStyle(
                      color: Color(0xFF4B5BA6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Sign In Button
            SizedBox(
                width: 400,
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : RoundButton(
                          label: 'Sign In',
                          onPressed: _signIn,
                          color: const Color(0xFF4B5BA6),
                        ),
                )),

            const SizedBox(height: 24),
          ]))
    ]);
  }
}