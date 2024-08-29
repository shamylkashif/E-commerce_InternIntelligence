import 'package:bookstore/book_desp.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/custom_tab_control.dart';
import 'package:bookstore/screens/my-profile.dart';
import 'package:bookstore/screens/sell.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../ask_ai.dart';
import '../post_ad.dart';
import '../search_pg.dart';
import '../my_account.dart';
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
  int _selectIndex = 0;

  final List<Widget> _pages = [
    HomePage(),  // Replace with your actual pages
    SearchPage(),
    AskAI(),
    PostAD(),
    MyAccount()
  ];

  late TabController _tabController;
  final List book = [
    {'imagePath': 'assets/slider/A million.webp',},
    {'imagePath': 'assets/slider/Harry.jpeg',},
    {'imagePath': 'assets/slider/The design.png',}
  ];
  final List<Map<String, dynamic>> pBook = [
    {
      'image' : 'assets/slider/memory.jpeg',
      'rating': 4.1,
      'title' : 'Memory',
      'author' : 'Debbie Berny',
    },
    {
      'image' : 'assets/slider/download.jpeg',
      'rating': 4.5,
      'title' : 'Harry Potter',
      'author' : 'J.K. Rowling',
    },
    {
      'image' : 'assets/slider/Harry.jpeg',
      'rating': 4.7,
      'title' : 'Soul',
      'author' : 'Olivia Wilson',
    },
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
      body:
        Stack(
        children: [
          //Slider
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
          //TabBar
          Padding(
            padding: const EdgeInsets.only(top: 210),
            child: Expanded(child: CustomTabBar()),
          ),
          //PopularBooks
          Padding(
            padding: const EdgeInsets.only(top: 560,left: 5,right: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Popular Books',style: TextStyle(fontSize: 20,color: blue,fontWeight: FontWeight.bold),),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: pBook.map((pBookItem) {
                      final imagePath = pBookItem['image'] ?? 'assets/slider/default_image.jpeg';
                      return Container(
                        height: 100,
                        width: 220,
                        margin: EdgeInsets.only(right: 10), // Add spacing between containers
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
                                  imagePath, // Replace with your image for each book
                                  height: 90,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 8), // Add spacing between the image and text
                            Padding(
                              padding: const EdgeInsets.only(left: 17,top: 8),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start horizontally
                                children: [
                                  Text(
                                    pBookItem['title'], // Display the title of the book
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    pBookItem['author'], // Display the author of the book
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: blue, size: 17),
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
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BookDescription()));
                                  },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 70,),
                                      padding: EdgeInsets.symmetric(horizontal: 10,),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: blue )
                                      ),
                                      child: Text('Buy',
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
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: yellow,
        color: yellow,
        animationDuration: Duration(milliseconds: 300),
        items: [
          InkWell(
            onTap: (){
              setState(() {
                _selectIndex = 0;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=>_pages[_selectIndex]));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.home, size: 24, color:blue,),
               // Text("Home", style: TextStyle(color: blue, fontSize: 10)),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _selectIndex = 1;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=>_pages[_selectIndex]));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, size: 24, color: blue,),
               // Text("Search", style: TextStyle(color: blue, fontSize: 10)),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _selectIndex = 2;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=>_pages[_selectIndex]));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.android, size: 24, color: blue,),
                //Text("Ask AI", style: TextStyle(color: blue, fontSize: 10)),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _selectIndex = 3;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=>_pages[_selectIndex]));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 24, color: blue,),
                //Text("Post Ad", style: TextStyle(color: blue, fontSize: 10)),
              ],
            ),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _selectIndex = 4;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context)=>_pages[_selectIndex]));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 24, color: blue,),
               // Text("Settings", style: TextStyle(color: blue, fontSize: 10)),
              ],
            ),
          ),
        ],
        index: _selectIndex,
      ),

    );
  }
  //Drawer
  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon,
          color: _selectedIndex == index ? Colors.yellow[700] : Colors.yellow[700]),
      title: Text(
        title,
        style: TextStyle(
            color: _selectedIndex == index ? Colors.black : Colors.black),
      ),
      onTap: () {
        Navigator.pop(context);
        _onItemTapped(index);
      },
    );
  }
}
  //Slider
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

  //DrawerDesign
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