import 'package:bookstore/book_desp.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/custom_tab_control.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../ask_ai.dart';
import '../post_ad.dart';
import '../search_pg.dart';
import '../my_account.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selectedIndex = 2;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        iconTheme: IconThemeData(color: blue),
        elevation: 0,
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
      drawer: ClipPath(
        clipper: DrawerClipper(),
        child: Drawer(
          child: Container(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  accountName: Text('Clara Albert',
                      style: TextStyle(color: Colors.white)),
                  accountEmail: Text('clara21@gmail.com',
                      style: TextStyle(color: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/pp.png'),
                  ),
                ),
                _buildDrawerItem(Icons.person, "Profile", 0),
                _buildDrawerItem(Icons.book, "Our Books", 1),
                _buildDrawerItem(Icons.home, "Home", 2),
                _buildDrawerItem(Icons.monetization_on, "Sell With Us", 3),
                _buildDrawerItem(Icons.info, "About Us", 4),
                _buildDrawerItem(Icons.logout, "Logout", 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index
            ? Colors.yellow[700]
            : Colors.yellow[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.black : Colors.black,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        _onItemTapped(index);
      },
    );
  }
}

class HomePageContent extends StatelessWidget {
  final List book = [
    {
      'imagePath': 'assets/slider/A million.webp',
    },
    {
      'imagePath': 'assets/slider/Harry.jpeg',
    },
    {
      'imagePath': 'assets/slider/The design.png',
    },
  ];

  final List<Map<String, dynamic>> pBook = [
    {
      'image': 'assets/slider/memory.jpeg',
      'rating': 4.1,
      'title': 'Memory',
      'author': 'Debbie Berny',
    },
    {
      'image': 'assets/slider/download.jpeg',
      'rating': 4.5,
      'title': 'Harry Potter',
      'author': 'J.K. Rowling',
    },
    {
      'image': 'assets/slider/Harry.jpeg',
      'rating': 4.7,
      'title': 'Soul',
      'author': 'Olivia Wilson',
    },
  ];

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
                          final imagePath =
                              pBookItem['image'] ?? 'assets/slider/default_image.jpeg';
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
                                    child: Image.asset(
                                      imagePath,
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
                                        pBookItem['title'],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        pBookItem['author'],
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
                                              pBookItem['rating'].toString(),
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
                                                      BookDescription()));
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

// DrawerDesign
class DrawerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.8, 0);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width * 0.01,
      size.height * 1,
    );

    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}