import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/doctor/chat/chat_screen.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultation History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('startedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final consultations = snapshot.data?.docs ?? [];

          if (consultations.isEmpty) {
            return const Center(child: Text('No consultation history'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: consultations.length,
            itemBuilder: (context, index) {
              final consultation = consultations[index].data() as Map<String, dynamic>;
              final startedAt = consultation['startedAt'];
              
              // Handle null or invalid timestamp
              final DateTime dateTime;
              if (startedAt is Timestamp) {
                dateTime = startedAt.toDate();
              } else {
                dateTime = DateTime.now(); // Fallback if timestamp invalid
              }

              final isActive = consultation['status'] != 'completed';
              final chatRoomId = consultation['chatRoomId'] as String;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.1),
                    child: Text(
                      consultation['doctorName']?.substring(0, 1).toUpperCase() ?? 'D',
                      style: const TextStyle(
                        color: Color(0xFF5C6BC0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text('Dr. ${consultation['doctorName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(consultation['specialty'] ?? ''),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(dateTime),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isActive ? 'Active' : 'Completed',
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          doctorId: consultation['doctorId'],
                          doctorName: consultation['doctorName'],
                          specialty: consultation['specialty'],
                          chatRoomId: chatRoomId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}