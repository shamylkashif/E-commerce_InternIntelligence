import 'package:flutter/material.dart';
import 'package:bookstore/commons/colors.dart';


class PostAD extends StatefulWidget {
  const PostAD({super.key});

  @override
  State<PostAD> createState() => _PostADState();
}

class _PostADState extends State<PostAD> {
  String? conditionValue;
  String? selectedCategory;

  //List of Categories
  List<String> categories = ['All Genre' , 'Comedy' , 'Fiction' , 'Horror'];

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
              Row(
                children: [
                  ChoiceChip(
                    label: Text("GOOD"),
                    selected: conditionValue == "GOOD",
                    onSelected: (selected) {
                      setState(() {
                        conditionValue = selected ? "GOOD" : null;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  ChoiceChip(
                    label: Text("SATISFACTORY"),
                    selected: conditionValue == "SATISFACTORY",
                    onSelected: (selected) {
                      setState(() {
                        conditionValue = selected ? "SATISFACTORY" : null;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: yellow),
                  onPressed: () {
                    // Next button functionality
                  },
                  child: Text("Next", style: TextStyle(color: blue),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
