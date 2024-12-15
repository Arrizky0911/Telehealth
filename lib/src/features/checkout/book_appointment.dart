import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/checkout/book_confirmation.dart';
import 'package:myapp/src/features/doctor/widgets/doctor_card.dart';
import 'package:myapp/src/models/appointment.dart';
import 'package:myapp/src/models/doctor.dart';
import 'package:myapp/src/models/order.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  const BookAppointmentScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers and Values
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _complaintController = TextEditingController();
  final _commentsController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _ageController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();

  String _selectedGender = 'Female';
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  String _selectedPaymentMethod = 'DANA';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _streetController.text = userData['address']?['street'] ?? '';
          _cityController.text = userData['address']?['city'] ?? '';
          _stateController.text = userData['address']?['state'] ?? '';
          _postalCodeController.text = userData['address']?['postalCode'] ?? '';
          _ageController.text = userData['age']?.toString() ?? '';
          _bloodTypeController.text = userData['bloodType'] ?? '';
          _allergiesController.text = userData['allergies'] ?? '';
          _medicationsController.text = userData['medications'] ?? '';
          _emailController.text = user.email ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Information
              DoctorCard(doctor: widget.doctor, isCheckout: true),
              const SizedBox(height: 24),

              // Patient Details Section
              _buildSectionTitle('Patient Details'),
              _buildTextFormField('First Name', _firstNameController),
              _buildTextFormField('Last Name', _lastNameController),
              _buildTextFormField('Email', _emailController),
              _buildTextFormField('Phone', _phoneController),
              _buildTextFormField('Complaint', _complaintController),
              _buildTextFormField('Comments', _commentsController),
              _buildTextFormField('Street', _streetController),
              _buildTextFormField('City', _cityController),
              _buildTextFormField('State', _stateController),
              _buildTextFormField('Postal Code', _postalCodeController),
              _buildTextFormField('Age', _ageController),
              _buildTextFormField('Blood Type', _bloodTypeController),
              _buildTextFormField('Allergies', _allergiesController),
              _buildTextFormField('Medications', _medicationsController),

              const SizedBox(height: 24),

              // Time & Date Section
              _buildSectionTitle('Time & Date'),
              _buildDatePicker(),
              _buildTimePicker(),

              const SizedBox(height: 24),

              // Payment Section
              _buildSectionTitle('Payment'),
              _buildPaymentMethodDropdown(),

              const SizedBox(height: 32),

              // Confirm Booking Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4081),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Appointment Date',
                ),
                child: Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const Icon(Icons.access_time),
          const SizedBox(width: 16),
          Expanded(
            child: InkWell(
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    _selectedTime =
                    '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Appointment Time',
                ),
                child: Text(_selectedTime ?? 'Select Time'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedPaymentMethod,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Payment Method',
        ),
        items: ['DANA', 'OVO', 'GoPay']
            .map((method) => DropdownMenuItem(
          value: method,
          child: Text(method),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
      ),
    );
  }

  String _generateAppointmentId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> _handleBooking() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Create Address object
          Address address = Address(
            street: _streetController.text,
            city: _cityController.text,
            state: _stateController.text,
            postalCode: _postalCodeController.text,
          );

          // Create Booking object
          Appointment appointment = Appointment(
            id: '',
            userId: user.uid,
            doctorId: widget.doctor.uid,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            address: address,
            age: int.tryParse(_ageController.text) ?? 0,
            gender: _selectedGender,
            bloodType: _bloodTypeController.text,
            allergies: _allergiesController.text,
            medications: _medicationsController.text,
            complaint: _complaintController.text,
            comments: _commentsController.text,
            appointmentDate: _selectedDate,
            appointmentTime: _selectedTime!,
            paymentMethod: _selectedPaymentMethod,
            consultationFee: widget.doctor.price,
            status: 'pending',
            createdAt: DateTime.now(),
          );

          // Store the booking data in Firestore
          final docRef = await FirebaseFirestore.instance
              .collection('appointments')
              .add(appointment.toMap());

          // Update the document with its ID
          await docRef.update({'id': docRef.id});

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BookingConfirmationScreen(bookingId: docRef.id),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating booking: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    }
  }
}