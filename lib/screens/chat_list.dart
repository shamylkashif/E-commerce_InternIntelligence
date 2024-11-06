import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/my_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPreviewScreen extends StatefulWidget {
  const ChatPreviewScreen({super.key});

  @override
  State<ChatPreviewScreen> createState() => _ChatPreviewScreenState();
}

class _ChatPreviewScreenState extends State<ChatPreviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  final String currentUID = FirebaseAuth.instance.currentUser!.uid;
  String searchQuery = '';


  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  // Fetch users from Firestore based on the search query
  Future<void> _fetchUsers([String query = '']) async {
    QuerySnapshot usersSnapshot;

    if (query.isEmpty) {
      usersSnapshot = await FirebaseFirestore.instance.collection('UsersBookStore').get();
    } else {
      usersSnapshot = await FirebaseFirestore.instance
          .collection('UsersBookStore')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff') // Allows for range search
          .get();
    }

    final users = usersSnapshot.docs.map((doc) {
      return {
        "id": doc.id ?? '',
        "name": doc['name'] ?? 'Unknown',
        "profileImage": doc['profileImage'] ?? 'assets/images/profile_placeholder.png',
        "lastMessage": '', // Placeholder, will be updated in MyChat
        "time": '', // Placeholder, will be updated in MyChat
        "isOnline": doc['isOnline'] ?? false,
      };
    }).where((user) => user['id'] != currentUID).toList();

    setState(() {
      allUsers = users;
      filteredUsers = users; // Reset filtered users
    });
  }

  // Search and filter function
  void _onSearchChanged() {
    final query = _searchController.text;
    _fetchUsers(query); // Fetch users based on the current query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Bar
          Container(
            color: blue,
            padding: EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.white),
                ),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      onChanged: (value) {
                        _fetchUsers(value); // Directly fetch users on text change
                      },
                     controller: _searchController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: blue),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: blue),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat List
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(child: Text('No users found', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final chat = filteredUsers[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ChatPreviewTile(
                      receiverId: chat['uid'], // Use uid for the receiverId
                      name: chat['name'],
                      profileImage: chat['profileImage'],
                      lastMessage: chat['lastMessage'],
                      time: chat['time'],
                      isOnline: chat['isOnline'],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPreviewTile extends StatelessWidget {
  final String receiverId;
  final String name;
  final String profileImage;
  final String lastMessage;
  final String time;
  final bool isOnline;

  const ChatPreviewTile({
    super.key,
    required this.receiverId,
    required this.name,
    required this.profileImage,
    this.lastMessage = '',
    this.time = '',
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImage),
            radius: 25,
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyChat(
              receiverId: receiverId,
              receiverName: name,
              receiverProfileImage: profileImage,
            ),
          ),
        );
      },
    );
  }
}
