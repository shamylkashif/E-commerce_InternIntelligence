import 'dart:io';

import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicChoice extends StatefulWidget {
  final Function(File) onImageSelected;
  const ProfilePicChoice({super.key, required this.onImageSelected});

  @override
  State<ProfilePicChoice> createState() => _ProfilePicChoiceState();
}

class _ProfilePicChoiceState extends State<ProfilePicChoice> {

  final ImagePicker _picker = ImagePicker();

  //function to select image from gallery
  Future<void> _chooseFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image !=null){
      widget.onImageSelected(File(image.path));
      Navigator.pop(context);
    }
  }
  //function to select image from camera
  Future<void> _takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if(image !=null){
      widget.onImageSelected(File(image.path));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 310,
      decoration: BoxDecoration(
        border: Border.all(color: blue, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            height:30,
            width: 30,
            child: Icon(Icons.camera_alt_outlined, color:blue, size: 30,),
          ),
          SizedBox(height: 35,),
          Text('Change Profile Picture', style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 25,),
          InkWell(
            onTap: _chooseFromGallery,
            child: Container(
              height: 35,
              width: 190,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Choose from Gallery', style: TextStyle(fontSize: 15, color: blue),)),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: _takePhoto,
            child: Container(
              height: 35,
              width: 190,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Take a Photo', style: TextStyle(fontSize: 15, color: blue),)),
            ),
          ),
        ],
      ),
    );
  }
}
