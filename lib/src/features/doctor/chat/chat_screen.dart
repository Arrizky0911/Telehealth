import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final String specialty;
  String chatRoomId;

  ChatScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.chatRoomId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _patientName;
  bool _isNewChat = false;

  @override
  void initState() {
    super.initState();
    _isNewChat = widget.chatRoomId.isEmpty;
    _loadPatientName().then((_) {
      if (_isNewChat) {
        _createNewChat();
      }
    });
  }

  Future<void> _loadPatientName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _patientName = userDoc.data()?['name'] as String?;
      });
    } catch (e) {
      debugPrint('Error loading patient name: $e');
    }
  }

  Future<void> _createNewChat() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final newChatRoomId = '${user.uid}_${widget.doctorId}_$timestamp';

      // Create new chat document first
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(newChatRoomId)
          .set({
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'specialty': widget.specialty,
        'patientId': user.uid,
        'patientName': _patientName,
        'chatRoomId': newChatRoomId,
        'startedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // it's for creating consultation history
      await FirebaseFirestore.instance
          .collection('consultations')
          .doc(user.uid)
          .collection('history')
          .add({
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'specialty': widget.specialty,
        'patientId': user.uid,
        'patientName': _patientName,
        'chatRoomId': newChatRoomId,
        'startedAt': FieldValue.serverTimestamp(),
        'status': 'active',
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // Update widget chatRoomId
      setState(() {
        widget.chatRoomId = newChatRoomId;
      });

      // Init chat, bcz previously too much error with some reason, then we do this
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(newChatRoomId)
          .collection('messages')
          .add({
        'senderId': 'system',
        'message': 'Chat consultation started',
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'system'
      });

    } catch (e) {
      debugPrint('Error creating new chat: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final message = _messageController.text.trim();
      _messageController.clear();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'message': message,
        'senderId': user.uid,
        'senderName': _patientName ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update last message
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatRoomId)
          .update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
    }
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF5C6BC0) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['message'] as String,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dr. ${widget.doctorName}'),
            Text(
              widget.specialty,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(widget.chatRoomId)
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.hasData) {
            final chatData = chatSnapshot.data?.data() as Map<String, dynamic>?;
            final isCompleted = chatData?['status'] == 'completed';

            return Column(
              children: [
                if (isCompleted)
                  Container(
                    color: Colors.red[50],
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text(
                          'This consultation has ended',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(widget.chatRoomId)
                        .collection('messages')
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data?.docs ?? [];

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index].data() as Map<String, dynamic>;
                                final isMe = message['senderId'] == FirebaseAuth.instance.currentUser?.uid;

                                return _buildMessage(message, isMe);
                              },
                            ),
                          ),
                          if (!isCompleted) _buildMessageInput(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}