import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bookstore/Dashboards/home-pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class EditPost extends StatefulWidget {
  final String bookID;
  const EditPost({super.key, required this.bookID, });

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  List<Map<String, dynamic>> allBooks = [];
  bool isChecked = false;
  String? selectedCondition;
  String? selectedCategory;
  File? _image;
  String? imagePath;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Initialize text controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBookData(widget.bookID);
  }

  Future<void> _fetchBookData(String bookID) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('AllBooks')
          .where('bookID', isEqualTo: bookID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var bookData = querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          titleController.text = bookData['title'] ?? '';
          authorController.text = bookData['author'] ?? '';
          priceController.text = bookData['price'] ?? '';
          pagesController.text = bookData['pages'] ?? '';
          languageController.text = bookData['language'] ?? '';
          descriptionController.text = bookData['description'] ?? '';
          selectedCategory = bookData['category'] ?? '';
          selectedCondition = bookData['condition'] ?? ''; // Add this line for condition
          imagePath = bookData['imageUrl'] ?? '';
        });
      } else {
        print("Book not found!");
      }
    } catch (e) {
      print("Error fetching book data: $e");
    }
  }

  Future<void> _updatePosts(String bookID, Map<String, dynamic> updatedData) async {
    setState(() {
      isLoading = true; // Start loading
    });

    try {
      // If an image file is selected, upload it to Firebase Storage
      if (_image != null) {
        String? imageUrl = await _uploadImageToFirebase(_image!);
        if (imageUrl != null) {
          // Add imageUrl to the updated data map
          updatedData['imageUrl'] = imageUrl;
        } else {
          print("Image upload failed");
        }
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('AllBooks')
          .where('bookID', isEqualTo: bookID)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;

        await FirebaseFirestore.instance
            .collection('AllBooks')
            .doc(documentId)
            .update(updatedData);

        // Success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Book updated successfully.",
              style: TextStyle(color: Colors.green),
            ),
            backgroundColor: Colors.black,
          ),
        );
        print("Book updated successfully.");

        // Navigate to home page after a delay to allow the snackbar to show
        Future.delayed(Duration(seconds: 2), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Book ID not found",
              style: TextStyle(color: Colors.red),
            ),
            backgroundColor: Colors.black,
          ),
        );
        print("No book found with the provided bookID.");
      }
    } catch (e) {
      print("Error updating book: $e");
    } finally {
      setState(() {
        isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imagePath = pickedFile.path;
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Image.file(_image!, width: 100, height: 100),
            const SizedBox(height: 10),
            const Text('Image from Gallery'),
          ],
        ),
        btnOkOnPress: () {
        },
      ).show();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imagePath = pickedFile.path;
      });

      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Column(
          children: [
            Image.file(_image!, width: 100, height: 100),
            const SizedBox(height: 10),
            const Text('Image from Camera'),
          ],
        ),
        btnOkOnPress: () {
        },
      ).show();
    }
  }

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

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        print('Location permission denied.');
        return null;
      }
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void dispose() {
    // Dispose text controllers
    titleController.dispose();
    authorController.dispose();
    priceController.dispose();
    pagesController.dispose();
    languageController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
  //List of Categories
  List<String> categories = ['Mystery' , 'Self-help' , 'Fiction' , 'Horror'];

  //List of Conditions
  List<String> conditions = ['New', 'Like New', 'Used-Good', 'Used-Acceptable'];

  @override
  Widget build(BuildContext context) {
    // Collect the updated data from the text controllers and dropdown
    Map<String, dynamic> updatedData = {
      'title': titleController.text,
      'author': authorController.text,
      'price': priceController.text,
      'pages': pagesController.text,
      'language': languageController.text,
      'description': descriptionController.text,
      'category': selectedCategory,
      'condition': selectedCondition,
      'imageUrl': imagePath, // You can store the updated image path/URL if needed
    };
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
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: yellow,
                      checkColor: blue, value: isChecked,
                      onChanged: (newValue) async {
                        setState(() {
                          isChecked = newValue!;
                        });
                        if (isChecked) {
                          await _getCurrentLocation();
                        }
                      },
                    ),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: yellow),
                        onPressed: () {

                          // Call the method to update the book
                          _updatePosts(widget.bookID, updatedData);
                        },
                        child: Text("Update", style: TextStyle(color: blue),),
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
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ]
      ),
    );
  }
}