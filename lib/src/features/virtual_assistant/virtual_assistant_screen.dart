import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class VirtualAssistantScreen extends StatefulWidget {
  const VirtualAssistantScreen({super.key});

  @override
  State<VirtualAssistantScreen> createState() => _VirtualAssistantScreenState();
}

class _VirtualAssistantScreenState extends State<VirtualAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: "Hi! I'm your virtual assistant powered by Gemini AI. I can help you with:\n\n"
          "• Information about app features\n"
          "• Answers to common questions\n\n"
          "What do you want to ask? 🤔",
      isUser: false,
    ),
  ];

  late final GenerativeModel _model;
  late final ChatSession _chat;

  // Define the system prompt
  static const String _systemPrompt = '''
    You are a medical virtual assistant that provides useful answers about diseases,
          symptoms, etc.only using the information from a primekg database
          already provided in the context.Prefer higher rated information in your context and
          add source links in your answers.
    ''';

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  void _initializeGemini() {
    const apiKey = 'AIzaSyAbmEte1Y0s4mY_xGpLaxWVku7kZ0soH8U'; // Replace with your actual API key
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    _model = model;
    _chat = model.startChat(history: [
      Content.text(_systemPrompt)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFFF4D4F),
              child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              'Gemini Assistant',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D4F),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    setState(() {
      _messages.add(ChatMessage(
        text: userMessage,
        isUser: true,
      ));
    });

    _messageController.clear();

    // Show typing indicator
    setState(() {
      _messages.add(const ChatMessage(
        text: "Typing...",
        isUser: false,
      ));
    });

    try {
      final response = await _chat.sendMessage(Content.text(userMessage));
      final botResponse = response.text ?? "I'm sorry, I couldn't generate a response.";

      setState(() {
        // Remove typing indicator
        _messages.removeLast();
        // Add bot response
        _messages.add(ChatMessage(
          text: botResponse,
          isUser: false,
        ));
      });
    } catch (e) {
      setState(() {
        // Remove typing indicator
        _messages.removeLast();
        // Add error message
        _messages.add(const ChatMessage(
          text: "Sorry, I encountered an error while processing your request.",
          isUser: false,
        ));
      });
      print('Error: $e');
    }
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              backgroundColor: Color(0xFFFF4D4F),
              child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFFFF4D4F) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}