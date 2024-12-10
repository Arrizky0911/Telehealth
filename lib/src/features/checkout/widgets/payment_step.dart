import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/doctor.dart';

class PaymentStep extends StatelessWidget {
  final Doctor doctor;
  final TextEditingController promoController;
  final String selectedPaymentMethod;
  final Function(String) onPaymentMethodChanged;

  const PaymentStep({
    Key? key,
    required this.doctor,
    required this.promoController,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentDetails(),
          const SizedBox(height: 24),
          _buildPaymentMethods(),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentRow('Consultation Package (50min)', doctor.price.toDouble()),
          _buildPaymentRow('Admin Fee', 20000),
          const Divider(height: 32),
          _buildPaymentRow('Grand Total', doctor.price + 20000, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
          Text(
            NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(amount),
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentMethod('DANA', 'assets/dana.png'),
          _buildPaymentMethod('GoPay', 'assets/gopay.png'),
          _buildPaymentMethod('OVO', 'assets/ovo.png')
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String name, String iconPath) {
    return GestureDetector(
      onTap: () => onPaymentMethodChanged(name),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPaymentMethod == name
                ? const Color(0xFF87CF3A)
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 40, height: 40),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (selectedPaymentMethod == name)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF87CF3A),
              ),
          ],
        ),
      ),
    );
  }
}

