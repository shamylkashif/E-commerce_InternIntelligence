import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

import 'book.dart';
import 'book_desp.dart'; // Ensure this file contains the 'blue' color

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin {
  late TabController _tabController;

  // Sample list of books
  final List<Book> books = [
    Book(
      title: 'Soul',
      author: 'Olivia Wilson',
      imageUrl: 'assets/slider/download.jpeg',
      rating: 4.7,
    ),
    Book(
      title: 'Mystery Book',
      author: 'John Doe',
      imageUrl: 'assets/slider/Harry.jpeg',
      rating: 4.5,
    ),
    Book(
      title: 'Memory',
      author: 'Debbie Berny',
      imageUrl: 'assets/slider/memory.jpeg',
      rating: 4.1,
    ),
    // Add more books as needed
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Genre'),
            Tab(text: 'Comedy'),
            Tab(text: 'Fiction'),
          ],
        ),
        SizedBox(height: 20,),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: BouncingScrollPhysics(),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) => InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDescription()));
                    },
                    child: Container(
                      width: 180, // Adjust width as needed
                      margin: EdgeInsets.symmetric(horizontal: 6), // Space between columns
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              book.imageUrl,
                              height: 200, // Specific height for the image
                              width: 150, // Specific width for the image
                              fit: BoxFit.cover, // How the image should be fitted inside the box
                            ),
                          ),
                          SizedBox(height: 5), // Space between the image and text
                          Text(
                            book.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            book.author,
                            style: TextStyle(
                              color: Colors.grey, // Sets the text color to grey like a hint
                              fontSize: 16, // Adjusted size for consistency
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow, size: 17),
                              SizedBox(width: 4),
                              Text(
                                book.rating.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
              Center(child: Text('Comedy Content')),
              Center(child: Text('Fiction Content')),
            ],
          ),
        ),
      ],
    );
  }
}
