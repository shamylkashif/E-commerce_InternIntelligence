
import 'package:bookstore/book_desp.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/custom_tab_control.dart';
import 'package:bookstore/read_review.dart';
import 'package:bookstore/screens/about-us.dart';
import 'package:bookstore/setting.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ask_ai.dart';
import '../post_ad.dart';
import '../search_pg.dart';
import '../my_profile.dart';
import 'chat_screen.dart';
import 'login-screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 2;

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
      DocumentSnapshot userDoc = await _firestore.collection('UsersBookStore').doc(uid).get();

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
    SearchPage(),
    AskAI(),
    HomePageContent(),
    PostAD(),
    MyProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPreviewScreen()));
              },
              icon: Icon(Icons.chat, color: blue,)),
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MySettings()));
              },
              icon: Icon(Icons.settings, color: blue,)),
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
          Icon(Icons.search, size: 24, color: blue),
          Icon(Icons.android, size: 24, color: blue),
          Icon(Icons.home, size: 24, color: blue),
          Icon(Icons.add, size: 24, color: blue),
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
                      : AssetImage('assets/p.jpg') as ImageProvider,
                  radius: 40,
                ),
              ),
              _buildDrawerItem(Icons.home, "Home", 0),
              _buildDrawerItem(Icons.person, "Profile", 1),
              _buildDrawerItem(Icons.reviews, "Read Review", 2),
              _buildDrawerItem(Icons.info, "About Us", 3),
              _buildDrawerItem(Icons.settings, "Settings", 4),
              _buildDrawerItem(Icons.logout, "Logout", 5),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onLogout(BuildContext context) async {
    // Clear email from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');  // This will clear the stored email

    // Redirect the user to the login screen
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),);
  }
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
            _navigateToPage(context, HomePage());
            break;
          case 1:
            _navigateToPage(context, MyProfile());
            break;
          case 2:
            _navigateToPage(context, ReadReview());
            break;
          case 3:
            _navigateToPage(context, AboutUs());
            break;
          case 4:
            _navigateToPage(context, MySettings());
            break;
          case 5:
            onLogout(context);  // Call your logout function
            break;
        }
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

}






class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  //PopularBooks List
  List<Map<String, dynamic>> pBook = [];

  @override
  void initState(){
    super.initState();
    _fetchPopularBooks();
  }

  //Fetch data from firestore
  Future<void> _fetchPopularBooks() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AllBooks').get();
      List<Map<String,dynamic>> books = [];
      for(var doc in snapshot.docs) {
        books.add({
          'imageUrl' : doc['imageUrl'],
          'title' : doc['title'],
          'author' : doc['author'],
        });
      }
      setState(() {
        pBook = books;
      });
    } catch (e) {
      print('Error Fetching Book\'s data:$e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 720, // Set your desired height here
          child: Stack(
            children: [
              // Slider
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
                child: Column(
                  children: [
                    CarouselSlider(
                      items: [
                        _buildImage('assets/s1.jpg'),
                        _buildImage('assets/s2.jpg'),
                        _buildImage('assets/s3.jpg'),
                      ],
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: true,
                      ),
                    ),
                  ],
                ),
              ),
              // TabBar
              Padding(
                padding: const EdgeInsets.only(top: 190),
                child: CustomTabBar(),
              ),
              // PopularBooks
              Padding(
                padding: const EdgeInsets.only(top: 565, left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Popular Books',
                      style: TextStyle(
                        fontSize: 20,
                        color: blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: pBook.map((pBookItem) {
                          return Container(
                            height: 100,
                            width: 220,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.yellow.shade600),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      pBookItem['imageUrl']??"",
                                      height: 90,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(left: 17, top: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pBookItem['title']??"",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        pBookItem['author']??"",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow[200],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: blue, size: 17),
                                            SizedBox(width: 4),
                                            Text(
                                              pBookItem['rating'].toString()??"",
                                              style: TextStyle(
                                                color: blue,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookDescription(book: pBookItem,)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 70,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(3),
                                              border: Border.all(color: blue)),
                                          child: Text(
                                            'Buy',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildImage(String imagePath) {
    return ClipRRect(
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        height: 400,
        width: double.infinity,
      ),
    );
  }
}


