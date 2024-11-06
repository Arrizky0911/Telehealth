import 'package:flutter/material.dart';
import 'package:myapp/src/features/onboarding/widgets/review_item.dart';

class OnboardingPage {
  final String? image;
  final String? title;
  final String? description;

  OnboardingPage({this.image, this.title, this.description});
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
