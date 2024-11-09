import 'package:flutter/material.dart';

class AIChatbotCard extends StatelessWidget {
  const AIChatbotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF7986CB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'AI Chatbot',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '4,578+',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'Total Conversations',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '24 Left',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.speed,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Slow Speed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,)

              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}