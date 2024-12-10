import 'package:flutter/material.dart';

class PersonalDetailsData {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  void loadFromMap(Map<String, dynamic> data) {
    firstName.text = data['firstName'] ?? '';
    lastName.text = data['lastName'] ?? '';
    email.text = data['email'] ?? '';
    phone.text = data['phone'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName.text,
      'lastName': lastName.text,
      'email': email.text,
      'phone': phone.text,
    };
  }
}

class PersonalDetailsWidget extends StatelessWidget {
  final PersonalDetailsData data;
  final bool isEditing;

  const PersonalDetailsWidget({
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
          'Personal Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.firstName,
          label: 'First Name',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.lastName,
          label: 'Last Name',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.email,
          label: 'Email',
          enabled: false,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.phone,
          label: 'Phone Number',
          enabled: isEditing,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 12) {
              return 'Phone number must be at least 12 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
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

