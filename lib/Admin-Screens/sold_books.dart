import 'package:flutter/material.dart';

import '../commons/colors.dart';

class SoldBooks extends StatefulWidget {
  const SoldBooks({super.key});

  @override
  State<SoldBooks> createState() => _SoldBooksState();
}

class _SoldBooksState extends State<SoldBooks> {
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
