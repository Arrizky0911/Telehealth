import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/padding_layout.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class AuthMethodLayout extends StatelessWidget {
  final VoidCallback handleEmailAuth;
  final VoidCallback handleGoogleSignIn;
  final String auth;
  final bool backArrow;

  const AuthMethodLayout({
    super.key,
    required this.handleEmailAuth,
    required this.handleGoogleSignIn,
    required this.auth, required this.backArrow
    }
  );

  @override
  Widget build(BuildContext context) {
    return PaddingLayout(
      backArrow: backArrow,
      backgroundColor: Colors.white,
      widgets: [
        Image.asset(
          'assets/login.png',
          width: MediaQuery.of(context).size.width * 0.55,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Text(
          auth == "Sign In" ? "Sign In to WMP Final" : "Create a new account",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          auth == "Sign In" ? "Choose your sign-in method" : 'Choose your sign-up method',
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 60),
        SizedBox(
          width: 300,
          child: RoundButton(
            label: auth == "Sign In" ? "Sign In with Email" : "Sign Up with Email", 
            onPressed: handleEmailAuth,
            color: const Color(0xFF4B5BA6))
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: OutlinedButton.icon(
            icon: Image.asset('assets/btn_google.png', height: 24),
            label: const Text('Sign in with Google'),
            onPressed: handleGoogleSignIn,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        )
      ],
    );
  }
}
