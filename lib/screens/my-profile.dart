import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/profile_choice.dart';
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
      backgroundColor: backGround,
      appBar: AppBar(
        backgroundColor: backGround,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: blue,)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text('Profile', style: TextStyle(fontSize: 22),),
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      image: DecorationImage(image: AssetImage('assets/p.jpg'))
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 120,left: 157),
                height:50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle
                ),
                child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileChoice()));

                    },
                    child: Icon(Icons.camera_alt_outlined, color: blue, size: 30,)),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
