import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/padding_layout.dart';
import 'package:myapp/src/features/welcome/onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingLayout(
      backArrow: true,
      widgets: [
      // Welcome Text
      const Text(
        'Welcome to Telehealth',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      const SizedBox(height: 16),

      // Description Text
      const Text(
        'This is a template that you can customize to build your own clinical or research study app.',
        style: TextStyle(
          fontSize: 12,
          color: Colors.black87,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      Image.asset(
        'assets/welcome.png', // You'll need to add this to your assets
        width: 300,
        fit: BoxFit.contain,
      ),
      RoundButton(
          label: 'Get Started',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const OnboardingScreen()));
          },
          color: const Color(0xFFFF4D4F))
    ], backgroundColor: Colors.white);
  }
}
