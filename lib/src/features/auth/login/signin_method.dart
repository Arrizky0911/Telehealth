import 'package:flutter/material.dart';
import 'package:myapp/src/features/auth/login/signin_screen.dart';
import 'package:myapp/src/features/auth/widgets/auth_method.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInMethod extends StatefulWidget {
  const SignInMethod({super.key});

  @override
  State<SignInMethod> createState() => _SignInMethodState();
}

class _SignInMethodState extends State<SignInMethod> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        // Navigate to home screen or handle new user
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthMethodLayout(
        handleEmailAuth: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        },
        handleGoogleSignIn: _handleGoogleSignIn,
        auth: "Sign In");
  }
}
