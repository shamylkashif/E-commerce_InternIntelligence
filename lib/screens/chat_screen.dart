import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/my_chat.dart';
import 'package:flutter/material.dart';

class ChatPreviewScreen extends StatefulWidget {
  const ChatPreviewScreen({super.key});

  @override
  State<ChatPreviewScreen> createState() => _ChatPreviewScreenState();
}

class _ChatPreviewScreenState extends State<ChatPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: blue,),
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: SingleChildScrollView(
         child: Column(
               children: [
                   SizedBox(height: 10,),
                   Container(
                     margin: EdgeInsets.only(left: 5,right: 5),
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.black),
                       borderRadius: BorderRadius.circular(10)
                     ),
                     child: ChatPreviewTile(
                         title: 'Ali',
                         subtitle: 'Hi',
                         time: '1:45 PM',
                         imageAsset: 'assets/images/profile_placeholder.png'),
                   ),
                 SizedBox(height: 8,),
                 Container(
                   margin: EdgeInsets.only(left: 5,right: 5),
                   decoration: BoxDecoration(
                       border: Border.all(color: Colors.black),
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: ChatPreviewTile(
                       title: 'Areej',
                       subtitle: 'Acha',
                       time: '3:10 PM',
                       imageAsset: 'assets/images/profile_placeholder.png'),
                 ),
                 SizedBox(height: 8,),
                 Container(
                   margin: EdgeInsets.only(left: 5,right: 5),
                   decoration: BoxDecoration(
                       border: Border.all(color: Colors.black),
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: ChatPreviewTile(
                       title: 'Zarafshan',
                       subtitle: 'Gradle ka masla hai',
                       time: '7:30 PM',
                       imageAsset: 'assets/images/profile_placeholder.png'),
                 ),
                 SizedBox(height: 8,),
                 Container(
                   margin: EdgeInsets.only(left: 5,right: 5),
                   decoration: BoxDecoration(
                       border: Border.all(color: Colors.black),
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: ChatPreviewTile(
                       title: 'Rameeza',
                       subtitle: 'Moisturizer order krain?',
                       time: '8:00 PM',
                       imageAsset: 'assets/images/profile_placeholder.png'),
                 ),
                 SizedBox(height: 8,),
               ],
        ),
      ),
    );
  }
}

class ChatPreviewTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String time;
  final String imageAsset;

  const ChatPreviewTile(
      {super.key,
        required this.title,
        required this.subtitle,
        required this.time,
        required this.imageAsset,});

  @override
  State<ChatPreviewTile> createState() => _ChatPreviewTileState();
}

class _ChatPreviewTileState extends State<ChatPreviewTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(widget.imageAsset),
      ),
      title: Text(widget.title,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),),
      subtitle: Text(widget.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,  style: TextStyle(fontSize: 13,) ,),
      trailing: Text(widget.time, maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11),),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyChat()));
      },
    );
  }
}

