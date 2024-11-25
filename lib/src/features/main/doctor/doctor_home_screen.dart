import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/src/features/main/doctor/chat_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    try {
      // Update offline status
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(user?.uid)
          .update({'isOnline': false});
          
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('User not found'));
    }

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error');
            }

            if (!snapshot.hasData) {
              return const Text('Loading...');
            }

            final doctorData = snapshot.data!.data() as Map<String, dynamic>;
            return Text('Dr. ${doctorData['name']}');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('doctorId', isEqualTo: user!.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data?.docs ?? [];

          if (chats.isEmpty) {
            return const Center(
              child: Text('Belum ada konsultasi aktif'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF7986CB),
                  child: Text(
                    chat['patientName']?.substring(0, 2).toUpperCase() ?? '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(chat['patientName'] ?? 'Unknown'),
                subtitle: Text(chat['lastMessage'] ?? ''),
                trailing: chat['unreadCount'] > 0
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${chat['unreadCount']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        doctorId: chat['doctorId'],
                        doctorName: chat['doctorName'],
                        specialty: chat['specialty'],
                        chatRoomId: chat['chatRoomId'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}