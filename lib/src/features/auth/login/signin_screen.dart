import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/form/emailfield.dart';
import 'package:myapp/src/common_widgets/form/passwordfield.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/features/auth/login/forgot_password.dart';
import 'package:myapp/src/features/auth/register/register_screen.dart';
import 'package:myapp/src/features/main/main_screen.dart';
import 'package:myapp/src/features/doctor/doctor/doctor_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/src/features/admin/admin_screen.dart';

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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      setState(() => _isLoading = true);
      
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Check if doctor
      final doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userCredential.user?.uid)
          .get();

      if (doctorDoc.exists) {
        await doctorDoc.reference.update({'isOnline': true});
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
        );
        return;
      }

      // Check user role
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();
      
      final userData = userDoc.data();
      if (userData?['role'] == 'admin') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminScreen()),
        );
      } else {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      // Error handling
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
                          onPressed: _login,
                          color: const Color(0xFF4B5BA6),
                        ),
                )),

            const SizedBox(height: 24),
          ]))
    ]);
  }
}