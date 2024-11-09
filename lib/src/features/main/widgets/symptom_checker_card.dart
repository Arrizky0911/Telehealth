import 'package:flutter/material.dart';

// Card Component that navigates to Symptom Checker
class SymptomCheckerCard extends StatelessWidget {
  const SymptomCheckerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SymptomCheckerScreen()),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8BC34A).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.health_and_safety,
                      color: Color(0xFF8BC34A),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Symptom Checker',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Check your symptoms instantly',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Symptom Checker Screen
class SymptomCheckerScreen extends StatelessWidget {
  const SymptomCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios, size: 16),
                  ),
                ),
              ),
            ),
            // Main Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Illustration
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Main Figures
                          Image.asset(
                            'assets/images/symptom_checker_illustration.png',
                            fit: BoxFit.contain,
                          ),
                          // Floating Organs (you would need to create these as separate images)
                          Positioned(
                            top: 100,
                            right: 50,
                            child: Image.asset(
                              'assets/images/lungs_icon.png',
                              width: 40,
                            ),
                          ),
                          // Add more positioned organs as needed
                        ],
                      ),
                    ),
                    // Text Content
                    const Text(
                      'AI Symptom Checker',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Get your symptom checked with our AI Technology, right here and now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Check Symptom Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add symptom checking logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BC34A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Check My Symptom',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}