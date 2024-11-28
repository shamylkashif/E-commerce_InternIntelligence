import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class ViewUserInfo extends StatefulWidget {
  final Map<String, dynamic> user; // To hold the user data

  const ViewUserInfo({Key? key, required this.user}) : super(key: key);

  @override
  State<ViewUserInfo> createState() => _ViewUserInfoState();
}

class _ViewUserInfoState extends State<ViewUserInfo> {
  @override
  Widget build(BuildContext context) {
    // String profileImageUrl = widget.user['profileImage']??"";
    // Use the passed data here
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child:Image.network(widget.user['profileImage'] ?? '', fit: BoxFit.cover,)
                ),
              ),
              title:  Text(
                '${widget.user['name'] ?? 'N/A'}',
                style: TextStyle(fontSize: 20,),
              ),
              subtitle: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red,),
                  Text('${widget.user['address']??"N/A"}')
                ],
              ),

            ),
            Divider(),
            SizedBox(height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Email: ',
                      style: TextStyle(fontSize: 18,),
                    ),
                    TextSpan(
                      text: '${widget.user['email'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 15, color: Colors.black, backgroundColor: yellow),
                    ),
                  ],
                ),
              ),
            ),
           SizedBox(height: 10,),
            Align(
              alignment: Alignment.topLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Address: ',
                      style: TextStyle(fontSize: 18,),
                    ),
                    TextSpan(
                      text: '${widget.user['address'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 15, color: Colors.black, backgroundColor: yellow),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

