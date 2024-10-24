import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class MyChat extends StatefulWidget {
  const MyChat({super.key});

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: blue,
        elevation: 10,
        leading: GestureDetector(
            onTap: (){
             Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
          ),
          title: Text('Shamyl',
            style:TextStyle(fontSize: 16, color: Colors.white) ,),
          subtitle: Text('Online',
            style:TextStyle(fontSize: 14, color: Colors.green) ,),
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
              color: Colors.white,
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
                    color: blue,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.emoji_emotions,
                    color: blue,
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
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
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
                  icon: Icon(Icons.send, color: blue,),
                  onPressed: () {
                    // Implement send functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
