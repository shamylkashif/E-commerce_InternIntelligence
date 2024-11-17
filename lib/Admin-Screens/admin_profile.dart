import 'dart:io';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/Authentication/user-login-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? imageUrl;
  File? _profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch admin data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('admin')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          setState(() {
            nameController.text = userData['name'] ?? 'Admin Name';
            emailController.text = userData['email'] ?? 'example@mail.com';
            addressController.text = userData['address'] ?? 'Address';
            imageUrl = userData['profileImage'] ?? '';
          });
        } else {
          // Initialize Firestore document if it doesn't exist
          await FirebaseFirestore.instance.collection('admin').doc(user.uid).set({
            'adminID': user.uid,
            'name': user.displayName ?? 'Admin Name',
            'email': user.email ?? 'example@mail.com',
            'password': 'Password', // Replace with actual logic for password
            'profileImage': '',
            'address': '',
          });
          _fetchUserData(); // Fetch again to update UI
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Update admin data in Firestore
  Future<void> _updateUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        setState(() {
          isLoading = true;
        });

        String? newImageUrl = imageUrl;
        if (_profileImage != null) {
          // Upload the selected profile image to Firebase Storage
          final ref = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child('${user.uid}.jpg');
          await ref.putFile(_profileImage!);
          newImageUrl = await ref.getDownloadURL();
        }

        // Update Firestore document
        await FirebaseFirestore.instance.collection('admin').doc(user.uid).update({
          'name': nameController.text,
          'address': addressController.text,
          'profileImage': newImageUrl ?? '',
        });

        setState(() {
          isLoading = false;
          imageUrl = newImageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully.'),
          backgroundColor: Colors.green,
        ));
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error updating profile: $e");
      }
    }
  }

  // Pick image using Image Picker
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('userEmail');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
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
            SizedBox(height: 10),
            Center(
              child: Container(
                height: 180,
                width: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [yellow, blue],
                    begin: const FractionalOffset(0.5, 1),
                    end: const FractionalOffset(1.0, 0.0),
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : imageUrl != null && imageUrl!.isNotEmpty
                            ? NetworkImage(imageUrl!)
                            : AssetImage('assets/defaultImage.jpg') as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      nameController.text.isNotEmpty ? nameController.text : 'Admin Name',
                      style: TextStyle(fontSize: 20, color: Colors.white, height: 1.0),
                    ),
                    Text(
                      emailController.text.isNotEmpty ? emailController.text : 'example@mail.com',
                      style: TextStyle(fontSize: 16, color: Colors.white, height: 1.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            EditableProfileTile(
              title: 'Username',
              controller: nameController,
              icons: Icons.person,
            ),
            EditableProfileTile(
              title: 'Address',
              controller: addressController,
              icons: Icons.location_on,
            ),
            EditableProfileTile(
              title: 'Email Address',
              controller: emailController,
              icons: Icons.email,
              isEditable: false,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: Size(80, 40),
              ),
              child: isLoading
                  ? CircularProgressIndicator(color: blue)
                  : Text(
                'Save Profile',
                style: TextStyle(fontSize: 16, color: blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableProfileTile extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData icons;
  final bool isEditable;

  const EditableProfileTile({
    Key? key,
    required this.title,
    required this.controller,
    required this.icons,
    this.isEditable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icons, color: blue),
      title: Text(title, style: TextStyle(fontSize: 14)),
      subtitle: TextField(
        controller: controller,
        readOnly: !isEditable,
        decoration: InputDecoration(
          hintText: 'Enter $title',
        ),
      ),
    );
  }
}
