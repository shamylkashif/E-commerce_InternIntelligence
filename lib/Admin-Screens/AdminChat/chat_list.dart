import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/Chat/my_chat.dart';

class AdminChatList extends StatefulWidget {
  const AdminChatList({super.key});

  @override
  State<AdminChatList> createState() => _AdminChatListState();
}

class _AdminChatListState extends State<AdminChatList> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  final String currentUID = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
    QuerySnapshot usersSnapshot = await _firestore.collection('UsersBookStore').get();

    final users = await Future.wait(usersSnapshot.docs.map((doc) async {
      final userId = doc['uid'] ?? 'Unknown uid';
      if (userId == currentUID) return null;

      // Fetch the chat room metadata based on sender or receiver match
      final chatRoomQuery = await _firestore
          .collection('chatRoom')
          .where('sender', isEqualTo: currentUID)
          .where('receiver', isEqualTo: userId)
          .get();

      final reverseChatRoomQuery = await _firestore
          .collection('chatRoom')
          .where('sender', isEqualTo: userId)
          .where('receiver', isEqualTo: currentUID)
          .get();

      String lastMessage = '';
      Timestamp? lastUpdated;

      if (chatRoomQuery.docs.isNotEmpty) {
        final chatRoom = chatRoomQuery.docs.first;
        lastMessage = chatRoom['latestMessage'] ?? '';
        lastUpdated = chatRoom['lastUpdated'];
      } else if (reverseChatRoomQuery.docs.isNotEmpty) {
        final chatRoom = reverseChatRoomQuery.docs.first;
        lastMessage = chatRoom['latestMessage'] ?? '';
        lastUpdated = chatRoom['lastUpdated'];
      }

      return {
        "id": userId,
        "name": doc['name'] ?? 'Unknown',
        "profileImage": doc['profileImage'] ?? 'assets/images/profile_placeholder.png',
        "lastMessage": lastMessage,
        "lastUpdated": lastUpdated,
      };
    }).toList());

    setState(() {
      allUsers = users.where((user) => user != null).cast<Map<String, dynamic>>().toList();
      filteredUsers = allUsers;
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
                    ChatPreviewTile(
                      receiverId: chat['id'],
                      name: chat['name'],
                      profileImage: chat['profileImage'],
                      lastMessage: chat['lastMessage'] ?? '',
                      lastUpdated: chat['lastUpdated'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyChat(
                              receiverId: chat['id'],
                              name: chat['name'],
                              profileImage: chat['profileImage'],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            )
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
  final Timestamp? lastUpdated;
  final VoidCallback onTap;

  const ChatPreviewTile({
    super.key,
    required this.receiverId,
    required this.name,
    required this.profileImage,
    required this.lastMessage,
    this.lastUpdated,
    required this.onTap,
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          if (lastUpdated != null)
            Text(
              _formatTimestamp(lastUpdated!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour % 12 == 0 ? 12 : hour % 12;  // Convert 24-hour format to 12-hour
    final formattedMinute = minute.toString().padLeft(2, '0');  // Add leading zero for minutes if needed
    return "$formattedHour:$formattedMinute $amPm";
  }

}
