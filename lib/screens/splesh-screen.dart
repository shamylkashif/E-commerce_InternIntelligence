import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookstore/Dashboards/home-pg.dart';
import 'package:bookstore/Authentication/user-login-screen.dart';
import 'package:flutter/material.dart';

import '../Dashboards/admin_dhashboard.dart';

class SpleshScreen extends StatefulWidget {
  const SpleshScreen({super.key});

  @override
  State<SpleshScreen> createState() => _SpleshScreenState();
}

class _SpleshScreenState extends State<SpleshScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail'); // Fetch stored email
    String? userRole = prefs.getString('userRole'); // Fetch stored role

    await Future.delayed(const Duration(seconds: 5));

    if (userEmail != null) {
      // Check the user's role and navigate to the corresponding dashboard
      if (userRole == 'admin') {
        // Navigate to the admin dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()), // Replace with the admin dashboard
        );
      } else if (userRole == 'UsersBookStore') {
        // Navigate to the user dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // Replace with the user dashboard
        );
      }
    } else {
      // If the user is not logged in, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/splash_background.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 55, top: 120),
            child: Image.asset(
              'assets/Logo.png',
              height: 250,
              width: 250,
            ),
          ),
        ],
      ),
    );
  }
}
