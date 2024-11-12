import 'package:bookstore/password_verification.dart';
import 'package:bookstore/screens/signup-screen.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final EmailAuth emailAuth = EmailAuth(sessionName: "Your App Session");

  Future<void> sendOtp(BuildContext context) async {
    bool result = await emailAuth.sendOtp(recipientMail: emailController.text.trim());
    if (result) {
      // Navigate to OTP verification screen and pass the email as an argument
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasswordVerification(email: emailController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP. Try again.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_circle_left_outlined,)),
        title: Text('Forgot Password', ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('Enter Email Address registered with this platform', ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    labelText: 'abc@gmail.com',
                    labelStyle: TextStyle(color: Colors.grey[300]),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(28)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(28)
                      )
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Please enter your email';
                  //   }
                  //   // Basic email validation
                  //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  //     return 'Please enter a valid email';
                  //   }
                  //   return null;
                  // },
                ),
              ),
              SizedBox(height: 18,),
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text('Back to Sign in')),
              SizedBox(height: 35,),
              InkWell(
                onTap: ()=> sendOtp(context),
                child: Container(
                  height: 55,
                  width: 310,
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(28), left: Radius.circular(28))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text('Send',
                      style: TextStyle(color: blue,fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70,),
              Text('or', style: TextStyle(fontSize: 18),),

              SizedBox(height: 70,),
              Text('Don\'t have an Account?'),
              SizedBox(height: 15,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupScreen()));
                },
                child: Container(
                  height: 55,
                  width: 310,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.horizontal(right: Radius.circular(28), left: Radius.circular(28))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text('Sign up',
                      style: TextStyle(color: blue,fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
