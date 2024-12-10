import 'package:flutter/material.dart';

class MedicalInformationData {
  final TextEditingController age = TextEditingController();
  final TextEditingController bloodType = TextEditingController();
  final TextEditingController allergies = TextEditingController();

  void loadFromMap(Map<String, dynamic> data) {
    age.text = (data['age'] ?? '').toString();
    bloodType.text = data['bloodType'] ?? '';
    allergies.text = data['allergies'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'age': int.tryParse(age.text),
      'bloodType': bloodType.text,
      'allergies': allergies.text,
    };
  }
}

class MedicalInformationWidget extends StatelessWidget {
  final MedicalInformationData data;
  final bool isEditing;

  const MedicalInformationWidget({
    Key? key,
    required this.data,
    required this.isEditing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medical Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.age,
          label: 'Age',
          enabled: isEditing,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            if (int.tryParse(value) == null) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.bloodType,
          label: 'Blood Type',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your blood type';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.allergies,
          label: 'Allergies',
          enabled: isEditing,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey[100] : null,
      ),
      validator: validator,
    );
  }
}

