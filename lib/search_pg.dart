import 'package:bookstore/book_desp.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollController scrollController1;
  late ScrollController scrollController2;
  late Timer timer;
  String searchQuery = '';
  List<Map<String, dynamic>> allBooks = [];
  List<Map<String, dynamic>> displayedBooks = [];


  bool reverse1 = false;
  bool reverse2 = false;


  @override
  void initState() {
    super.initState();

    scrollController1 = ScrollController();
    scrollController2 = ScrollController();

   //Timer of scrolling
    timer = Timer.periodic(const Duration(milliseconds: 90), (Timer t) {
      autoScroll(scrollController1, reverse1, (isReverse) {
        setState(() {
          reverse1 = isReverse;
        });
      });
      autoScroll(scrollController2, reverse2, (isReverse) {
        setState(() {
          reverse2 = isReverse;
        });
      });
    });
    fetchBooks();
  }
  //Fetch book data
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
        allBooks = fetchedBooks;
        displayedBooks = allBooks;
      });
    } catch (e) {
      print("Error fetching books: $e");
    }
  }

   //Search books
  void searchBooks(String query) {
    setState(() {
      searchQuery = query;
      if(query.isEmpty){
        displayedBooks = allBooks;
      } else {
        displayedBooks = allBooks.where((book)=>
        (book['title'] as String ).toLowerCase().contains(query.toLowerCase()) ||
            (book['author'] as String ).toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }
   //Scroll Direction
  void autoScroll(ScrollController controller, bool reverse, Function(bool) updateDirection) {
    double maxScrollExtent = controller.position.maxScrollExtent;
    double minScrollExtent = controller.position.minScrollExtent;

    if (!reverse) {
      controller.jumpTo(controller.offset + 2);
      if (controller.offset >= maxScrollExtent) {
        updateDirection(true);  // Change direction to reverse
      }
    } else {
      controller.jumpTo(controller.offset - 2);
      if (controller.offset <= minScrollExtent) {
        updateDirection(false);  // Change direction to forward
      }
    }
  }

  @override
  void dispose() {
    scrollController1.dispose();
    scrollController2.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              onChanged:  (query){
                searchBooks(query);
              },
              style: const TextStyle(color: Colors.black),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Search book',
                labelStyle: const TextStyle(color: Color(0xFF0A4DA2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0A4DA2)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0A4DA2)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text('Category', style: TextStyle(color: Color(0xFF0A4DA2), fontSize: 25)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController1,
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryContainer(label: 'Fantasy'),
                      CategoryContainer(label: 'Horror'),
                      CategoryContainer(label: 'Adventure'),
                      CategoryContainer(label: 'Self-help'),
                      CategoryContainer(label: 'Travel'),
                      CategoryContainer(label: 'Cooking'),
                      CategoryContainer(label: 'Crime'),
                      CategoryContainer(label: 'Politics'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController2,
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryContainer(label: 'Art'),
                      CategoryContainer(label: 'Early Readers'),
                      CategoryContainer(label: 'Text Books'),
                      CategoryContainer(label: 'Study Guides'),
                      CategoryContainer(label: 'Test Preparation'),
                      CategoryContainer(label: 'Islam'),
                      CategoryContainer(label: 'Nature'),
                      CategoryContainer(label: 'Environment'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Books Section
          allBooks.isEmpty
              ? Center(child: CircularProgressIndicator(color: Colors.grey,),)
         :  Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: displayedBooks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // Number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65, // Adjust this ratio to control the size of the grid items
                ),
                itemBuilder: (context, index) {
                  final book = displayedBooks[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookDescription(book: book)));
                          },
                          child: SizedBox(
                            height: 225,  // Fixed height for the image
                            width: double.infinity,  // Ensure the image takes full width
                            child: Image.network(
                              book['imageUrl'] ?? '',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8), // Add some spacing between image and text
                      Flexible(
                         child: Text(
                          book['title'] ?? 'Unknown',
                          style: const TextStyle(
                            color: blue,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis, // Text will be truncated if too long
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}



class CategoryContainer extends StatelessWidget {
  final String label;

  const CategoryContainer({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: yellow.withOpacity(0.6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: blue),
        ),
      ),
    );
  }
}
