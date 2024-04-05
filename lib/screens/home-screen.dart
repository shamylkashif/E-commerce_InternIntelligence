import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/books-category/eng-novels.dart';
import 'package:bookstore/screens/books-category/old-books.dart';
import 'package:bookstore/screens/books-category/popular-books.dart';
import 'package:bookstore/screens/books-category/subjects.dart';
import 'package:bookstore/screens/books-category/urdu-novels.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'bottom-bar/MyAds.dart';
import 'bottom-bar/account.dart';
import 'bottom-bar/chats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Chat()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyAds()));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Account()));
        break;
    }
  }



  List list = [
    {
      "title": "Subject",
      "image": "assets/Category/subjectBook.png"
    },
    {
      "title": "English Novels",
      "image": "assets/Category/EngNov.png"
    },
    {
      "title": "Urdu Novel",
      "image": "assets/Category/UrduNov.png"
    },
    {
      "title": "Old Books",
      "image": "assets/Category/OldBooks.png"
    },
    {
      "title": "Popular Books",
      "image": "assets/Category/popular-books.png"
    },

  ];

  List<String> getImages() {
    return [
      'assets/slider/download.jpg',
      'assets/slider/download.png',
      'assets/slider/download (1).jpg',
      'assets/slider/download (2).jpg',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      body: Column(
        children: [
          SizedBox(height: 35),
         const  Padding(
            padding:  EdgeInsets.only(top: 30, left: 10, right: 10),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(height: 30),
          CarouselSlider(
            options: CarouselOptions(
              height: 200,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 1.0,
            ),
            items: getImages().map((String imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 35,),

          Container(
              margin: EdgeInsets.only(top: 10),
              height: 300,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EnglishNovels()));
                        } else if (index == 1) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => OldBooks()));
                        } else if (index == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Popularbooks()));
                        } else if (index == 3) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Subjects()));
                        } else if (index == 4) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UrduNovels()));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFE6E6FA),
                              radius:48,
                              child: Image.asset(
                                list[index]["image"],
                                height:120,
                                width:120,
                              ),
                            ),
                            Text(
                              list[index]["title"],
                              style: TextStyle(
                                fontSize: 18, color: blue, ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox();
                  },
                  itemCount: list.length),
              ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'My ADS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,
      ),
    );
  }
}


// List<Widget> _widgetOptions = <Widget>[
//   Text('Index 0: Home'),
//   Text('Index 1: Chat'),
//   Text('Index 2: My ADS'),
//   Text('Index 3: Account'),
//
// ];