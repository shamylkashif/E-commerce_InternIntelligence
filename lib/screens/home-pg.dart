import 'package:bookstore/screens/my-profile.dart';
import 'package:bookstore/screens/sell.dart';
import 'package:flutter/material.dart';

import '../commons/colors.dart';
import 'about-us.dart';
import 'logout.dart';
import 'our-books.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
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
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.elliptical(MediaQuery.of(context).size.width,80.0),
              ),
            ),
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
