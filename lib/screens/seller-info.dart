import 'package:bookstore/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../commons/colors.dart';


class SellerInformation extends StatefulWidget {
  const SellerInformation({super.key});

  @override
  State<SellerInformation> createState() => _SellerInformationState();
}

class _SellerInformationState extends State<SellerInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 500,
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 5,),
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset('assets/p.jpg',
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  )
                  ),
                title: Text('Shamyl Kashif',
                  style: TextStyle(fontSize: 18),),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red, size: 24,),
                    SizedBox(width: 5,),
                    Text('Sargodha, Pakistan'),
                  ],
                ),
                ),
              Divider(
                indent: 15,
                endIndent: 15,
              ),

               Padding(
                 padding: const EdgeInsets.only(right: 155,top: 10),
                 child: Text('Terms And Conditions', style: TextStyle(fontWeight: FontWeight.bold),),
               ),
                _buildBullet('Be repectful and professional'),
                _buildBullet('Provide clear and honest infoemation'),
                _buildBullet('Negotiate Friendly'),
              Padding(
                padding: const EdgeInsets.only(right: 80,top: 15),
                child: Text('Tap Below to view Seller Location', style:TextStyle(fontWeight: FontWeight.bold) ,),
              ),
              SizedBox(height: 15,),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0), // Example for rounded corners
                child: Container(
                  height: 130,
                  width: 350, // Set the desired width here
                  child: Image.asset(
                    'assets/images.jpeg',
                    fit: BoxFit.cover, // Adjust fit as needed
                  ),
                ),
              ),
              SizedBox(height: 15,),
              SizedBox(
                width: 350,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(backgroundColor: yellow),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPreviewScreen()));
                  },
                  child: Text("Contact Seller", style: TextStyle(color: blue),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _buildBullet(String text){
  return ListTile(
    dense: true,
    visualDensity: VisualDensity(vertical: -4),
    minLeadingWidth: 0,
    leading: FaIcon(FontAwesomeIcons.circle, size: 8,),
    title: Text(text),
  );
}
