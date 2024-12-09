import 'package:flutter/material.dart';

class ShippingAddress extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final VoidCallback saveAddress;

  const ShippingAddress({
    Key? key,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.saveAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Colors.grey[600], size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _showAddressDialog(context),
                child: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatAddress(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAddress() {
    if (streetController.text.isEmpty &&
        cityController.text.isEmpty &&
        stateController.text.isEmpty &&
        postalCodeController.text.isEmpty) {
      return 'No address set';
    }

    return '${streetController.text}\n${cityController.text}, ${stateController.text} ${postalCodeController.text}'
        .trim();
  }

  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Address'),
        content: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    hintText: 'Enter your street address',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    hintText: 'Enter your city',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: stateController,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          hintText: 'Enter your state',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: postalCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Postal Code',
                          hintText: 'Enter your postal code',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              saveAddress();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

