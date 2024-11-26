import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SoldBooks extends StatefulWidget {
  const SoldBooks({super.key,});

  @override
  State<SoldBooks> createState() => _SoldBooksState();
}

class _SoldBooksState extends State<SoldBooks> {
  // Variables to hold fetched data
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];

  // Reference to firestore Collection
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('soldBooks');

  // Controller for search bar
  TextEditingController _searchController = TextEditingController();

  // Fetch data from Firestore
  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await _collectionRef.get();
      List<Map<String, dynamic>> fetchedData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        _items = fetchedData;
        _filteredItems = fetchedData; // Initially show all users
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
        title: Text('Sold Books', style: TextStyle(color: blue)),
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
                      Container(
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
                          ],
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
