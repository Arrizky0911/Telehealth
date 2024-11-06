import 'package:flutter/material.dart';
import 'package:myapp/src/features/onboarding/widgets/pager_screen.dart';
import 'package:myapp/src/features/onboarding/review_screen.dart';
import 'package:myapp/src/features/onboarding/onboarding_viewmodel.dart';

final List<OnboardingPage> pages = [
  OnboardingPage(
    image: 'assets/first.png',
    title: 'Data Gathering',
    description: 'Learn about how we gather data.',
  ),
  OnboardingPage(
    image: 'assets/second.png',
    title: 'Privacy',
    description: 'Your privacy is important to us.',
  ),
  OnboardingPage(
    image: 'assets/third.png',
    title: 'Data Use',
    description: 'How we use your data.',
  ),
  OnboardingPage(
    image: 'assets/fourth.png',
    title: 'Withdrawing',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(24.0),
          child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            }
          )
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
              mainAxisAlignment: _currentPage == pages.length - 1
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage != pages.length - 1) ...[
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
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Next'),
                  ),
                ] else
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReviewScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text('Review'),
                  ),
              ],
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
