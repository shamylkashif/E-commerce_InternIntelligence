import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class AskAI extends StatefulWidget {
  const AskAI({super.key});

  @override
  State<AskAI> createState() => _AskAIState();
}

class _AskAIState extends State<AskAI> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: Column(
           children: [
             Center(child: Text('Asky', style: TextStyle(fontSize: 24, color: blue),)),
             Container(
               margin: EdgeInsets.only(top: 20,left: 120),
               height: 90,
               width: 90,
               decoration: BoxDecoration(
                 color: yellow,
                 shape: BoxShape.circle,
               ),
             ),
           ],
         ),
    );
  }
}
