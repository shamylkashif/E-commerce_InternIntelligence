import 'package:bookstore/new_password.dart';
import 'package:bookstore/screens/signup-screen.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'commons/colors.dart';

class PasswordVerification extends StatefulWidget {
  final String email;

  const PasswordVerification({super.key, required this.email});

  @override
  State<PasswordVerification> createState() => _PasswordVerificationState();
}

class _PasswordVerificationState extends State<PasswordVerification> {
  final EmailAuth emailAuth = EmailAuth(sessionName: "Your App Session");
  final TextEditingController otpController = TextEditingController();

  // Method to verify OTP
  Future<void> verifyOtp(BuildContext context) async {
    String enteredOtp = otpController.text.trim();
    bool isVerified = emailAuth.validateOtp(
      recipientMail: widget.email,
      userOtp: enteredOtp,
    );

    if (isVerified) {
      // Navigate to NewPassword screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPassword()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_circle_left_outlined),
        ),
        title: Text('Verification'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text('Enter verification code'),
            SizedBox(height: 30),
            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  height: 50,
                  child: TextFormField(
                    controller: otpController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 15),
            RichText(
              text: TextSpan(
                text: "If you didn't receive a code, ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "Resend",
                    style: TextStyle(color: Colors.red),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      // Logic to resend OTP
                      emailAuth.sendOtp(recipientMail: widget.email);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                verifyOtp(context); // Call the OTP verification method
              },
              child: Container(
                height: 55,
                width: 320,
                decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(28),
                    left: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'Send',
                    style: TextStyle(color: blue, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Additional UI for Google/Facebook sign-in or account creation
            SizedBox(height: 70),
            Text('or', style: TextStyle(fontSize: 18)),

            SizedBox(height: 70),
            Text("Don't have an Account?"),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
              },
              child: Container(
                height: 55,
                width: 320,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(28),
                    left: Radius.circular(28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: blue, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
