import 'package:flutter/material.dart';

class GenderSelection extends StatelessWidget {
  final String selectedGender;
  final Function(String) onChanged;

  const GenderSelection({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildGenderOption('Male', Icons.male),
        const SizedBox(width: 16),
        _buildGenderOption('Female', Icons.female),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = selectedGender == gender;
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(gender),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF87CF3A) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF87CF3A) : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                gender,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

