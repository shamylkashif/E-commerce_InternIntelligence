import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';
import 'book.dart';
import 'book_desp.dart';

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
    _tabController = TabController(length: 4, vsync: this);
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
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicatorColor: Colors.yellow[600], // Color of the indicator line
          indicatorWeight: 3.0, // Weight of the indicator line
          labelColor: Colors.yellow[600], // Color of the selected tab text
          unselectedLabelColor: blue, // Color of the unselected tab text
          tabs: [
            Tab(text: 'All Genre'),
            Tab(text: 'Comedy'),
            Tab(text: 'Fiction'),
            Tab(text: 'Horror'),
          ],
        ),
        SizedBox(height: 15),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: BouncingScrollPhysics(),
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDescription()));
                            },
                            child: Image.asset(
                              book.imageUrl,
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.author,
                            style: TextStyle(
                              color: Colors.grey[350],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
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
                                  book.rating.toString(),
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),
              Center(child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDescription()));
                            },
                            child: Image.asset(
                              book.imageUrl,
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.author,
                            style: TextStyle(
                              color: Colors.grey[350],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
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
                                  book.rating.toString(),
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),),
              Center(child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDescription()));
                            },
                            child: Image.asset(
                              book.imageUrl,
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.author,
                            style: TextStyle(
                              color: Colors.grey[350],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
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
                                  book.rating.toString(),
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),),
              Center(child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: books.map((book) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDescription()));
                            },
                            child: Image.asset(
                              book.imageUrl,
                              height: 200,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.title,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            book.author,
                            style: TextStyle(
                              color: Colors.grey[350],
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Container(
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
                                  book.rating.toString(),
                                  style: TextStyle(
                                    color: blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ),
              ),),
            ],
          ),
        ),
      ],
    );
  }
}
