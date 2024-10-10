import 'dart:io';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:bookstore/screens/profile_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loaders.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _profileImage;  // Store the profile image locally
  String? imageUrl;     // Image URL from Firebase Storage
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

// Fetch current user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('UsersBookStore')
            .doc(user.uid)
            .get();

        // Set values or dummy data if fields are empty
        nameController.text = userData['name'] ?? 'Student Name';
        emailController.text = userData['email'] ?? 'example@mail.com';
        addressController.text = userData['address'] ?? 'Address';

        setState(() {
          imageUrl = userData['profileImage'] ?? '';  // Make sure to fetch and set the image URL
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }


  // Pick profile image from the gallery
  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImage = File(pickedFile.path);  // Set the selected image locally
  //     });
  //   }
  // }

  // Upload profile image to Firebase Storage
  Future<String?> _uploadProfileImage() async {
    if (_profileImage != null) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Upload to Firebase Storage as PNG
          String fileName = '${user.uid}.png';
          Reference storageRef = FirebaseStorage.instance.ref().child('users_images/$fileName');

          // Set metadata with MIME type as PNG
          SettableMetadata metadata = SettableMetadata(contentType: 'image/png');

          // Upload file with metadata
          await storageRef.putFile(_profileImage!, metadata);

          // Get the download URL
          String downloadURL = await storageRef.getDownloadURL();
          return downloadURL;
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
    return null;
  }


  // Update user data including profile image
  Future<void> _updateUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Show loader
        setState(() {
          isLoading = true;
        });
        // If the user selected a new profile image, upload it
        if (_profileImage != null) {
          String? uploadedImageUrl = await _uploadProfileImage();
          if (uploadedImageUrl != null) {
            imageUrl = uploadedImageUrl;  // Update with the new URL
          }
        }

        // Update Firestore with other details
        await FirebaseFirestore.instance.collection('UsersBookStore').doc(user.uid).update({
          'name': nameController.text,
          'address': addressController.text,
          if (imageUrl != null) 'profileImage': imageUrl,  // Update profile image URL if available
        });
        // Hide loader
        setState(() {
          isLoading = false;
        });
        SnackbarHelper.show(context as BuildContext, 'Profile updated successfully.', backgroundColor: Colors.green);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error updating profile: $e");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () async {
                // Remove email from SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userEmail');  // Assuming you store the email under the key 'email'

                // Navigate to the login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false, // Removes all previous routes
                );
              },
              child: Container(
                height: 33,
                width: 75,
                decoration: BoxDecoration(
                  color: yellow,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    'LogOut',
                    style: TextStyle(color: blue, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
           child: Column(
            children: [
              SizedBox(height: 10,),
              Center(
                child: Container(
                  height: 180,
                  width: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      yellow, blue
                    ],
                      begin: const FractionalOffset(0.5, 1),
                      end: const FractionalOffset(1.0, 0.0),
                    ),
                    borderRadius: BorderRadius.circular(25),

                  ),
                  child: Column(
                    children: [
                       SizedBox(height: 16,),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  image: DecorationImage(
                                      image: _profileImage != null
                                          ? FileImage(_profileImage!) // Show selected local image
                                          : imageUrl != null && imageUrl!.isNotEmpty
                                          ? NetworkImage(imageUrl!)
                                          : AssetImage('assets/p.jpg') as ImageProvider,
                                    fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 70,left: 137),
                            height:30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child: InkWell(
                                onTap: (){
                                  showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                          bottom: Radius.circular(15)

                                      ),
                                    ),
                                    builder: (context) {
                                      return ProfilePicChoice(
                                        onImageSelected: (selectedImage) {
                                          setState(() {
                                            _profileImage = selectedImage;  // Update the local image with the one selected
                                          });
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Icon(Icons.camera_alt_outlined, color: blue, size: 20,)),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        nameController.text.isNotEmpty ? nameController.text : 'Clara Albert',
                        style: TextStyle(fontSize: 20, color: Colors.white, height: 1.0),
                      ),
                      Text(
                        emailController.text.isNotEmpty ? emailController.text : 'ClaraAlbert@gmail.com',
                        style: TextStyle(fontSize: 16, color: Colors.white, height: 1.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Column(
                children: [
                  EditableProfileTile(
                    title: 'Username',
                    controller: nameController, // Pass the TextEditingController
                    icons: Icons.person,
                  ),
                  EditableProfileTile(
                    title: 'Address',
                    controller: addressController, // Pass the TextEditingController
                    icons: Icons.location_on,
                  ),
                  EditableProfileTile(
                    title: 'Email Address',
                    controller: emailController, // Pass the TextEditingController
                    icons: Icons.email,
                    isEditable: false, // Email should not be editable
                  ),

                  SizedBox(height: 20), // Space before the Save button
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow, // Set background color to yellow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(100, 50), // Set the width (200) and height (50)
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.blue) // Change spinner color to blue
                        : Text(
                      'Save Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: blue, // Set the text color to blue
                      ),
                    ),
                  ),
                ],
              ),

            ],
           ),
        ),
    );
  }
}


class EditableProfileTile extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final IconData icons;
  final bool isEditable; // Add this field

  const EditableProfileTile({
    Key? key,
    required this.title,
    required this.controller,
    required this.icons,
    this.isEditable = true, // Default to true unless specified
  }) : super(key: key);

  @override
  State<EditableProfileTile> createState() => _EditableProfileTileState();
}

class _EditableProfileTileState extends State<EditableProfileTile> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icons, color: blue),
      title: Text(widget.title, style: TextStyle(fontSize: 14)),
      subtitle: isEditing
          ? TextField(
        controller: widget.controller,
        autofocus: true,
        decoration: InputDecoration(hintText: 'Enter ${widget.title}'),
      )
          : Text(widget.controller.text, style: TextStyle(fontSize: 17)),
      trailing: widget.isEditable // Only show edit button if the field is editable
          ? IconButton(
           icon: Icon(isEditing ? Icons.check : Icons.edit, color: blue),
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
      )
          : null, // No edit button for non-editable fields
    );
  }
}




