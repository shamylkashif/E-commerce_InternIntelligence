import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/Settings/complain.dart';
import 'package:flutter/material.dart';

import 'delete_acc.dart';

class MySettings extends StatefulWidget {
  const MySettings({super.key});

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/setings.jpg'),
                  fit: BoxFit.cover
              ),
            ),
            child: Container(
                 color: Colors.black.withOpacity(0.4),
            ),
          ),
          Column(
            children: [
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40,right: 260),
                    child: Icon(Icons.arrow_circle_left_outlined, color: Colors.white,),
                  )),
              SizedBox(height: 25,),
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
                         ),],
          ),
        ],
      ),
    );
  }
}
