import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'book_desp.dart';

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> books=[];
  List<Map<String, dynamic>> AllGenre=[];
  List<Map<String, dynamic>> Comedy=[];
  List<Map<String, dynamic>> Fiction=[];
  List<Map<String, dynamic>> Horror=[];

  Future<void> fetchBooks() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AllBooks').get();
      List<Map<String, dynamic>> fetchedBooks = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        AllGenre = fetchedBooks.where((book) => book['category'] == 'All Genre').toList();
        Comedy = fetchedBooks.where((book) => book['category'] == 'Comedy').toList();
        Fiction = fetchedBooks.where((book) => book['category'] == 'Fiction').toList();
        Horror= fetchedBooks.where((book) => book['category'] == 'Horror').toList();
      });
    } catch (e) {
      print("Error fetching books: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchBooks();
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
              BookData(AllGenre),
              BookData(Comedy),
              BookData(Fiction),
              BookData(Horror),
            ],
          ),
        ),
      ],
    );
  }
}


Widget  BookData(List<Map<String, dynamic>> booksCategory){
  return ListView.builder(
      itemCount: booksCategory.length,
      itemBuilder:(context, index){
        var book = booksCategory[index];
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
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
                       child: Image.network(
                    book['imageUrl'] ?? '',
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
                  book['title'] ?? "Unknown Title",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),

                   Padding(
                padding: const EdgeInsets.only(left: 5),
                     child: Text(
                  book["author"] ?? "Unknown Author",
                  style: TextStyle(color: Colors.grey[350], fontSize: 14,
                  ),
                ),
              ),
                   Padding(
                padding: const EdgeInsets.only(left: 5),
                    child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.yellow[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                     child: Text(
                    book['price'].toString(),
                    style: TextStyle(
                      color: blue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        ]
          ),
        );

      }

  );
}
