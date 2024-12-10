import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/checkout/book_confirmation.dart';
import 'package:myapp/src/models/doctor.dart';
import 'package:myapp/src/features/doctor/widgets/doctor_card.dart';
import 'package:myapp/src/features/checkout/widgets/patient_details_step.dart';
import 'package:myapp/src/features/checkout/widgets/time_and_date_step.dart';
import 'package:myapp/src/features/checkout/widgets/payment_step.dart';
import 'package:intl/intl.dart';

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
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers and Values
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _complaintController = TextEditingController();
  final _commentsController = TextEditingController();
  final _promoController = TextEditingController();
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
  DateTime _birthDate = DateTime(2000);
  String _selectedPaymentMethod = 'DANA';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userData.exists) {
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _streetController.text = userData['address']['street'] ?? '';
          _cityController.text = userData['address']['city'] ?? '';
          _stateController.text = userData['address']['state'] ?? '';
          _postalCodeController.text = userData['address']['postalCode'] ?? '';
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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStepper(),
          DoctorCard(doctor: widget.doctor, isCheckout: true,),
          Expanded(
            child: SingleChildScrollView(
              child: _buildCurrentStep(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      title: const Text(
        'Book Doctor',
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buildStepperItem('Patient Detail', 0),
          _buildStepperLine(0),
          _buildStepperItem('Time & Date', 1),
          _buildStepperLine(1),
          _buildStepperItem('Payment', 2),
        ],
      ),
    );
  }

  Widget _buildStepperItem(String title, int step) {
    final isActive = _currentStep >= step;
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF87CF3A) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: isActive
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperLine(int step) {
    final isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF87CF3A) : Colors.grey[300],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return PatientDetailsStep(
          formKey: _formKey,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          complaintController: _complaintController,
          commentsController: _commentsController,
          streetController: _streetController,
          cityController: _cityController,
          stateController: _stateController,
          postalCodeController: _postalCodeController,
          ageController: _ageController,
          bloodTypeController: _bloodTypeController,
          allergiesController: _allergiesController,
          selectedGender: _selectedGender,
          birthDate: _birthDate,
          onGenderChanged: (gender) => setState(() => _selectedGender = gender),
          onBirthDateChanged: (date) => setState(() => _birthDate = date),
        );
      case 1:
        return TimeAndDateStep(
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          availableTimes: widget.doctor.availableTimes,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          onTimeSelected: (time) => setState(() => _selectedTime = time),
        );
      case 2:
        return PaymentStep(
          doctor: widget.doctor,
          promoController: _promoController,
          selectedPaymentMethod: _selectedPaymentMethod,
          onPaymentMethodChanged: (method) => setState(() => _selectedPaymentMethod = method),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomBar() {
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
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            _handleBooking();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF87CF3A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _currentStep < 2 ? 'Continue' : 'Confirm Booking',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        final appointmentId = _generateAppointmentId();
        final bookingData = {
          'appointmentId': appointmentId,
          'userId': user.uid,
          'doctorId': widget.doctor.uid,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': {
            'street': _streetController.text,
            'city': _cityController.text,
            'state': _stateController.text,
            'postalCode': _postalCodeController.text,
          },
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _selectedGender,
          'bloodType': _bloodTypeController.text,
          'allergies': _allergiesController.text,
          'medications': _medicationsController.text,
          'complaint': _complaintController.text,
          'comments': _commentsController.text,
          'appointmentDate': Timestamp.fromDate(_selectedDate),
          'appointmentTime': _selectedTime,
          'paymentMethod': _selectedPaymentMethod,
          'consultationFee': widget.doctor.price,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        };

        try {
          // Create a new document with an auto-generated ID
          final docRef = await FirebaseFirestore.instance.collection('bookings')
              .add(bookingData);

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

