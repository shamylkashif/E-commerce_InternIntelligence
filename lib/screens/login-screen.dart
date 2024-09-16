import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/home-pg.dart';
import 'package:bookstore/screens/signup-screen.dart';
import 'package:flutter/material.dart';
import '../Models/user_model.dart';
import '../Repository/user_repo.dart';
import '../forgotpassword.dart';
import '../loaders.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _usersRepository = UserRepository();
  final FirestoreController _users = FirestoreController();

  bool _isPasswordVisible = false; // For show/hide password

  // Function to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<bool> isUsers(String email) async {
    try {
      List<Users> fetchedUsers = await _usersRepository.getAllUsers();
      if (fetchedUsers.isNotEmpty) {
        bool isUsers = fetchedUsers.any((user) => user.email == email);
        return isUsers;
      } else {
        return false;
      }
    } catch (error) {
      print('Error fetching users: $error');
      return false;
    }
  }

  // Sign-in function
  void _signIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text;
      String password = _passwordController.text;

      isUsers(email).then((isUsers) {
        if (isUsers) {
          _users.signInWithFirebaseAuth(email, password).then((success) {
            if (success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              SnackbarHelper.show(context, 'Successfully Logged In.', backgroundColor: Colors.green);
            } else {
              SnackbarHelper.show(context, 'Invalid email or password. Please try again.', backgroundColor: Colors.red);
            }
          }).catchError((error) {
            SnackbarHelper.show(context, 'An error occurred during sign-in. Please try again.', backgroundColor: Colors.red);
          });
        } else {
          SnackbarHelper.show(context, 'Email is not registered.', backgroundColor: Colors.red);
        }
      }).catchError((error) {
        SnackbarHelper.show(context, 'An error occurred while checking the email.', backgroundColor: Colors.red);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                height: 150,
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
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    // Email Field
                    Container(
                      width: 400,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: blue),
                          suffixIcon: const Icon(Icons.person_2, color: blue),
                        ),
                      ),
                    ),
                    // Password Field with show/hide functionality
                    Container(
                      width: 400,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible, // Show/hide password
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: blue),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: blue,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Login Button
            Padding(
              padding: const EdgeInsets.only(top: 415, left: 116),
              child: GestureDetector(
                onTap: () {
                  _signIn(context);
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
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: blue,
                    ),
                  ),
                ),
              ),
            ),
            // Forgot Password
            Padding(
              padding: const EdgeInsets.only(top: 465, left: 125),
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
            // Signup Navigation
            Padding(
              padding: const EdgeInsets.only(top: 490, left: 95),
              child: Row(
                children: [
                  const Text(
                    'Do not have an account?',
                    style: TextStyle(fontSize: 13, color: blue),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 15,
                        color: blue,
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
    );
  }
}
