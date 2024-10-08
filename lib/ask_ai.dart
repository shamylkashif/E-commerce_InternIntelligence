import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';

class AskAI extends StatefulWidget {
  const AskAI({super.key});

  @override
  State<AskAI> createState() => _AskAIState();
}

class _AskAIState extends State<AskAI> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      // Example AI response, replace this with actual AI response logic
      _messages.add({'sender': 'ai', 'text': 'This is the AI response to: $text'});
    });

    _controller.clear();  // Clear input field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'ASKY',
              style: TextStyle(fontSize: 24, color: blue),
            ),
          ),
          const Center(
            child: Icon(Icons.android_outlined, size: 100),
          ),

          // Chat UI
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: isUser ? blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Text(
                      message['text'] ?? '',
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        )
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: blue),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
