import 'package:flutter/material.dart';
import 'package:myapp/src/features/auth/register/register_method.dart';

class OnboardingPage {
  final String? image;
  final String? title;
  final String? description;

  const OnboardingPage({this.image, this.title, this.description});
}

final List<OnboardingPage> pages = [
  const OnboardingPage(
    image: 'assets/first.png',
    title: 'Consult with doctor',
    description: 'Learn about how we gather data.',
  ),
  const OnboardingPage(
    image: 'assets/second.png',
    title: 'Doctor Appoinment',
    description: 'Your privacy is important to us.',
  ),
  const OnboardingPage(
    image: 'assets/third.png',
    title: 'Medication Tracker',
    description: 'How we use your data.',
  ),
  const OnboardingPage(
    image: 'assets/fourth.png',
    title: 'AI Diagnosis',
    description: 'You can withdraw at any time.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return PagerScreen(onboardingPage: pages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (index) => buildDot(index: index),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Previous'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_currentPage != pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterMethod()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ]

            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey,
      ),
    );
  }
}

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