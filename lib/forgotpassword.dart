import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/reset.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 150,top: 40 ),
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Make Selection!',
            style: TextStyle(color: blue, fontSize: 18.0),
          ),
          SizedBox(height: 10.0),
          ListTile(
            leading: Icon(Icons.email, color: blue),
            title: Text(
              'E-Mail',
              style: TextStyle(color: blue),
            ),
            subtitle: Text(
              'Reset via Mail Verification',
              style: TextStyle(color: blue),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>  Reset())
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.phone, color: blue),
            title: Text(
              'Phone No',
              style: TextStyle(color: blue),
            ),
            subtitle: Text(
              'Reset via Phone Verification',
              style: TextStyle(color: blue),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Reset())
              );
            },
          ),
        ],
      ),
    );
  }
}
