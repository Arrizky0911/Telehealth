import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/appointment.dart';
import 'package:myapp/src/models/order.dart';


class BookingConfirmationScreen extends StatelessWidget {
  final String bookingId;

  const BookingConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Booking Confirmation',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('appointments')
            .doc(bookingId)
            .get(),
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

          final bookingData = snapshot.data!.data()!;
          final appointment = Appointment(
            id: bookingData['id'],
            userId: bookingData['userId'],
            doctorId: bookingData['doctorId'],
            firstName: bookingData['firstName'],
            lastName: bookingData['lastName'],
            email: bookingData['email'],
            phone: bookingData['phone'],
            address: Address(
              street: bookingData['address']['street'],
              city: bookingData['address']['city'],
              state: bookingData['address']['state'],
              postalCode: bookingData['address']['postalCode'],
            ),
            age: bookingData['age'],
            gender: bookingData['gender'],
            bloodType: bookingData['bloodType'],
            allergies: bookingData['allergies'],
            medications: bookingData['medications'],
            complaint: bookingData['complaint'],
            comments: bookingData['comments'],
            appointmentDate: (bookingData['appointmentDate'] as Timestamp).toDate(),
            appointmentTime: bookingData['appointmentTime'],
            paymentMethod: bookingData['paymentMethod'],
            consultationFee: bookingData['consultationFee'],
            status: bookingData['status'],
            createdAt: (bookingData['createdAt'] as Timestamp).toDate(),
          );

          return _buildConfirmationContent(appointment);
        },
      ),
    );
  }

  Widget _buildConfirmationContent(Appointment appointment) {
    final currencyFormat =
    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          _buildDetailRow('Appointment ID', appointment.id),
          _buildDetailRow('Patient Name',
              '${appointment.firstName} ${appointment.lastName}'),
          _buildDetailRow('Doctor ID', appointment.doctorId), // Show doctor ID
          _buildDetailRow(
              'Appointment Date',
              DateFormat('yyyy-MM-dd')
                  .format(appointment.appointmentDate)),
          _buildDetailRow('Appointment Time', appointment.appointmentTime),
          _buildDetailRow('Consultation Fee',
              currencyFormat.format(appointment.consultationFee)),
          _buildDetailRow('Payment Method', appointment.paymentMethod),
          // ... add more details as needed
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}