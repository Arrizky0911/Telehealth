import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        backgroundColor: const Color(0xFF87CF3A),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('bookings').doc(bookingId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Booking not found'));
          }

          final bookingData = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildConfirmationHeader(),
                const SizedBox(height: 24),
                _buildAppointmentDetails(bookingData),
                const SizedBox(height: 24),
                _buildPatientDetails(bookingData),
                const SizedBox(height: 24),
                _buildPaymentDetails(bookingData),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfirmationHeader() {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF87CF3A),
          size: 64,
        ),
        const SizedBox(height: 16),
        const Text(
          'Booking Confirmed!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Booking ID: $bookingId',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentDetails(Map<String, dynamic> bookingData) {
    final appointmentDate = (bookingData['appointmentDate'] as Timestamp).toDate();
    final appointmentTime = bookingData['appointmentTime'] as String;

    return _buildSection(
      title: 'Appointment Details',
      children: [
        _buildDetailRow('Date', DateFormat('MMMM d, yyyy').format(appointmentDate)),
        _buildDetailRow('Time', appointmentTime),
        _buildDetailRow('Doctor', bookingData['doctorName'] ?? 'Not specified'),
        _buildDetailRow('Status', bookingData['status'] ?? 'Pending'),
      ],
    );
  }

  Widget _buildPatientDetails(Map<String, dynamic> bookingData) {
    return _buildSection(
      title: 'Patient Details',
      children: [
        _buildDetailRow('Name', '${bookingData['firstName']} ${bookingData['lastName']}'),
        _buildDetailRow('Email', bookingData['email']),
        _buildDetailRow('Phone', bookingData['phone']),
        _buildDetailRow('Gender', bookingData['gender']),
        _buildDetailRow('Age', bookingData['age']?.toString() ?? 'Not specified'),
        _buildDetailRow('Blood Type', bookingData['bloodType'] ?? 'Not specified'),
        _buildDetailRow('Allergies', bookingData['allergies'] ?? 'None'),
        _buildDetailRow('Medications', bookingData['medications'] ?? 'None'),
      ],
    );
  }

  Widget _buildPaymentDetails(Map<String, dynamic> bookingData) {
    return _buildSection(
      title: 'Payment Details',
      children: [
        _buildDetailRow('Payment Method', bookingData['paymentMethod']),
        _buildDetailRow('Consultation Fee', '\$${bookingData['consultationFee']}'),
        _buildDetailRow('Admin Fee', '\$44'),
        _buildDetailRow('Coupon Discount', '-\$24'),
        _buildDetailRow(
          'Total Amount',
          '\$${(bookingData['consultationFee'] + 44 - 24).toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
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
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

