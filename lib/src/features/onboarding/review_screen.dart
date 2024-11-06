import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/padding_layout.dart';
import 'package:myapp/src/common_widgets/buttons.dart';
import 'package:myapp/src/features/onboarding/signature_screen.dart';
import 'package:myapp/src/features/onboarding/onboarding_viewmodel.dart';

final List<OnboardingPage> data = [
  OnboardingPage(
    title: 'Data Gathering',
    description: 'Learn about how we gather data.',
  ),
  OnboardingPage(
    title: 'Privacy',
    description: 'Your privacy is important to us.',
  ),
  OnboardingPage(
    title: 'Data Use',
    description: 'How we use your data.',
  ),
  OnboardingPage(
    title: 'Withdrawing',
    description: 'You can withdraw at any time.',
  ),
];

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddingLayout(widgets: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: DisplayList(items: data),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RespondButton(
              label: 'Disagree',
              onPressed: () {
                // Navigate to Join Study Screen
              },
            ),
            RespondButton(
              label: 'Agree',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignatureScreen()));
              },
            ),
          ],
        ),
      ),
    ], backgroundColor: Colors.white);
  }
}
