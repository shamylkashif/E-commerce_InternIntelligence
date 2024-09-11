import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meddlabb/sign_up/sign_up_1.dart';
import 'package:meddlabb/verificationscreens/forget_password.dart';
import 'Model/Patient_Model.dart';
import 'Repositories/Patient_Repo.dart';
import 'Widgets/loaders.dart';
import 'home_screen/dashbord.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PatientRepository _patientRepository = PatientRepository();
  final FirestoreController _patient = FirestoreController();
  bool animate = false;

  Future<bool> isPatient(String email) async {
    try {
      List<Patient> fetchedPatients = await _patientRepository.getAllPatients();

      if (fetchedPatients.isNotEmpty) {
        // Check if any patient has the same email
        bool isPatient = fetchedPatients.any((patient) => patient.email == email);
        return isPatient;
      } else {
        return false; // No patients found
      }
    } catch (error) {
      print('Error fetching patients: $error');
      return false;
    }
  }

  void _signIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;

      isPatient(email).then((isPatient) {
        if (isPatient) {
          _patient.signInWithFirebaseAuth(email, password).then((success) {
            if (success) {
              // Navigate to the home screen on successful sign-in
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              SnackbarHelper.show(context, 'Successfully Logged In.', backgroundColor: Colors.green);
            } else {
              SnackbarHelper.show(context, 'Invalid email or password. Please try again.', backgroundColor: Colors.red);
            }
          }).catchError((error) {
            SnackbarHelper.show(context, 'An error occurred during sign-in. Please try again.', backgroundColor: Colors.red);
          });
        } else {
          SnackbarHelper.show(context, 'Email is not registered as a patient', backgroundColor: Colors.red);
        }
      }).catchError((error) {
        SnackbarHelper.show(context, 'An error occurred while checking the email.', backgroundColor: Colors.red);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bacgroundlogin.jpg"),
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2400),
            top: animate ? 230 : 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 380,
                    height: 450,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0d3251).withOpacity(0.8),
                          Color(0xFF0d3251).withOpacity(0.2)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: const TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.red[900],
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.red[900],
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                _signIn(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "LogIn",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SignupScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "SIGN UP!",
                                      style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyForgetScreen()),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(top: 80, left: 200),
                              child: Text(
                                "Forget password?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2400),
            top: 50,
            left: 100,
            right: animate ? 0 : -50,
            child: const Image(
              image: AssetImage("assets/2ndone.png"),
              height: 300,
              width: 300,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1600),
            top: 70,
            left: animate ? 20 : -40,
            right: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[900],
                  ),
                ),
                const Text(
                  "Your health is just a login away...",
                  style: TextStyle(
                    color: Color(0xFF0d3251),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(microseconds: 500));
    setState(() => animate = true);
    await Future.delayed(const Duration(milliseconds: 5000));
  }
}
