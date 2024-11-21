import 'package:flutter/material.dart';
import 'package:myapp/src/features/main/doctor/doctor_list_screen.dart';

class VirtualConsultationsCard extends StatelessWidget {
  const VirtualConsultationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consultation with Doctor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '1,254+',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDoctorCard(
              'Dr. Hannibal Lector',
              '4.1',
              'Orthopedics',
              '10:25 AM - 11:25 AM',
            ),
            const SizedBox(height: 10),
            _buildDoctorCard(
              'Dr. Johann Liebert',
              '3.8',
              'Cardiologist',
              '10:25 AM - 11:25 AM',
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DoctorListScreen())
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF5C6BC0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xFF5C6BC0),
                    ),
                  ],
                ),
              ),


          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(String name, String rating, String specialty, String time) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF7986CB),
            child: Text(
              name.substring(0, 2),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.check_circle, color: Color(0xFF5C6BC0), size: 16),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(rating),
                    const SizedBox(width: 5),
                    Text(specialty, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(time, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}