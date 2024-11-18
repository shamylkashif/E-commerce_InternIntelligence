import 'dart:ui';

import 'package:bookstore/Authentication/signup-screen.dart';
import 'package:bookstore/Dashboards/admin_dhashboard.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Dashboards/home-pg.dart';
import '../loaders.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isPasswordVisible = false;
  bool isLoading = false;
  String? selectedRole;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Show bottom sheet automatically when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showRoleSelectionBottomSheet();
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<bool> _isUserInCollection(String collection, String email) async {
    var snapshot = await _firestore
        .collection(collection)
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> _saveEmailAndRoleToSharedPreferences(String email, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setString('userRole', role);  // Save the role as well
  }

  // Code for Role Selection in Bottom Sheet
  void _showRoleSelectionBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0d3251).withOpacity(0.8),
                  Color(0xFF0d3251).withOpacity(0.2)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Select login role',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                Divider(
                  color: Colors.grey[600],
                ),
                SizedBox(
                  height: 4,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedRole = 'admin';
                      _controller.forward(); // Trigger the animation here
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Image(
                      image: AssetImage(
                        'assets/slider/Adminlogo.webp',
                      ),
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Admin',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                // SizedBox(height: 4,),
                Divider(
                  color: Colors.grey[600],
                ),
                //SizedBox(height: 4,),
                InkWell(
                  onTap: (){
                    setState(() {
                      selectedRole = 'UsersBookStore';
                      _controller.forward(); // Trigger the animation here
                    });
                    Navigator.pop(context);

                  },
                  child: ListTile(
                    leading: Image(
                      image: AssetImage(
                        'assets/slider/user.webp',
                      ),
                      height: 30,
                      width: 30,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Regular user',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
                //SizedBox(height: 4,),
                Divider(
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Updated _checkCredentials method
  Future<bool> _checkCredentials(
      String email, String password, String role)
  async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userEmail = userCredential.user!.email!;

      // Check role and navigate accordingly
      if (role == 'admin' && await _isUserInCollection('admin', userEmail)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        return true;
      } else if (role == 'UsersBookStore' &&
          await _isUserInCollection('UsersBookStore', userEmail)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error during login: ${e.toString()}');
      return false;
    }
  }

  void _signIn(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      if (selectedRole == null) {
        SnackbarHelper.show(context, 'Please select a role.',
            backgroundColor: Colors.red);
        setState(() {
          isLoading = false;
        });
        return;
      }

      try {
        bool success = await _checkCredentials(email, password, selectedRole!);
        if (success) {
          _saveEmailAndRoleToSharedPreferences(email, selectedRole!);  // Save both email and role
          SnackbarHelper.show(context, 'Successfully Logged In.',
              backgroundColor: Colors.green);
        } else {
          SnackbarHelper.show(
              context, 'No matching user found. Please try again.',
              backgroundColor: Colors.red);
        }
      } catch (error) {
        SnackbarHelper.show(
            context, 'An error occurred during sign-in. Please try again.',
            backgroundColor: Colors.red);
      } finally {
        setState(() {
          isLoading = false; // Set loading state to false
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backgrdImg (2).png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width, 80.0),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 60),
                    child:
                        Image.asset('assets/Logo.png', height: 240, width: 240),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 230,),
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    Container(
                      height: 190,
                      width: 275,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            // Email Field
                            Container(
                              width: 400,
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: 'Email',
                                  labelStyle:
                                      const TextStyle(color: blue),
                                  suffixIcon: const Icon(Icons.person_2,
                                      color: blue),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            // Password Field
                            Container(
                              width: 400,
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 15,),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: 'Password',
                                  labelStyle:
                                      const TextStyle(color: blue),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: blue,
                                    ),
                                    onPressed: _togglePasswordVisibility,
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
                            // Login Button
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () => _signIn(context),
                      child: Container(
                        height: 40,
                        width: 130,
                        decoration: BoxDecoration(
                          color: yellow,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                color: blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    // Forgot Password
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: blue, fontSize: 15),
                        ),
                      ),
                    ),

                    SizedBox(height: 8,),
                    // Signup Navigation
                    Padding(
                      padding: const EdgeInsets.only(left: 85),
                      child: Row(
                        children: [
                           Text(
                            'Do not have an account?',
                            style: TextStyle(
                                fontSize: 13,
                                color: selectedRole == 'admin' ? Colors.white : blue),
                          ),
                          const SizedBox(width: 3),
                          GestureDetector(
                            onTap: selectedRole == 'admin'
                                ? null
                                :() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignupScreen()),
                              );
                            },
                            child: Text(
                              'Signup',
                              style: TextStyle(
                                fontSize: 15,
                                color: selectedRole == 'admin' ? Colors.white : blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Loading Indicator
            isLoading
                ? BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                 child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.grey,),
                  ),
                ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
