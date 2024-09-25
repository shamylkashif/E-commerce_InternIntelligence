import 'dart:io';
import 'package:bookstore/setting.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:bookstore/screens/profile_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  File? _profileImage;
  String? _downloadURL;
  bool _isUploading = false;

  //Function to upload image to firebase storage
  Future<void> _uploadProfileImage(File image)async {
    setState(() {
      _isUploading = true;
    });
    try {
      // Get the file name
      String fileName = basename(image.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('profile_pics/$fileName');

      // Upload the image
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Store the download URL in Firestore or Realtime Database
      await FirebaseFirestore.instance.collection('users').doc('user_id').update({
        'profileImageUrl': downloadURL,
      });

      setState(() {
        _downloadURL = downloadURL;
        _isUploading = false;
      });

      print('Image uploaded successfully. URL: $downloadURL');
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _isUploading = false;
      });
    }
  }

 //This function is triggered when a new image is selected in ProfileChoice
  void _updateProfileImage(File image){
    setState(() {
      _profileImage = image;
    });
    //Upload the selected image to firebase
    _uploadProfileImage(image);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                },
                child: Container(
                   height: 33,
                   width: 75,
                   decoration: BoxDecoration(
                     color: yellow,
                     borderRadius: BorderRadius.circular(15)
                   ),
                  child: Center(child: Text('LogOut', style: TextStyle(color: blue, fontSize: 16),)),
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
                                          ? FileImage(_profileImage!)
                                          : _downloadURL != null
                                             ? NetworkImage(_downloadURL!) as ImageProvider
                                             : AssetImage('assets/p.jpg'),
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
                                      builder: (context){
                                        return ProfilePicChoice(
                                          onImageSelected: _updateProfileImage,
                                        );
                                      }
                                  );                                 },
                                child: Icon(Icons.camera_alt_outlined, color: blue, size: 20,)),
                          ),
                        ],
                      ),

                      SizedBox(height: 8,),
                      Text('Clara Albert',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.0
                        ),),
                      Text('ClaraAlbert@gmail.com',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.0
                        ),),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 20,),
              Column(
                children: [
                  EditableProfileTile(
                      title: 'Username',
                      value: 'Clara Albert',
                      icons: Icons.person),

                  EditableProfileTile(
                      title: 'Email Address',
                      value: 'claraalbert596@gmail.com',
                      icons: Icons.email),
                  EditableProfileTile(
                      title: 'Address',
                      value: 'Lahore',
                      icons: Icons.location_on),
                  ListTile(
                    leading:Icon(Icons.settings, color: blue,) ,
                    title: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MySettings()));
                      },
                       child: Text(
                        'Settings', style: TextStyle(fontSize: 17, ),
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
  final String value;
  final IconData icons;

  const EditableProfileTile({
    Key? key,
    required this.title,
    required this.value,
    required this.icons,
  }) : super(key: key)  ;

  @override
  State<EditableProfileTile> createState() => _EditableProfileTileState();
}

class _EditableProfileTileState extends State<EditableProfileTile> {

  bool isEditing = false;
  late TextEditingController _controller;
  @override

  void initState(){
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icons, color: blue),
      title: Text(widget.title, style: TextStyle(fontSize: 14)),
      subtitle: isEditing
          ? TextField(
        controller: _controller,
        autofocus: true, // Automatically focus on the text field
        decoration: InputDecoration(hintText: 'Enter ${widget.title}'),
      )
          : Text(_controller.text, style: TextStyle(fontSize: 17)),
      trailing: IconButton(
        icon: Icon(isEditing ? Icons.check : Icons.edit, color: blue),
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
      ),
    );
  }
}


