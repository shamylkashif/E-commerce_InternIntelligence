import 'package:bookstore/custom_tab_control.dart';
import 'package:bookstore/screens/my-profile.dart';
import 'package:bookstore/screens/sell.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'about-us.dart';
import 'logout.dart';
import 'our-books.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  int _selectedIndex = 0;
  late TabController _tabController;
  final List book = [
    {'imagePath': 'assets/slider/A million.webp',},
    {'imagePath': 'assets/slider/Harry.jpeg',},
    {'imagePath': 'assets/slider/The design.png',}
  ];

  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync:this);}

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

    });

    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage() ));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfile()));

        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> OurBooks() ));

        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SellWithUS() ));

        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs() ));

        break;
      case 5:
        Navigator.push(context, MaterialPageRoute(builder: (context)=> LogOut() ));

        break;

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 10,right: 10),
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
          Padding(
            padding: const EdgeInsets.only(top: 230),
            child: Expanded(child: CustomTabBar()),
          ),


        ],
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
                  accountName: Text('Clara Albert', style: TextStyle(color: Colors.white)),
                  accountEmail: Text('clara21@gmail.com', style: TextStyle(color: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/pp.png'), // Replace with your profile image asset
                  ),
                ),
                _buildDrawerItem(Icons.home, "Home", 0),
                _buildDrawerItem(Icons.person, "Profile", 1),
                _buildDrawerItem(Icons.book, "Our Books", 2),
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
      leading: Icon(icon,
          color: _selectedIndex == index ? Colors.yellow[700] : Colors.yellow[700]),
      title: Text(
        title,
        style: TextStyle(
            color: _selectedIndex == index ? Colors.black : Colors.black),
      ),
      //tileColor: _selectedIndex == index ? Colors.yellow : Colors.transparent,
      onTap: () {
        Navigator.pop(context);
        _onItemTapped(index);
      },
    );
  }
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


class DrawerClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.8,0);
    path.quadraticBezierTo(
      size.width ,
      size.height ,
      size.width*0.01,
      size.height* 1,
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
