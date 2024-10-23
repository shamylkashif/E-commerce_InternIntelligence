import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:flutter/services.dart';


class PostAD extends StatefulWidget {
  const PostAD({super.key});

  @override
  State<PostAD> createState() => _PostADState();
}

class _PostADState extends State<PostAD> {
  String? selectedCondition;
  String? selectedCategory;
  bool isChecked = false;

  //List of Categories
  List<String> categories = ['All Genre' , 'Comedy' , 'Fiction' , 'Horror'];

  //List of Conditions
  List<String> conditions = ['New', 'Like New', 'Used-Good', 'Used-Acceptable'];

  //Text Controllers for form fields
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> _saveData() async {
    //Create map to save data
    Map<String, dynamic> bookData = {
      'category': selectedCategory,
      'title': titleController.text,
      'author': authorController.text,
      'price': priceController.text,
      'pages': pagesController.text,
      'language': languageController.text,
      'description': descriptionController.text,
      'condition': selectedCondition ?? '',
      'useLocation': isChecked,
    };
    try {
      // Add data to firebase
      await FirebaseFirestore.instance.collection('books').add(bookData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book Details saved Successfully'),
          backgroundColor: Colors.green[700],),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save book details: $e'),
          backgroundColor: Colors.red,),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                        // Add images functionality
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
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
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
                  title:Text('Use my current Location', style: TextStyle(color: blue),),
                  value: isChecked,
                  onChanged: (bool? value){
                    setState(() {
                      isChecked = value!;
                    });
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
                    // Next button functionality
                  },
                  child: Text("Save", style: TextStyle(color: blue),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
