import 'package:flutter/material.dart';
import 'package:myapp/src/features/auth/register/register_screen.dart';
import 'package:myapp/src/features/auth/widgets/auth_method.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/main/main_screen.dart';

class RegisterMethod extends StatefulWidget {
  const RegisterMethod({super.key});

  @override
  State<RegisterMethod> createState() => _RegisterMethodState();
}

class _RegisterMethodState extends State<RegisterMethod> {
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
        Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
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
              MaterialPageRoute(builder: (context) => const RegisterScreen()));
        },
        handleGoogleSignIn: _handleGoogleSignIn,
        auth: "Sign Up");
  }
}
