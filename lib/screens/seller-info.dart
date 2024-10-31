import 'package:bookstore/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../commons/colors.dart';


class SellerInformation extends StatefulWidget {
  final String bookID;
  const SellerInformation({Key? key, required this.bookID}) : super(key: key);

  @override
  State<SellerInformation> createState() => _SellerInformationState();
}

class _SellerInformationState extends State<SellerInformation> {
  String sellerName = '';
  String sellerImage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getSellerInfo();
  }

  Future<void> _getSellerInfo() async {
    try {
      // Fetch book document by bookID
      DocumentSnapshot bookDoc = await FirebaseFirestore.instance
          .collection('AllBooks')
          .doc(widget.bookID)
          .get();

      // Check if the document exists and get its data
      if (bookDoc.exists) {
        Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
        String uploaderUid = bookData['uid'];

        // Print for debugging
        print('Uploader UID: $uploaderUid'); // Debugging print

        // Fetch user info from UsersBookStore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('UsersBookStore')
            .doc(uploaderUid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          // Set state with fetched user data
          setState(() {
            sellerName = userData['name'] ?? ''; // Use null check
            sellerImage = userData['profileImage'] ?? ''; // Use null check
            isLoading = false; // Stop loading once data is fetched
          });
        } else {
          print('User document does not exist'); // Debugging print
        }
      } else {
        print('Book document does not exist'); // Debugging print
      }
    } catch (e) {
      print('Error fetching seller info: $e'); // Error print
      setState(() {
        isLoading = false; // Stop loading on error as well
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
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
                  child: Image.network(
                    sellerImage.isEmpty
                        ? 'assets/defaultImage.jpg' // Default image if sellerImage is empty
                        : sellerImage,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
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
                    Text('Sargodha, Pakistan'),
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
                onTap: () {},
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPreviewScreen()));
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

