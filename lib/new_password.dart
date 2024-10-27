import 'package:bookstore/screens/login-screen.dart';
import 'package:flutter/material.dart';

import 'commons/colors.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool _isObscured = false;
  bool _isConfirmObscured = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Password'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.only(right: 180),
            child: Text('Enter new password'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: _passwordController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off,)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  hintText: 'At least 8 digits',
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(28)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28)
                  )
              ),
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(right: 200),
            child: Text('Confirm Paaword'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: _isConfirmObscured,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: (){
                          setState(() {
                            _isConfirmObscured = !_isConfirmObscured;
                          });
                      },
                      icon: Icon(_isConfirmObscured ? Icons.visibility : Icons.visibility_off,)),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(28)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(28)
                  )
              ),
            ),
          ),
          SizedBox(height: 50,),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            },
            child: Container(
              height: 55,
              width: 310,
              decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(28), left: Radius.circular(28))
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('Confirm',
                  style: TextStyle(color: blue,fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
