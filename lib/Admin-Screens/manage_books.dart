import 'package:bookstore/Admin-Screens/view_book_detail.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageBooks extends StatefulWidget {
  const ManageBooks({super.key,});

  @override
  State<ManageBooks> createState() => _ManageBooksState();
}

class _ManageBooksState extends State<ManageBooks> {
  // Variables to hold fetched data
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];

  // Reference to firestore Collection
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('AllBooks');

  // Controller for search bar
  TextEditingController _searchController = TextEditingController();

  // Fetch data from Firestore
  Future<void> fetchData() async {
    try {
      // Fetch books from AllBooks collection
      QuerySnapshot bookSnapshot = await _collectionRef.get();
      List<Map<String, dynamic>> books = bookSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Fetch ratings from Ratings collection
      QuerySnapshot ratingSnapshot = await FirebaseFirestore.instance.collection('ratings').get();
      Map<String, dynamic> ratings = {}; // Map of bookId -> rating

      // Process ratings data
      for (var doc in ratingSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        ratings[data['bookId']] = data['rating']; // Note the lowercase 'bookId'
      }

      // Merge ratings with books
      List<Map<String, dynamic>> booksWithRatings = books.map((book) {
        // Match bookId from Ratings with bookID from AllBooks
        String bookIdKey = book['bookID']; // `bookID` from AllBooks
        book['rating'] = ratings[bookIdKey] ?? 0.0; // Default rating if no match
        return book;
      }).toList();

      // Update the state with books and ratings
      setState(() {
        _items = booksWithRatings;
        _filteredItems = booksWithRatings;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Filter the users based on search query
  void _filterUsers(String query) {
    List<Map<String, dynamic>> filteredList = _items
        .where((user) =>
        (user['title'] ?? "").toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredItems = filteredList;
    });
  }

  // Function to delete a user from Firestore using uid
  Future<void> _deleteBook(String bookID) async {
    try {
      // Query the document using the uid field to find the user
      QuerySnapshot snapshot = await _collectionRef.where('bookID', isEqualTo: bookID).get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();
        setState(() {
          _filteredItems.removeWhere((user) => user['bookID'] == bookID);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Book deleted successfully")));
      }
    } catch (e) {
      print('Error deleting book: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting Book")));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data on initialization

    // Add listener to search bar
    _searchController.addListener(() {
      _filterUsers(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },
            icon: Icon(Icons.arrow_circle_left_outlined, color: blue)),
        title: Text('Manage Books', style: TextStyle(color: blue)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),),
                prefixIcon: Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(child: CircularProgressIndicator(color: Colors.grey))
                : ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  var item = _filteredItems[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewBookDetail(book: item)));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric( horizontal: 16.0), // Reduced vertical padding
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: blue,)
                                ),
                                child: CircleAvatar(
                                  radius: 25, // Adjust size
                                  backgroundImage:
                                  NetworkImage(item['imageUrl'] ?? ""),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    item['title'] ?? "",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(item['author'] ?? "",
                                  style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteBook(item['bookID']);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider( // Adds a thin line/divider after each container
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
