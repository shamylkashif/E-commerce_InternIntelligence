import 'package:flutter/material.dart';

import '../commons/colors.dart';


class ManageBooks extends StatefulWidget {
  const ManageBooks({super.key});

  @override
  State<ManageBooks> createState() => _ManageBooksState();
}

class _ManageBooksState extends State<ManageBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);} ,
            icon: Icon(Icons.arrow_circle_left_outlined,color: blue,)),
      ),
    );
  }
}
