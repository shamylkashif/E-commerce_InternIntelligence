import 'package:bookstore/Admin-Screens/AdminAds/admin_postad.dart';
import 'package:bookstore/Admin-Screens/AdminAds/admin_posts.dart';
import 'package:bookstore/Admin-Screens/AdminChat/chat_list.dart';
import 'package:bookstore/Admin-Screens/manage-users.dart';
import 'package:bookstore/Admin-Screens/manage_books.dart';
import 'package:bookstore/Admin-Screens/sold_books.dart';
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
    AdminProfile(),
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
            _navigateToPage(context, AdminPostAD());
            break;
          case 4:
            _navigateToPage(context, AdminPostsPage());
            break;
          case 5:
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
        actions: [
          IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminChatList()));},
              icon: Icon(Icons.chat, color: blue,))
        ],

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
              _buildDrawerItem(Icons.add, "Post AD", 3),
              _buildDrawerItem(Icons.post_add, "Admin Posts", 4),
              _buildDrawerItem(Icons.logout, "Logout", 5),
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
  String? name;
  String? profileImage;
  int totalUsers = 0;
  int totalBooks = 0;
  int soldBooks = 0;

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
    _fetchCounts();
  }

  // Fetch admin's name and profileImage by querying Firestore using the current user's UID
  void _fetchAdminData() async {
    try {
      // Get the current logged-in user UID from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Query the `admin` collection where `adminId` field matches the user's UID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('admin')
            .where('adminID', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Assume only one document matches
          var adminData = querySnapshot.docs.first.data() as Map<String, dynamic>;

          setState(() {
            name = adminData['name'] ?? 'No Name';
            profileImage = adminData['profileImage'] ?? '';
          });
        } else {
          print("No admin document found with the given adminId.");
        }
      }
    } catch (e) {
      print("Error fetching admin data: $e");

    }
  }

  //Fetch Counts
  Future<void> _fetchCounts() async {
    try{
      //Get document count from three collections
      var usersSnapshot = await FirebaseFirestore.instance.collection('UsersBookStore').get();
      var booksSnapshot = await FirebaseFirestore.instance.collection('AllBooks').get();
      var soldSnapshot = await FirebaseFirestore.instance.collection('soldBooks').get();

      setState(() {
        totalUsers = usersSnapshot.docs.length;
        totalBooks = booksSnapshot.docs.length;
        soldBooks = soldSnapshot.docs.length;
      });

    }catch(e) {
      print('Error fetching counts: $e');

    }
  }




  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [primeryColor, primeryColor2])),
      child: Container(
        padding: EdgeInsets.only(top: size.height * 0.03),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [

              //Admin name and profile
              Positioned(
                top: size.height * 0.00,
                left: size.width * 0.03,
                right: size.width * 0.03,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? "No Name",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: profileImage != null && profileImage!.isNotEmpty
                          ? NetworkImage(profileImage!)
                          : null,
                    )
                  ],
                ),
              ),

              //GridView
              Positioned(
                  bottom: 0,
                  top:  size.height * 0.30,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      )
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(
                          top: size.height *0.05,
                          left: size.width *0.03,
                          right: size.width*0.03
                        ),
                      child: GridView(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageUsers()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50, // Light blue background
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.manage_accounts, size: 40, color: blue), // Replace with your icon/image
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Manage Users",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageBooks()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50, // Light blue background
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.settings, size: 40, color: blue), // Replace with your icon/image
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Manage Books",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SoldBooks()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50, // Light blue background
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.attach_money, size: 40, color: blue), // Replace with your icon/image
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Sold books",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
              

              //Count Containers
              Positioned(
                  top :size.height * 0.13,
                  right :size.width * 0.03,
                  left : size.width * 0.03,
                  child : Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border:
                              Border.all(width: 1, color: blue)),
                          height: size.height * 0.20,
                          width: size.width * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset("assets/group.png", color: yellow,height: 70,width: 70,),
                                Text(
                                  "Total Users",
                                ),
                                Text(
                                  totalUsers.toString(),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border:
                              Border.all(width: 1, color: blue)),
                          height: size.height * 0.20,
                          width: size.width * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/book.png', color: blue,height: 70,width: 70,),
                                Text(
                                  "Total Books",
                                ),
                                Text(
                                  totalBooks.toString(),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border:
                              Border.all(width: 1, color: blue)),
                          height: size.height * 0.20,
                          width: size.width * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/transfer.png', color: Colors.green,height: 70,width: 70,),
                                Text(
                                  "Sold Books",
                                ),
                                Text(
                                  soldBooks.toString(),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),

            ],
          ),
        ),
      ),
    );
  }
}

