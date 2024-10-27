import 'package:bookstore/password_verification.dart';
import 'package:bookstore/screens/signup-screen.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: blue,)),
        title: Text('Forgot Password', ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text('Enter Email Address registered with this platform', ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  labelText: 'abc@gmail.com',
                  labelStyle: const TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(28)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(28)
                    )
                ),
              ),
            ),
            SizedBox(height: 18,),
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Text('Back to Sign in')),
            SizedBox(height: 35,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PasswordVerification()));
              },
              child: Container(
                height: 55,
                width: 310,
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
            Text('Don\'t have an Account'),
            SizedBox(height: 15,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
              },
              child: Container(
                height: 55,
                width: 310,
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
