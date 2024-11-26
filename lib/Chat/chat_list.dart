import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/Chat/my_chat.dart';

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

  // Fetch all users once and store in allUsers
  Future<void> _fetchUsers() async {
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
        .collection('UsersBookStore')
        .get();


    final users = usersSnapshot.docs.map((doc) {
      return {
        "id": doc['uid'] ?? 'Unknown uid',
        "name": doc['name'] ?? 'Unknown',
        "profileImage": doc['profileImage'] ?? 'assets/images/profile_placeholder.png',
      };
    }).where((user) => user['id'] != currentUID).toList();

    setState(() {
      allUsers = users;
      filteredUsers = users;
    });
  }
  

  // Search and filter function
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers
          .where((user) => user['name'].toLowerCase().contains(query))
          .toList();
    });
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
            padding: const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white),
                ),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: TextFormField(
                      controller: _searchController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: "Search",
                        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
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
                ? const Center(child: Text('No users found', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final chat = filteredUsers[index];
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric( horizontal: 8.0, ), // Reduced vertical padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: ChatPreviewTile(
                        receiverId: chat['id'],
                        name: chat['name'],
                        profileImage: chat['profileImage'],
                        latestMessage: chat['latestMessage']??"",
                        lastUpdatedTime: chat['lastUpdatedTime']??"",
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyChat(
                                  receiverId: chat['id'],
                                  name: chat['name'],
                                  profileImage:chat['profileImage']),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                  ],
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
  final VoidCallback onTap;
  final String latestMessage;
  final String lastUpdatedTime;

  const ChatPreviewTile({
    super.key,
    required this.receiverId,
    required this.name,
    required this.profileImage,
    required this.onTap,
    required this.latestMessage,
    required this.lastUpdatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
        radius: 25,
      ),
      title: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        latestMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black ,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lastUpdatedTime,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

        ],
      ),
      onTap: onTap,
    );
  }
}
