import 'package:flutter/material.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/features/onboarding/signature_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return FormLayout(
        items: [
          const Text(
            'Review Terms',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please review the following terms and conditions for our digital health application:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildTermSection(
            '1. Data Collection',
            'We collect health-related data through our application, including but not limited to activity levels, heart rate, and sleep patterns.',
          ),
          _buildTermSection(
            '2. Data Use',
            'Your data will be used to provide personalized health insights and recommendations. We may also use anonymized data for research purposes.',
          ),
          _buildTermSection(
            '3. Data Protection',
            'We implement industry-standard security measures to protect your personal health information.',
          ),
          _buildTermSection(
            '4. Third-Party Sharing',
            'We do not sell your personal data. We may share anonymized data with research partners.',
          ),
          _buildTermSection(
            '5. User Rights',
            'You have the right to access, correct, or delete your personal data at any time.',
          ),
          _buildTermSection(
            '6. Updates to Terms',
            'We may update these terms from time to time. You will be notified of any significant changes.',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                value: _isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    _isAgreed = value ?? false;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAgreed = !_isAgreed;
                    });
                  },
                  child: const Text(
                    'I agree with the terms and conditions',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16,),
          Center(
            child: RoundButton(
              label: 'Next',
              onPressed: _isAgreed
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignatureScreen()),
                );
              } : null, color: const Color(0xFF4B5BA6),
            ),
          ),
          const SizedBox(height: 16,),

      ],
    );

  }

  Widget _buildTermSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}