import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:bookstore/screens/profile_choice.dart';
import 'package:bookstore/setting.dart';
import 'package:flutter/material.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
} 

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
           automaticallyImplyLeading: false,
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
                 height: 180,
                 width: 300,
                 decoration: BoxDecoration(
                   gradient: LinearGradient(colors: [
                     yellow, blue
                   ],
                     begin: const FractionalOffset(0.5, 1),
                     end: const FractionalOffset(1.0, 0.0),
                   ),
                   borderRadius: BorderRadius.circular(25),

                 ),
                 child: Column(
                   children: [
                      SizedBox(height: 16,),
                     Stack(
                       children: [
                         Center(
                           child: Container(
                             height: 80,
                             width: 80,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.all(Radius.circular(100)),
                                 image: DecorationImage(image: AssetImage('assets/p.jpg'))
                             ),
                           ),
                         ),
                         Container(
                           margin: EdgeInsets.only(top: 70,left: 137),
                           height:30,
                           width: 30,
                           decoration: BoxDecoration(
                               color: Colors.white,
                               shape: BoxShape.circle
                           ),
                           child: InkWell(
                               onTap: (){
                                 showModalBottomSheet(
                                     context: context,
                                     shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.vertical(
                                         top: Radius.circular(15),
                                         bottom: Radius.circular(15)
                                       ),
                                     ),
                                     builder: (context){
                                       return ProfilePicChoice();
                                     }
                                 );                                 },
                               child: Icon(Icons.camera_alt_outlined, color: blue, size: 20,)),
                         ),
                       ],
                     ),

                     SizedBox(height: 8,),
                     Text('Clara Albert',
                       style: TextStyle(
                           fontSize: 20,
                           color: Colors.white,
                           height: 1.0
                       ),),
                     Text('ClaraAlbert@gmail.com',
                       style: TextStyle(
                           fontSize: 16,
                           color: Colors.white,
                           height: 1.0
                       ),),
                   ],
                 ),
               ),
             ),
              SizedBox(height: 20,),
             Column(
               children: [
                 ListTile(
                   leading:Icon(Icons.person, color: blue,) ,
                   title: Text(
                     'Username', style: TextStyle(fontSize: 14, ),
                   ),
                   subtitle: Text(
                     'Clara Albert', style: TextStyle(fontSize: 17,),
                   ),
                   trailing: InkWell(
                       onTap: (){},
                       child: Icon(Icons.edit, color: blue,)),
                 ),
                 ListTile(
                   leading:Icon(Icons.phone_android, color: blue,) ,
                   title: Text(
                     'Mobile Number', style: TextStyle(fontSize: 14, ),
                   ),
                   subtitle: Text(
                     '03XZ-YYYYYYY', style: TextStyle(fontSize: 17,),
                   ),
                   trailing: InkWell(
                       onTap: (){},
                       child: Icon(Icons.edit, color: blue,)),
                 ),
                 ListTile(
                   leading:Icon(Icons.email_outlined, color: blue,) ,
                   title: Text(
                     'Email Address', style: TextStyle(fontSize: 14, ),
                   ),
                   subtitle: Text(
                     'ClaraAlbert@gmail.com', style: TextStyle(fontSize: 17,),
                   ),
                   trailing: InkWell(
                       onTap: (){},
                       child: Icon(Icons.edit, color: blue,)),
                 ),
                 ListTile(
                   leading:Icon(Icons.location_on, color: blue,) ,
                   title: Text(
                     'Location', style: TextStyle(fontSize: 14, ),
                   ),
                   subtitle: Text(
                     'Islamabad', style: TextStyle(fontSize: 17,),
                   ),
                   trailing: InkWell(
                       onTap: (){},
                       child: Icon(Icons.edit, color: blue,)),
                 ),
                 ListTile(
                   leading:Icon(Icons.settings, color: blue,) ,
                   title: Text(
                     'Settings', style: TextStyle(fontSize: 14, ),
                   ),
                   trailing: InkWell(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
                       },
                       child: Icon(Icons.edit, color: blue,)),
                 ),
               ],
             ),
           ],
         ),
    );
  }
}
