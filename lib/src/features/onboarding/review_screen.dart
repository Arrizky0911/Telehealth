import 'package:flutter/material.dart';
import 'package:myapp/src/features/onboarding/signature_screen.dart';

class OnboardingPage {
  final String? image;
  final String title;
  final String description;

  OnboardingPage({this.image, required this.title, required this.description});
}

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigate back to onboarding screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}

class DisplayList extends StatelessWidget {
  final List<OnboardingPage> items;

  const DisplayList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ReviewItem(onboardingPage: items[index]);
      },
    );
  }
}

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
            onboardingPage.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            onboardingPage.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class RespondButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RespondButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
