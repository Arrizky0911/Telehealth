import 'package:flutter/material.dart';
import 'package:myapp/src/features/main/widgets/consultation_card.dart';
import 'package:myapp/src/features/main/widgets/health_cards.dart';
import 'package:myapp/src/features/main/widgets/pharmacy_card.dart';
import 'package:myapp/src/features/main/widgets/skin_check_card.dart';
import 'package:myapp/src/features/main/widgets/virtual_assistant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'We are glad to see you!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              VirtualAssistantCard(),
              SizedBox(height: 16),
              VirtualConsultationsCard(),
              SizedBox(height: 16),
              EPharmacySection()
            ],
          ),
        ),
      ),
    );
  }
}