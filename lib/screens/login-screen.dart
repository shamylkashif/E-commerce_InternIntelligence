import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/home-pg.dart';
import 'package:bookstore/screens/signup-screen.dart';
import 'package:flutter/material.dart';

import '../forgotpassword.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:  Stack(
          children: [
            Container(
              decoration:const  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backgrdImg (2).png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width,80.0),
                ),
              ),
              child: Stack(
                children:[
                  Padding(
                    padding: const EdgeInsets.only(top: 30,left: 60),
                    child: Image.asset('assets/LogoWot.png',height: 240,width: 240,),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250, left: 47),
              child: Container(
                height: 150,
                width: 265,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4,4), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 14,),
                    Container(
                      width: 400,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'User Name',
                          labelStyle: const TextStyle(color: blue,),
                          suffixIcon: const Icon(Icons.person_2, color: blue,),

                        ),
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: blue,),
                          suffixIcon: const Icon(Icons.password, color: blue,),
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 415,left: 116),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                 child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 45,vertical: 5),
                  decoration:BoxDecoration(borderRadius: BorderRadius.circular(12) ,color: yellow,
                    boxShadow: const [
                    BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    offset: Offset(2, 2), // Shadow position
                  ),
                  ]),
                  child: const Text("Login", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: blue,),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 465, left: 125),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                },
                  child: Text('Forgot Password?', style: TextStyle(color: blue, fontSize: 15),)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 490, left: 95),
              child: Row(
                children: [
                  const Text(
                    'Do not have an account?',
                    style: TextStyle(fontSize: 13, color: blue),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 15,
                        color: blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      
        ),
    );
  }
}

