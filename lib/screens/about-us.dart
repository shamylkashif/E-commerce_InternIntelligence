import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../commons/colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom AppBar
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 80, left: 15),
                  child: Icon(Icons.arrow_circle_left_outlined, color: blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80, left: 95),
                child: Text(
                  'About us',
                  style: TextStyle(color: blue, fontSize: 24),
                ),
              ),
            ],
          ),


          // Main content below the AppBar
          Padding(
            padding: const EdgeInsets.only(top: 130), // Adjust this to match the height of your AppBar
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10), // Space above the text
                  child: Text(
                    'Welcome to our book exchange platform, where we make it easy for book lovers to buy, sell, and donate used books. '
                        'Our mission is to create a community-driven space where readers can connect, share, and discover new stories. '
                        'With simple ad posting, in-app messaging, and AI support for recommendations, we bring convenience and joy to the world of book exchanges. '
                        'Join us in promoting a sustainable reading culture and give your books a second life today!',
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Contact us', style: TextStyle(color: blue, fontSize: 24)),
                ),
                SizedBox(height: 15),
                Container(
                  height: 60,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.email, color: blue, size: 25)),
                      IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.linkedinIn, color: Colors.blue, size: 25)),
                      IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.purple, size: 25)),
                      IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.twitter, color: Colors.blue, size: 25)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
