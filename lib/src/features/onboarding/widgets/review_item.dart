import 'package:flutter/material.dart';
import 'package:myapp/src/features/onboarding/onboarding_viewmodel.dart';

class ReviewItem extends StatelessWidget {
  final OnboardingPage onboardingPage;

  const ReviewItem({super.key, required this.onboardingPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            onboardingPage.title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            onboardingPage.description!,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}