import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookstore/Dashboards/home-pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../loaders.dart';



class PostAD extends StatefulWidget {
  const PostAD({super.key, });

  @override
  State<PostAD> createState() => _PostADState();
}

class _PostADState extends State<PostAD> {

  String? selectedCondition;
  String? selectedCategory;
  bool isChecked = false;
  File? _image;
  String? imagePath;
  String? bookId;
  String? currentUID;
  bool isLoading = false;


  final ImagePicker _picker = ImagePicker();
  @override


  void initState() {
    super.initState();
    _getCurrentUserUID();
  }
  // Fetch current user UID
  Future<void> _getCurrentUserUID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUID = user.uid;
    }
  }


  //Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imagePath = pickedFile.path;
      });

      // Show image in AwesomeDialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Image.file(_image!, width: 100, height: 100), // Display picked image
            const SizedBox(height: 10),
            const Text('Image from Gallery'),
          ],
        ),
        btnOkOnPress: () {},
      ).show();
    }
  }

  //Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imagePath = pickedFile.path;
      });

      // Show image in AwesomeDialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Image.file(_image!, width: 100, height: 100), // Display picked image
            const SizedBox(height: 10),
            const Text('Image from Camera'),
          ],
        ),
        btnOkOnPress: () {},
      ).show();
    }
  }
  // Generate a unique BookID;
  // String _generateBookId() {
  //   final random = Random();
  //   final int randomNumber = random.nextInt(10000); // Random number between 0 and 9999
  //   return 'Book-$randomNumber';
  // }

  // Fetch current location when checkbox is checked
  // Get the user's current location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }


  //Upload image to firebase and get the download URL
  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('book_images/$fileName');
      await ref.putFile(imageFile);
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  //List of Categories
  List<String> categories = ['Mystery' , 'Self-help' , 'Fiction' , 'Horror'];

  //List of Conditions
  List<String> conditions = ['New', 'Like New', 'Used-Good', 'Used-Acceptable'];

  //Text Controllers for form fields
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  //String? imageUrl = _image != null ? await _uploadImageToFirebase(_image!) : null;


  // Save or Update Book Data
  Future<void> _saveData() async {
    // Validate required fields
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      SnackbarHelper.show(context, 'Please select a category', backgroundColor: Colors.red);
      return;
    }
    if (_image == null) {
      SnackbarHelper.show(context, 'Please upload an image', backgroundColor: Colors.red);
      return;
    }
    if (titleController.text.isEmpty) {
      SnackbarHelper.show(context, 'Please enter the book title', backgroundColor: Colors.red);
      return;
    }
    if (authorController.text.isEmpty) {
      SnackbarHelper.show(context, 'Please enter the author\'s name', backgroundColor: Colors.red);
      return;
    }
    if (priceController.text.isEmpty) {
      SnackbarHelper.show(context, 'Please enter the price', backgroundColor: Colors.red);
      return;
    }
    if (pagesController.text.isEmpty) {
      SnackbarHelper.show(context, 'Please enter the number of pages', backgroundColor: Colors.red);
      return;
    }
    if (languageController.text.isEmpty) {
      SnackbarHelper.show(context, 'Please enter the language', backgroundColor: Colors.red);
      return;
    }
    if (descriptionController.text.isEmpty) {
      SnackbarHelper.show(context, 'Please enter the description', backgroundColor: Colors.red);
      return;
    }
    if (selectedCondition == null || selectedCondition!.isEmpty) {
      SnackbarHelper.show(context, 'Please select the condition of the book', backgroundColor: Colors.red);
      return;
    }
    if (!isChecked) {
      SnackbarHelper.show(context, 'Location is required', backgroundColor: Colors.red);
      return;
    }
    setState(() {
      isLoading = true; // Show loader
    });

    // Get current location
    Position? position = await _getCurrentLocation();
    if (position == null) {
      SnackbarHelper.show(context, 'Unable to get location.', backgroundColor: Colors.red);
      setState(() {
        isLoading = false; // Hide loader
      });
      return;
    }

    // Prepare location as a GeoPoint
    GeoPoint currentLocation = GeoPoint(position.latitude, position.longitude);

    // Upload image to Firebase
    String? imageUrl = await _uploadImageToFirebase(_image!);

    // Create a unique Book ID
    String bookID = 'Book-${DateTime.now().millisecondsSinceEpoch}';

    // Create a map to save data
    Map<String, dynamic> bookData = {
      'category': selectedCategory,
      'title': titleController.text,
      'author': authorController.text,
      'price': priceController.text,
      'pages': pagesController.text,
      'language': languageController.text,
      'description': descriptionController.text,
      'condition': selectedCondition,
      'useLocation': isChecked,
      'imageUrl': imageUrl,
      'uid': currentUID,
      'bookID': bookID,
      'currentLocation': currentLocation,
    };

    try {
      // Add the book data to Firebase (without editing check)
      await FirebaseFirestore.instance.collection('AllBooks').add(bookData);
      _showSnackbar('Book data saved successfully', Colors.green);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      _showSnackbar('Failed to save book: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }
  void _showSnackbar(String message, Color color) {
    SnackbarHelper.show(context, message, backgroundColor: color);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [
           Padding(
        padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Section
                   RichText(
                  text: TextSpan(
                    text: 'Select Category',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                  ),
                  ),
                   SizedBox(height: 8),
                   Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey)
                ),
                     child: DropdownButtonHideUnderline(
                       child: DropdownButton<String>(
                         hint: Text(
                      'Select Category',
                      style: TextStyle(color: Colors.grey),
                    ),
                    value: selectedCategory,
                    isExpanded: true,
                    items: categories.map((String category)
                     {
                       return DropdownMenuItem<String>(
                         value: category,
                         child: Text(category),
                       );
                     }
                    ).toList(),
                    onChanged: (newValue) { setState(() {
                      selectedCategory = newValue;
                    });},
                         icon: Icon(Icons.arrow_drop_down, color: blue),
                      style: TextStyle(color: blue, fontSize: 16),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
                    SizedBox(height: 16,),

              // Image Upload Section
                    Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                     child: Column(
                  children: [
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.book, color: blue, size: 50),
                        Icon(Icons.camera_alt, color: blue, size: 50),
                      ],
                    ),
                        SizedBox(height: 8),
                         OutlinedButton(
                      style: OutlinedButton.styleFrom(side: BorderSide(color: blue)),
                      onPressed: () {
                         AwesomeDialog(
                           context: context,
                           dialogType: DialogType.question,
                           animType: AnimType.scale,
                           title: 'Select Image',
                           titleTextStyle: TextStyle(),
                           desc: 'Choose an option to upload image',
                           descTextStyle: TextStyle(),
                           btnOkText: 'Gallery',
                           btnOkColor: blue,
                           btnOkIcon: Icons.photo_library,
                           btnOkOnPress: (){
                             _pickImageFromGallery();
                           },
                           btnCancelText: 'Camera',
                           btnCancelColor: blue,
                           btnCancelIcon: Icons.camera_alt,
                           btnCancelOnPress: (){
                             _pickImageFromCamera();
                           },
                         ).show();
                      },
                            child: Text("Add images", style: TextStyle(color: blue),),
                    ),
                        SizedBox(height: 8),
                        Text(
                      "5MB maximum file size accepted in the following formats: .jpg, .jpeg, .png, .gif",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
                   SizedBox(height: 16),

              // Book Title
                    RichText(
                text: TextSpan(
                    text: 'Book Title',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                   TextFormField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter book title",
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )
                ),
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
                    SizedBox(height: 16),

              // Author
                    RichText(
                text: TextSpan(
                    text: 'Author',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                    TextFormField(
                controller: authorController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter author's name",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    fillColor: Colors.white,
                  filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )
                ),
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
                   SizedBox(height: 16),

              // Price
                   RichText(
                text: TextSpan(
                    text: 'Price',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                   TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter price",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    fillColor: Colors.white,
                  filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )
                ),
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
                   SizedBox(height: 16),

              // Number of Pages
                   RichText(
                text: TextSpan(
                    text: 'Number of Pages',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                   TextFormField(
                controller: pagesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter number of pages",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    fillColor: Colors.white,
                  filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )
                ),
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
              ),
                   SizedBox(height: 16),

              // Language
                   RichText(
                text: TextSpan(
                    text: 'Language',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                   TextFormField(
                controller: languageController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter language",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    fillColor: Colors.white,
                  filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    )
                ),
                maxLines: 1,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
                   SizedBox(height: 16),


              //Book Description
                   RichText(
                text: TextSpan(
                    text: 'Book Description',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                    Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                      child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: descriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write Book Description",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      )
                  ),
                  maxLines: null,
                  minLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
                   SizedBox(height: 16),


              // Condition
                   RichText(
                text: TextSpan(
                    text: 'Condition',
                    style: TextStyle(fontSize: 14,color: blue),
                    children:  [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    ]
                ),
              ),
                   Wrap(
                spacing: 8,
                children: conditions.map((String condition){
                    return ChoiceChip(
                        label: Text(condition),
                        selected: selectedCondition == condition,
                        onSelected: (bool selected){
                          setState(() {
                            selectedCondition = selected ? condition : null ;
                          });
                        },
                      selectedColor: yellow,
                      backgroundColor: Colors.grey[200],
                    );
                  }).toList(),
              ),

                   SizedBox(height: 10),

              //Checkbox Location
                   CheckboxListTile(
                     title: const Text('Use my current Location', style: TextStyle(color: blue)),
                value: isChecked,
                onChanged: (newValue) async {
                  setState(() {
                    isChecked = newValue!;
                  });
                  if (isChecked) {
                    await _getCurrentLocation();
                  }
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: yellow,
                checkColor: blue,
              ),

              // Save Button
                   SizedBox(
                width: double.infinity,
                     child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: yellow),
                  onPressed: () {
                    _saveData();
                  },
                       child: Text("Save", style: TextStyle(color: blue),),
                ),
              ),
            ],
          ),
        ),
      ),
            if (isLoading)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.grey,),
                  ),
                ),
              ),
        ]
      ),
    );
  }
}
