import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
           onTap: (){
             Navigator.pop(context);
           },
            child: Icon(Icons.arrow_back_ios, color: blue,)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text('Leave us a feedback', style: TextStyle(color: Colors.black,fontSize: 20),),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.only(left: 20,),
              padding: EdgeInsets.only(left: 15, top: 10),
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Color(0xFFE3DEA9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your feedback here',
                  hintStyle: const TextStyle(color: blue,),
                  contentPadding: EdgeInsets.zero
                ),
                maxLines: null,
                minLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 350,left: 20),
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(child: Text('Submit', style: TextStyle(color: blue,fontSize: 18),)),
            ),
          ],
        ),
      ),
    );
  }
}
