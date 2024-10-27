import 'package:bookstore/new_password.dart';
import 'package:bookstore/screens/signup-screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'commons/colors.dart';


class PasswordVerification extends StatefulWidget {
  const PasswordVerification({super.key});

  @override
  State<PasswordVerification> createState() => _PasswordVerificationState();
}

class _PasswordVerificationState extends State<PasswordVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: InkWell(
             onTap: (){
               Navigator.pop(context);
             },
             child: Icon(Icons.arrow_circle_left_outlined)),
         title: Text('Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text('Enter verification code', ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index)=> SizedBox(
                width: 50,
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: "",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              )
              )
            ),
            SizedBox(height: 15,),
            RichText(
                text:TextSpan(
                  text: "If you didn\'t receive a code,",
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "\ Resend",
                      style: const TextStyle(color: Colors.red),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        print('Resend Tapped');
                      }
                    )
                  ]
                )
            ),
            SizedBox(height: 50,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPassword()));
              },
              child: Container(
                height: 55,
                width: 320,
                decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(28), left: Radius.circular(28))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text('Send',
                    style: TextStyle(color: blue,fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 70,),
            Text('or', style: TextStyle(fontSize: 18),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [
                        Color(0xFFEA4335), // Google Red
                        Color(0xFFFBBC05), // Google Yellow
                        Color(0xFF34A853), // Google Green
                        Color(0xFF4285F4), // Google Blue
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: InkWell(
                    onTap: (){

                    },
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      size: 30,
                      color: Colors.white, // Base color for gradient
                    ),
                  ),
                ),
                SizedBox(width: 25,),
                InkWell(
                    onTap: (){

                    },
                    child: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue, size: 30,))

              ],),
            SizedBox(height: 70,),
            Text('Don\'t have an Account?'),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
              },
              child: Container(
                height: 55,
                width: 320,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(28), left: Radius.circular(28))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text('Sign up',
                    style: TextStyle(color: blue,fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
