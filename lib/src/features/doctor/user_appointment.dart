import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/models/doctor.dart';
import 'package:myapp/src/models/appointment.dart';

class UserAppointment extends StatefulWidget {
  const UserAppointment({Key? key}) : super(key: key);

  @override
  _UserAppointmentState createState() => _UserAppointmentState();
}

class _UserAppointmentState extends State<UserAppointment> {
  final List<Appointment> appointments = [
    Appointment(
      doctor: Doctor(
        uid: '1',
        email: 'spike.brown@example.com',
        name: 'Dr. Spike Brown',
        specialty: 'Certified Cardiologist',
        experience: '10 years',
        about: 'Experienced cardiologist specializing in heart health.',
        price: 50,
        rating: 4.5,
        availableTimes: ['09:00 AM', '11:00 AM', '02:00 PM'],
        isOnline: true,
        isActive: true,
        totalReviews: 120,
        reviews: [
          {'rating': 5, 'comment': 'Great doctor!'},
          {'rating': 4, 'comment': 'Very professional'},
        ],
        imageUri: 'assets/doctor1.jpg',
      ),
      type: 'General Health Checkup',
      time: '10:25 - 11:25 AM',
    ),
    // Add more appointments as needed
  ];

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: appointments.isEmpty
            ? _buildEmptyState(context)
            : _buildAppointmentList(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          _buildBackButton(context),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/calendar.png', height: 150),
                const SizedBox(height: 20),
                const Text(
                  'Your Appointments',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'You have 0 appointments',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Schedule an Appointment +'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF87CF3A),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(BuildContext context) {
    return Container(
      color: const Color(0xFF87CF3A),
      child: Column(
        children: [
          _buildDateSelector(context),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  return _buildAppointmentCard(appointments[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildBackButton(context, light: true),
              const SizedBox(width: 16),
              const Text(
                'My Appointments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                return _buildDateCard(date);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard(DateTime date) {
    final isSelected = date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year;

    return GestureDetector(
      onTap: () => setState(() => selectedDate = date),
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                color: isSelected ? const Color(0xFF87CF3A) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected ? const Color(0xFF87CF3A) : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(appointment.doctor.imageUri),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        appointment.doctor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.check_circle,
                        color: appointment.doctor.isOnline ? const Color(
                            0xFF87CF3A) : Colors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                  Text(
                    appointment.doctor.specialty,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    appointment.type,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      const Icon(
                          Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        appointment.time,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        '\$${appointment.doctor.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF87CF3A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, {bool light = false}) {
    return Container(
      decoration: BoxDecoration(
        border: light ? null : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: light ? Colors.white.withOpacity(0.2) : null,
      ),
      child: IconButton(
        icon: Icon(
            Icons.arrow_back, color: light ? Colors.white : Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}