import 'package:bookstore/post_ad.dart';
import 'package:bookstore/screens/home-pg.dart';
import 'package:bookstore/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'ask_ai.dart';
import 'commons/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.white,
        elevation: 10,
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 3),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/ppp.jpeg"),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Shamyl",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              "Online",
              style: TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle option selection here
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Text('Report'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Text('Block'),
                ),
                PopupMenuItem<String>(
                  value: 'Option 3',
                  child: Text('Clear chat'),
                ),

              ];
            },
            icon: Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[100], // Placeholder for chat messages
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement send functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: yellow,
      color: yellow,
      animationDuration: Duration(milliseconds: 300),
      items: [
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.home, size: 20, color:blue,),
              Text("Home", style: TextStyle(color: blue, fontSize: 10)),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchPage()));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search, size: 20, color: blue,),
              Text("Search", style: TextStyle(color: blue, fontSize: 10)),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AskAI()));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.android, size: 20, color: blue,),
              Text("Ask AI", style: TextStyle(color: blue, fontSize: 10)),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PostAD()));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 20, color: blue,),
              Text("Post Ad", style: TextStyle(color: blue, fontSize: 10)),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings, size: 20, color: blue,),
              Text("Settings", style: TextStyle(color: blue, fontSize: 10)),
            ],
          ),
        ),
      ],
    ),

    );
  }
}

