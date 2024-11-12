import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';  // Assuming blue is defined in this file
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';


class AskAI extends StatefulWidget {
  const AskAI({super.key});

  @override
  State<AskAI> createState() => _AskAIState();
}

class _AskAIState extends State<AskAI> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static const apiKey = "AIzaSyBsZQ_7YnehpN-B2uk_h_OTJUjhSq_2UzM";
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> _messages = [];

  Future<void> sendMessage() async{
    final message = _controller.text;
    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
      _controller.clear();
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(isUser: false, message: response.text?? "", date: DateTime.now()));
    });
    //Scroll to bottom after message is added
    _scrollToBottom();
  }

  //Method to scroll to bottom
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), (){
      if(_scrollController.hasClients){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header and logo section
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Icon(Icons.android_outlined, size: 100, color: blue),
              ),
              SizedBox(width: 10),
            ],
          ),

          // Chat UI
          Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount:_messages.length,itemBuilder: (context,index){
                  final message = _messages[index];
                  return Messages(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
              })
          ),
          // Message Input
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: blue),
                  onPressed: () {
                    sendMessage();
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message{
  final bool isUser;
  final String message;
  final DateTime date;
  Message({ required this.isUser, required this.message, required this.date});
}
class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages(
      {
        super.key,
        required this.isUser,
        required this.message,
        required this.date
      });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
          left: isUser ? 100:10,
          right: isUser ? 10: 100
      ),
      decoration: BoxDecoration(
          color: isUser ? blue : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: isUser ? Radius.circular(10): Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: isUser ? Radius.zero : Radius.circular(10)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16,color: isUser ? Colors.white: Colors.black),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 10,color: isUser ? Colors.white: Colors.black,),
          )
        ],
      ),
    );
  }
}
