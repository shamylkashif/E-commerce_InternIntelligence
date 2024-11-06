import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {

  TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;

  String? selectedCategory;
  List<String> complaintCategories = [
    'All Issues',
    'Technical Issue',
    'User Experience',
    'Privacy & Security',
    'Product Feedback',
    'Community Guidelines Violation',
    'Other'
  ];
  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = selectedCategory != null && _controller.text.isNotEmpty;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitComplaint() async {
    // Example email address
    String email = "shamylkashif0205@gmail.com";

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent('Complaint about ${selectedCategory!}')}&body=${Uri.encodeComponent(_controller.text)}',
    );

    try {
      if (await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
        _controller.clear();
        setState(() {
          selectedCategory = null;
          isButtonEnabled = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email has been sent.')),
        );
      } else {
        _showErrorDialog("Could not launch the email client.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      leading: InkWell(
         onTap: (){
           Navigator.pop(context);
         },
          child: Icon(Icons.arrow_circle_left_outlined, color: blue,)),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text('Leave us a feedback', style: TextStyle(color: Colors.black,fontSize: 20),),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
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
                  items: complaintCategories.map((String category)
                  {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }
                  ).toList(),
                  onChanged: (newValue) { setState(() {
                    selectedCategory = newValue;
                    isButtonEnabled = _controller.text.isNotEmpty && selectedCategory != null;
                  });},
                  icon: Icon(Icons.arrow_drop_down, color: blue),
                  style: TextStyle(color: blue, fontSize: 16),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Container(
            margin: EdgeInsets.only(left: 20,),
            padding: EdgeInsets.only(left: 15, top: 10),
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              color: Color(0xFFE3DEA9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your feedback here',
                hintStyle: const TextStyle(color: blue,),
                contentPadding: EdgeInsets.zero
              ),
              maxLines: null,
              minLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              onChanged: (text){
                setState(() {
                  isButtonEnabled = _controller.text.isNotEmpty && selectedCategory != null;
                });
              },
            ),
          ),
          GestureDetector(
            onTap: isButtonEnabled ? _submitComplaint : null,
            child: Container(
              margin: EdgeInsets.only(top: 270,left: 20),
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: isButtonEnabled ? yellow : Colors.grey ,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child:
                  Text('Submit', style: TextStyle(color: blue,fontSize: 18),)),
            ),
          ),
        ],
      ),
    ),
         );
  }
}
