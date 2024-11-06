import 'package:bookstore/screens/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commons/colors.dart';


class SellerInformation extends StatefulWidget {
  final Map<String, dynamic> book;
  const SellerInformation({Key? key, required this.book}) : super(key: key);

  @override
  State<SellerInformation> createState() => _SellerInformationState();
}

class _SellerInformationState extends State<SellerInformation> {
  String sellerName = '';
  String sellerImage = '';
  String sellerAddress = '';
  GeoPoint? currentLocation; // New variable to store the location
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getSellerInfo();
  }

  Future<void> _getSellerInfo() async {
    print('Book ID: ${widget.book['bookID']}'); // Debugging print for bookID

    try {
      // Fetch all documents from AllBooks collection
      QuerySnapshot allBooksSnapshot = await FirebaseFirestore.instance
          .collection('AllBooks')
          .get();

      bool bookFound = false;

      // Loop through the documents to find a match for bookID and uid
      for (var doc in allBooksSnapshot.docs) {
        Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;

        // Check if bookID and uid match
        if (bookData['bookID'] == widget.book['bookID']) {
          String uploaderUid = bookData['uid'] ?? '';
          currentLocation = bookData['currentLocation'];
          print('Uploader UID: $uploaderUid'); // Debugging print
          print('Current Location: ${currentLocation?.latitude}, ${currentLocation?.longitude}'); // Debugging print

          // Fetch user data from UsersBookStore collection
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('UsersBookStore')
              .doc(uploaderUid)
              .get();

          if (userDoc.exists) {
            Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

            // Update the state with fetched user data
            setState(() {
              sellerName = userData['name'] ?? '';
              sellerImage = userData['profileImage'] ?? '';
              sellerAddress = userData['address'] ?? '';
              print('Seller Name: $sellerName'); // Debugging print
              print('Seller Image URL: $sellerImage'); // Debugging print
              print('Seller Address: $sellerAddress'); // Debugging print
              isLoading = false;
            });

            bookFound = true;
            break; // Exit loop once matching book is found
          }
        }
      }

      if (!bookFound) {
        print('No matching book found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching seller info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }




  // Method to open Google Maps at the specified location
  Future<void> _openMap() async {
    if (currentLocation != null) {
      final lat = currentLocation!.latitude;
      final lng = currentLocation!.longitude;
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        print('Could not open Google Maps');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          height: 500,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 5),
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: sellerImage.isNotEmpty
                        ? Image.network(sellerImage, fit: BoxFit.cover)
                        : Image.asset('assets/defaultImage.jpg', fit: BoxFit.cover),
                  ),
                ),
                title: Text(
                  sellerName.isEmpty ? 'Loading...' : sellerName,
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 24),
                    SizedBox(width: 5),
                    Text(sellerAddress),
                  ],
                ),
              ),
              Divider(indent: 15, endIndent: 15),
              Padding(
                padding: const EdgeInsets.only(right: 155, top: 10),
                child: Text(
                  'Terms And Conditions',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildBullet('Be respectful and professional'),
              _buildBullet('Provide clear and honest information'),
              _buildBullet('Negotiate Friendly'),
              Padding(
                padding: const EdgeInsets.only(right: 80, top: 15),
                child: Text(
                  'Tap Below to view Seller Location',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: _openMap, // Open Google Maps with location
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: 130,
                    width: 350,
                    child: Image.asset(
                      'assets/map.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 350,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(backgroundColor: yellow),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPreviewScreen()));
                  },
                  child: Text("Contact Seller", style: TextStyle(color: blue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBullet(String text) {
  return ListTile(
    dense: true,
    visualDensity: VisualDensity(vertical: -4),
    minLeadingWidth: 0,
    leading: FaIcon(FontAwesomeIcons.circle, size: 8),
    title: Text(text),
  );
}

