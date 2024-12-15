import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/doctor/doctor/diagnosis_tools.dart';
import 'package:myapp/src/features/doctor/doctor/doctor_consultation_screen.dart';
import 'package:myapp/src/features/virtual_assistant/virtual_assistant_screen.dart';
import 'package:myapp/src/features/welcome/enter_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    try {
      // First attempt to update online status
      try {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user?.uid)
            .update({'isOnline': false});
      } catch (e) {
        // If updating online status fails, continue with logout anyway
        debugPrint('Failed to update online status: $e');
      }

      // Always attempt to sign out
      await FirebaseAuth.instance.signOut();

      // If we reach here, sign out was successful
      if (mounted) {
        // Navigate to login screen and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const EnterScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('Loading...');
            }
            final doctorData = snapshot.data!.data() as Map<String, dynamic>;
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  radius: 20,
                  child: Text(
                    doctorData['name'].substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${doctorData['name']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: doctorData['isOnline']
                                ? Colors.green[400]
                                : Colors.grey[400],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (doctorData['isOnline']
                                    ? Colors.green[400]
                                    : Colors.grey[400])!
                                    .withOpacity(0.3),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctorData['isOnline'] ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey[700]),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              children: [
                buildMenuCard(
                    context,
                    'Consultations',
                    Icons.people
                ),
                buildMenuCard(
                    context,
                    'Appointments',
                    Icons.punch_clock
                ),
                buildMenuCard(
                    context,
                    'Doctor Diagnosis Tools',
                    Icons.medical_services
                ),
                buildMenuCard(
                    context,
                    'VA Precise Medicine',
                    Icons.assistant
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuCard(
      BuildContext context,
      String title,
      IconData icon,
      ) {
    VoidCallback? onTap;

    if (title == 'Doctor Diagnosis Tools') {
      onTap = () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DiagnosisTools()),
      );
    } else if (title == 'Consultations') {
      onTap = () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DoctorConsultationScreen()),
      );
    } else if (title == 'VA Precise Medicine') {
      onTap = () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VirtualAssistantScreen()),
      );
    } else if (title == 'Appointment') {
      onTap = () => {};
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFFFF4081)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF4081),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

