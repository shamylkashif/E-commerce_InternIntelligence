import 'dart:io';

import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/complain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyChat extends StatefulWidget {
  final String receiverId;
  final String name;
  final String profileImage;

  const MyChat({
    super.key,
    required this.receiverId,
    required this.name,
    required this.profileImage,
  });

  @override
  State<MyChat> createState() => _MyChatState();
}

class _MyChatState extends State<MyChat> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUID = FirebaseAuth.instance.currentUser!.uid;
  File? _imageFile;

  // Generate a consistent chat room ID
  String get chatRoomId {
    return (currentUID.compareTo(widget.receiverId) < 0)
        ? currentUID + widget.receiverId
        : widget.receiverId + currentUID;
  }

  // Function to check if the user is blocked
  Future<bool> _isBlocked() async {
    final userDoc = await FirebaseFirestore.instance.collection('UsersBookStore').doc(currentUID).get();
    final blockedUsers = userDoc.data()?['blockedUsers'] ?? [];
    return blockedUsers.contains(widget.receiverId);
  }

  // Function to block the user
  Future<void> _blockUser() async {
    FirebaseFirestore.instance.collection('UsersBookStore').doc(currentUID).update({
      'blockedUsers': FieldValue.arrayUnion([widget.receiverId]),
    });
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Blocked ${widget.name}')),
    );
  }

  // Function to unblock the user
  Future<void> _unblockUser() async {
    FirebaseFirestore.instance.collection('UsersBookStore').doc(currentUID).update({
      'blockedUsers': FieldValue.arrayRemove([widget.receiverId]),
    });
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unblocked ${widget.name}')),
    );
  }

  // Function to clear chat
  void _clearChat() async {
    final chatRoomRef = FirebaseFirestore.instance.collection('chatRoom');
    final messagesRef = chatRoomRef
        .doc(chatRoomId)
        .collection('messages');

    // Delete all messages in the chat
    var batch = FirebaseFirestore.instance.batch();
    var querySnapshot = await messagesRef.get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chat cleared')),
    );
  }

  // Function to report user
  void _reportUser() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Complaint()));
    print('Reported user: ${widget.name}');
    // You can send this info to an admin or store it in Firestore for monitoring
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('chat_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get image URL after upload
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Send image URL as message in Firestore
      _sendMessage(imageUrl, isImage: true);
    }
  }

  Future<void> _sendMessage(String message, {bool isImage = false}) async {
    final chatRoomRef = FirebaseFirestore.instance.collection('chatRoom');

    // Check if the chat room document already exists
    final docSnapshot = await chatRoomRef.doc(chatRoomId).get();

    // If the chat room doesn't exist, create it
    if (!docSnapshot.exists) {
      await chatRoomRef.doc(chatRoomId).set({
        'sender': currentUID,
        'receiver': widget.receiverId, // Replace with actual receiver ID
        'createdOn': FieldValue.serverTimestamp(),
        'latestMessage': message, // Initial message

      });
    }

    // Get reference to the 'messages' subcollection inside the chat room document
    final messagesRef = chatRoomRef
        .doc(chatRoomId)
        .collection('messages');

    // Create the message object
    final newMessage = {
      'senderId': currentUID,
      'message': message,
      'isImage': isImage, // Add flag to distinguish between text and image messages
      'createdOn': FieldValue.serverTimestamp(),
    };

    // Add the message to the 'messages' subcollection
    await messagesRef.add(newMessage);

    // Optionally, update the latest message in the chatRoom document
    await chatRoomRef.doc(chatRoomId).set(
      {
        'latestMessage': message, // Update the latest message
        'lastUpdated': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true), // Merge fields to prevent overwriting
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: blue,
        elevation: 10,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_circle_left_outlined, color: Colors.white),
        ),
        title: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.profileImage),
          ),
          title: Text(
            widget.name,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          subtitle: const Text(
            'Online',
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
        ),
        actions: [
          FutureBuilder<bool>(
            future: _isBlocked(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final isBlocked = snapshot.data ?? false;
              return PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'Block') {
                    _blockUser();
                  } else if (value == 'Unblock') {
                    _unblockUser();
                  } else if (value == 'Report') {
                    _reportUser();
                  } else if (value == 'Clear Chat') {
                    _clearChat();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Report',
                      child: Text('Report'),
                    ),
                    PopupMenuItem<String>(
                      value: isBlocked ? 'Unblock' : 'Block',
                      child: Text(isBlocked ? 'Unblock' : 'Block'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Clear Chat',
                      child: Text('Clear chat'),
                    ),
                  ];
                },
                icon: const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: _isBlocked(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final isBlocked = snapshot.data ?? false;

          return Column(
            children: [
              // Display chat messages if not blocked
              if (!isBlocked)
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatRoom')
                        .doc(chatRoomId)
                        .collection('messages')
                        .orderBy('createdOn', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No messages yet.'));
                      }

                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final messageText = message['message'];
                          final senderId = message['senderId'];
                          final isImage = message['isImage'] ?? false;
                          final Timestamp timestamp = message['createdOn']?? Timestamp.now();
                          final DateTime dateTime = timestamp.toDate();
                          final timeString = DateFormat('hh:mm a').format(dateTime);

                          return ListTile(
                            title: Align(
                              alignment: senderId == currentUID ? Alignment.centerRight : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: senderId == currentUID
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: senderId == currentUID ? blue : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: isImage
                                        ? Image.network(
                                      messageText,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    )
                                        : Text(
                                      messageText,
                                      style: TextStyle(
                                        color: senderId == currentUID ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    timeString,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )

                )
              else
                const Center(child: Text('You have blocked this user.')),
              // Message input area
              if (!isBlocked)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {_pickImage(ImageSource.camera);},
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () { _pickImage(ImageSource.gallery);},
                        icon: const Icon(
                          Icons.photo,
                          color: blue,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message here',
                            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            _sendMessage(_messageController.text);
                            _messageController.clear();
                          }
                        },
                        icon: const Icon(
                          Icons.send_outlined,
                          color: blue,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
