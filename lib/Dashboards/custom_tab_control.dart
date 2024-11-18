import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/Dashboards/home-pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Description_Review/book_desp.dart';

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> books=[];
  List<Map<String, dynamic>> Mystery=[];
  List<Map<String, dynamic>> SelfHelp=[];
  List<Map<String, dynamic>> Fiction=[];
  List<Map<String, dynamic>> Horror=[];

  Future<void> fetchBooks() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AllBooks').get();
      List<Map<String, dynamic>> fetchedBooks = [];

      for (var doc in snapshot.docs) {
        var bookData = doc.data() as Map<String, dynamic>;
        String bookId = doc['bookID'];

        // Fetch the highest rating for each book from the ratings collection
        QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance
            .collection('ratings')
            .where('bookId', isEqualTo: bookId)
            .get();

        double highestRating = 0.0;
        if (ratingSnapshot.docs.isNotEmpty) {
          highestRating = ratingSnapshot.docs
              .map((ratingDoc) => (ratingDoc['rating'] as num).toDouble())
              .reduce((a, b) => a > b ? a : b);
        }

        // Add the highest rating to the book data
        bookData['rating'] = highestRating;
        fetchedBooks.add(bookData);
      }

      setState(() {
        Mystery = fetchedBooks.where((book) => book['category'] == 'Mystery').toList();
        SelfHelp = fetchedBooks.where((book) => book['category'] == 'Self-help').toList();
        Fiction = fetchedBooks.where((book) => book['category'] == 'Fiction').toList();
        Horror = fetchedBooks.where((book) => book['category'] == 'Horror').toList();
      });
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

  //To limit words
  String limitWords(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return words.take(wordLimit).join(' ') + '...';
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
            Tab(text: 'Mystery'),
            Tab(text: 'Self-help'),
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
              BookData(Mystery),
              BookData(SelfHelp),
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
  // Check if the category has no books
  if (booksCategory.isEmpty) {
    return Center(
      child: Text(
        "No Books Available",
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
  return ListView.builder(
      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
      physics: BouncingScrollPhysics(),
      itemCount: booksCategory.length,
      itemBuilder:(context, index){
        var book = booksCategory[index];
        return SingleChildScrollView(
          child: Row(
            children: [
              Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
                 child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                   ClipRRect(
                borderRadius: BorderRadius.circular(15),
                     child: InkWell(
                  onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => BookDescription(book:book)));
                  }, child: Image.network(
                    book['imageUrl'] ?? '',
                    height: 210,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
                   SizedBox(height: 5),
                    Padding(
                padding: const EdgeInsets.only(left: 5),
                     child: Text(
                       limitWords( book['title'] ?? "Unknown Title", 3),
                       style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),

                   Padding(
                padding: const EdgeInsets.only(left: 5),
                     child: Text(
                       limitWords( book['author'] ?? "Unknown Title", 3),
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
