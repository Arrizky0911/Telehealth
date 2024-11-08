import 'package:flutter/material.dart';
import 'package:myapp/src/features/welcome//onboarding_screen.dart';

class PagerScreen extends StatelessWidget {
  final OnboardingPage onboardingPage;

  const PagerScreen({super.key, required this.onboardingPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (onboardingPage.image != null)
          Image.asset(
            onboardingPage.image!,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        const SizedBox(height: 32),
        if (onboardingPage.title != null)
          Text(
            onboardingPage.title!,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 16),
        if (onboardingPage.description != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              onboardingPage.description!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}