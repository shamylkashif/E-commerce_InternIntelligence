import 'package:bookstore/Models/user_model.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Repository/user_repo.dart';
import '../commons/colors.dart';
import '../loaders.dart';
import 'home-pg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void onTapSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        // Collect data from text controllers
        String name = _usernameController.text;
        String email = _emailController.text;
        String password = _passwordController.text;

        // Create a Users object with the necessary fields
        Users user = Users(
          name: name,
          email: email,
          password: password,
          uid: '',  // UID will be assigned after successful FirebaseAuth sign-up
        );

        // Check if the account already exists
        FirestoreController().checkAccountExists(context, email).then((exists) {
          if (exists) {
            // Show error message if the account already exists
            SnackbarHelper.show(context, 'Account already exists.', backgroundColor: Colors.red);
          } else {
            // Sign up the user and save to Firestore
            FirestoreController().signUp(context, user).then((success) {
              if (success) {
                // Show success message
                SnackbarHelper.show(context, 'Your account has been created successfully! Please continue.', backgroundColor: Colors.green);

                // Navigate to HomeScreen after successful signup
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                // Show error message if signup fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sign up failed. Please try again.')),
                );
              }
            });
          }
        });
      } catch (e) {
        // Show an error message if an exception occurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
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
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width, 80.0),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 60),
                    child: Image.asset('assets/LogoWot.png', height: 240, width: 240),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250, left: 47),
              child: Container(
                height: 270,
                width: 265,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4, 4), // Shadow position
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        _buildTextField(
                          controller: _usernameController,
                          labelText: 'Enter UserName',
                          icon: Icons.person_2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          controller: _emailController,
                          labelText: 'Enter Your Email',
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            return null;
                          },
                        ),
                        _buildPasswordField(
                          controller: _passwordController,
                          labelText: 'Password',
                          isVisible: _isPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        _buildPasswordField(
                          controller: _confirmPasswordController,
                          labelText: 'Confirm Password',
                          isVisible: _isConfirmPasswordVisible,
                          onToggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 535, left: 116),
              child: GestureDetector(
                onTap: () {
                  onTapSignUp(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: yellow,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1,
                        offset: Offset(2, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: const Text(
                    "Signup",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return Container(
      width: 400,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: blue),
          suffixIcon: Icon(icon, color: blue),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    required String? Function(String?)? validator,
  }) {
    return Container(
      width: 400,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: blue),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: blue,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
