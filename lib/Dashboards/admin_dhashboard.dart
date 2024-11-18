import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Admin-Screens/admin_profile.dart';
import '../Admin-Screens/admin_read_review.dart';
import '../Authentication/user-login-screen.dart';
import '../Description_Review/read_review.dart';
import '../commons/colors.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 1;

  String? _userName;
  String? _userEmail;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch current user's data from Firestore
  void _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;

      // Fetch data from Firestore collection UsersBookStore
      DocumentSnapshot userDoc = await _firestore.collection('admin').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'];  // Assuming 'name' field exists in Firestore
          _userEmail = userDoc['email'];  // Assuming 'email' field exists in Firestore
          _profileImageUrl = userDoc['profileImage'];  // Assuming 'profileImage' field exists in Firestore
        });
      }
    }
  }

  final List<Widget> _pages = [
    AdminReadReview(),
    HomeScreen(),
    AdminProfile(
    ),
  ];
  //For bottomSheet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  //Log out
  Future<void> onLogout(BuildContext context) async {
    // Clear email from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');  // This will clear the stored email

    // Redirect the user to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),);
  }

  //Drawer
  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.yellow[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        switch (index) {
          case 0:
            _navigateToPage(context, HomeScreen());
            break;
          case 1:
            _navigateToPage(context, AdminProfile());
            break;
          case 2:
            _navigateToPage(context, ReadReview());
            break;
          case 3:
            onLogout(context);  // Call your logout function
            break;
        }
      },
    );
  }

  //For Drawer
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: yellow,
        leading: IconButton(
          icon: Icon(Icons.menu, color: blue,), // Menu icon on the left
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),

      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: yellow,
        color: yellow,
        animationDuration: Duration(milliseconds: 300),
        height: 50,
        items: [
          Icon(Icons.reviews, size: 24, color: blue),
          Icon(Icons.home, size: 24, color: blue),
          Icon(Icons.person, size: 24, color: blue),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: yellow
                ),
                accountName: Text(
                  _userName ?? 'Clara Albert',
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  _userEmail ?? 'clara21@gmail.com',
                  style: TextStyle(color: Colors.black),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : AssetImage('assets/defaultImage.jpg') as ImageProvider,
                  radius: 40,
                ),
              ),
              _buildDrawerItem(Icons.home, "Home", 0),
              _buildDrawerItem(Icons.person, "Profile", 1),
              _buildDrawerItem(Icons.reviews, "Read Review", 2),
              _buildDrawerItem(Icons.logout, "Logout", 3),
            ],
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

      ),
    );
  }
}

