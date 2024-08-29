import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/home-pg.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:bookstore/screens/my-profile.dart';
import 'package:bookstore/setting.dart';
import 'package:flutter/material.dart';

import 'complain.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: backGround,
         appBar: AppBar(
           backgroundColor: backGround,
           leading: InkWell(
               onTap: (){
                 Navigator.pop(context);
               },
               child: Icon(Icons.arrow_back_ios, color: blue,)
           ),
           actions: [
             TextButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                 },
                 child: Container(
                    height: 33,
                    width: 75,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(15)
                    ),
                   child: Center(child: Text('LogOut', style: TextStyle(color: blue, fontSize: 16),)),
                 ),
             ),
           ],
         ),
         body: Column(
           children: [
             SizedBox(height: 15,),
             Center(
               child: Container(
                 height: 250,
                 width: 300,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(colors: [
                     yellow, blue
                   ],
                     begin: const FractionalOffset(0.5, 1),
                     end: const FractionalOffset(1.0, 0.0),
                   ),
                   borderRadius: BorderRadius.circular(25)
                 ),
                 child: Column(
                   children: [
                      SizedBox(height: 12,),
                      CircleAvatar(
                        radius: 40,
                      ),
                     SizedBox(height: 8,),
                     Text('Clara Albert',
                       style: TextStyle(
                           fontSize: 24,
                           color: backGround,
                           height: 1.0
                       ),),
                     Text('ClaraAlbert@gmail.com',
                       style: TextStyle(
                           fontSize: 16,
                           color: backGround,
                           height: 1.0
                       ),),
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50,top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                                },
                                child: Container(
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: yellow.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Profile', style: TextStyle(color: Colors.black),),
                                      Icon(Icons.person)
                                    ],
                                  )
                                ),
                              ),
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap : (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
                                },
                                child: Container(
                                    height: 35,
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: yellow.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('Settings', style: TextStyle(color: Colors.black),),
                                        Icon(Icons.settings)
                                      ],
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                   ],
                 ),
               ),
             ),
             SizedBox(height: 30,),
             Container(
               height: 150,
               width: 300,
               decoration: BoxDecoration(
                 color: Color(0xFFE3DEA9),
                 borderRadius: BorderRadius.circular(25)
               ),
               child: Column(
                 children: [
                   SizedBox(height: 15,),
                   GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                     },
                     child: Container(
                       height: 50,
                       width: 250,
                       decoration: BoxDecoration(
                         color: backGround,
                         borderRadius: BorderRadius.circular(15)
                       ),
                       child: Row(
                         children: [
                           Padding(padding: EdgeInsets.only(left: 10)),
                           Icon(Icons.dashboard_outlined),
                           SizedBox(width: 8,),
                           Text('Dashboard', style: TextStyle(fontSize: 14),)
                         ],
                       ),
                     ),
                   ),
                   SizedBox(height: 10,),
                   GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Complaint()));
                     },
                     child: Container(
                       height: 50,
                       width: 250,
                       decoration: BoxDecoration(
                           color: backGround,
                           borderRadius: BorderRadius.circular(15)
                       ),
                       child: Row(
                         children: [
                           Padding(padding: EdgeInsets.only(left: 10)),
                           Icon(Icons.comment_bank_outlined),
                           SizedBox(width: 8,),
                           Text('Complaint', style: TextStyle(fontSize: 14),)
                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
    );
  }
}
