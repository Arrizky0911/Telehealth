import 'package:flutter/material.dart';

class AddressData {
  final TextEditingController street = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController postalCode = TextEditingController();

  void loadFromMap(Map<String, dynamic> data) {
    street.text = data['street'] ?? '';
    city.text = data['city'] ?? '';
    state.text = data['state'] ?? '';
    postalCode.text = data['postalCode'] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street.text,
      'city': city.text,
      'state': state.text,
      'postalCode': postalCode.text,
    };
  }
}

class AddressWidget extends StatelessWidget {
  final AddressData data;
  final bool isEditing;

  const AddressWidget({
    super.key,
    required this.data,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.street,
          label: 'Street Address',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your street address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.city,
          label: 'City',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your city';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.state,
          label: 'State',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your state';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: data.postalCode,
          label: 'Postal Code',
          enabled: isEditing,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your postal code';
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
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

