import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/complain.dart';
import 'package:flutter/material.dart';

import 'delete_acc.dart';
import 'notifications.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
      body: Column(
        children: [
          SizedBox(height: 10,),
           Container(
             margin: EdgeInsets.only(top: 20,left: 30,),
             height: 80,
             width: 300,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 color: Colors.white,
               boxShadow: [
                 BoxShadow(
                   color: Colors.grey,
                   offset: Offset(0, 2),
                   blurRadius: 2,
                 )
               ]
             ),
             child: InkWell(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>Complaint()));
               },
               child: ListTile(
                 title: Text('Complain', style: TextStyle(fontSize: 20,color: blue),),
                 subtitle: Text('Write any complain', style: TextStyle(fontSize: 14,color: Colors.grey),),
                 trailing: Icon(Icons.double_arrow, color: blue,),
               ),
             ),
           ),
           Container(
            margin: EdgeInsets.only(top: 30,left: 30,),
            height: 80,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  )
                ]
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DeleteAccount()));

              },
              child: ListTile(
                title: Text('Delete Account', style: TextStyle(fontSize: 20,color: blue),),
                subtitle: Text('Take action on account', style: TextStyle(fontSize: 14,color: Colors.grey),),
                trailing: Icon(Icons.double_arrow, color: blue,),
              ),
            ),
                     ),
           Container(
            margin: EdgeInsets.only(top: 30,left: 30,),
            height: 80,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  )
                ]
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));
              },
              child: ListTile(
                title: Text('Notifications', style: TextStyle(fontSize: 20,color: blue),),
                subtitle: Text('Recommendations', style: TextStyle(fontSize: 14,color: Colors.grey),),
                trailing: Icon(Icons.double_arrow, color: blue,),
              ),
            ),
                     ),
           Container(
            margin: EdgeInsets.only(top: 30,left: 30,),
            height: 80,
            width: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, 2),
                    blurRadius: 2,
                  )
                ]
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Notifications()));
              },
              child: ListTile(
                title: Text('Select Mode', style: TextStyle(fontSize: 20,color: blue),),
                subtitle: Text('Light/Dark', style: TextStyle(fontSize: 14,color: Colors.grey),),
                trailing: Icon(Icons.double_arrow, color: blue,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
