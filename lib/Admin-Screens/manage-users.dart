import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';


class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);} , 
            icon: Icon(Icons.arrow_circle_left_outlined,color: blue,)),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
