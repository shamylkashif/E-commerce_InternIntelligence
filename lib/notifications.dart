import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool isSwitch = false;
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_circle_left_outlined, color: blue,)),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20,left: 30,right: 30),
            height: 80,
            width: 320,
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
            child: ListTile(
              title: Text('Recommendations', style: TextStyle(fontSize: 20,color: blue),),
              subtitle: Text('Receive recommendations based on your activity', style: TextStyle(fontSize: 14,color: Colors.grey),),
              trailing: Switch(
                value: isSwitch,
                onChanged: (value){
                  setState(() {
                    isSwitch = value;
                  });
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20,left: 30,right: 30),
            height: 80,
            width: 320,
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
            child: ListTile(
              title: Text('Special Offers', style: TextStyle(fontSize: 20,color: blue),),
              subtitle: Text('Receive updates, offers and more', style: TextStyle(fontSize: 14,color: Colors.grey),),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value){
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
