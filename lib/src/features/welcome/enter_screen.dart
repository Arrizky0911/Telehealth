import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/features/welcome/welcome_screen.dart';
import 'package:myapp/src/features/auth/login/signin_method.dart';

class EnterScreen extends StatelessWidget {
  const EnterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Title
                const Text(
                  'Telehealth ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  'Wireless and Mobile Programming Final Project',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 50),

                // New User Button

                RoundButton(
                  label: 'I am a New User',
                  onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()));
                  },
                  color: const Color(0xFFFF4D4F),
                ),
                

                const SizedBox(height: 20),

                // Existing user button
                
                RoundButton(
                  label: 'I am an Existing User', 
                  onPressed: () {
                    Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInMethod()));
                  },
                  color: const Color(0xFFFF4D4F),
                )
              ],
            ),
          ),
        ),
    );
  }
}
