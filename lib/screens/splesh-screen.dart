import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:flutter/material.dart';


class SpleshScreen extends StatefulWidget {
  const SpleshScreen({super.key});

  @override
  State<SpleshScreen> createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moveToNextScreen(context: context);
  }
  Future<void> moveToNextScreen({required BuildContext context}) async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
         children:[ Image.asset('assets/The BookStore (1).png',
           height: double.infinity, width: double.infinity, fit: BoxFit.cover,),

           Padding(
               padding: EdgeInsets.only(left: 55,top: 120),
             child:   Image.asset('assets/LogoWot.png',
               height: 250, width: 250,),
           )
                  ]
       ),

    );
  }
}
