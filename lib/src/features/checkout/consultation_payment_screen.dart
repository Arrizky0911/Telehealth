import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/doctor/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/doctor/user_consultation.dart';
import 'package:myapp/src/features/doctor/widgets/doctor_card.dart';
import 'package:myapp/src/models/doctor.dart';

class ConsultationPaymentScreen extends StatefulWidget {
  final Doctor doctor;

  const ConsultationPaymentScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<ConsultationPaymentScreen> createState() => _ConsultationPaymentScreenState();
}

class _ConsultationPaymentScreenState extends State<ConsultationPaymentScreen> {
  final TextEditingController promoController = TextEditingController();
  String selectedPaymentMethod = 'DANA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorCard(doctor: widget.doctor, isCheckout: true,),
              const SizedBox(height: 24),
              _buildPaymentDetails(),
              const SizedBox(height: 24),
              _buildPaymentMethods(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildPayNowButton(context),
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
          _buildPaymentRow('Consultation Package (50min)', widget.doctor.price),
          _buildPaymentRow('Admin Fee', 20000),
          const Divider(height: 32),
          _buildPaymentRow('Grand Total', widget.doctor.price + 20000, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, int amount, {bool isTotal = false}) {
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
          _buildPaymentMethod('OVO', 'assets/ovo.png'),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String name, String iconPath) {
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = name),
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

  Widget _buildPayNowButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              // builder: (context) => ChatScreen(
              //   doctorId: widget.doctor.uid,
              //   doctorName: widget.doctor.name,
              //   specialty: widget.doctor.specialty,
              //   chatRoomId: '${FirebaseAuth.instance.currentUser!.uid}_${widget.doctor.uid}',
              // ),
              builder: (context) => const UserConsultation()
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C6BC0),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Pay Now',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

