import 'package:flutter/material.dart';
import 'package:myapp/src/features/main/widgets/chatbot_card.dart';
import 'package:myapp/src/features/main/widgets/consultation_card.dart';
import 'package:myapp/src/features/main/widgets/health_cards.dart';
import 'package:myapp/src/features/main/widgets/symptom_checker_card.dart';

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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize Your App',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is a template app that you can customize to create your own digital health experience.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Learn how at cardinalkit.org',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1A237E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const HealthInsightsCard(),
              const SizedBox(height: 16),
              const VirtualConsultationsCard(),
              const SizedBox(height: 16),
              const AIChatbotCard(),
              const SizedBox(height: 16),
              const SymptomCheckerCard(),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}