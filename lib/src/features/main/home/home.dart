import 'package:flutter/material.dart';
import 'package:myapp/src/features/main/widgets/consultation_card.dart';
import 'package:myapp/src/features/main/widgets/health_cards.dart';
import 'package:myapp/src/features/main/widgets/skin_check_card.dart';
import 'package:myapp/src/features/main/widgets/virtual_assistant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'We are glad to see you!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              const SkinCheckCard(),
              const SizedBox(height: 16),
              const HealthInsightsCard(),
              const SizedBox(height: 16),
              const VirtualConsultationsCard(),
              const SizedBox(height: 16),
              const VirtualAssistantCard(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}