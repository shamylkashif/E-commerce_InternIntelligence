import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/Dashboards/edit-ad.dart';
import 'package:bookstore/BookDetails/post_ad.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  // Sample data for demonstration (you will fetch this from Firestore)
  List<Map<String, dynamic>> myPosts = [];
  @override
  void initState() {
    super.initState();
    fetchMyPosts();
  }

  Future<void> fetchMyPosts() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userId = currentUser.uid; // Get the current user's ID

        final querySnapshot = await FirebaseFirestore.instance
            .collection('AllBooks')
            .where('uid', isEqualTo: userId) // Filter by userId
            .get();

        final posts = querySnapshot.docs.map((doc) {
          return {
            'bookId': doc['bookID'] ?? 'Unknown Book ID',
            'bookName': doc['title'] ?? 'Unknown Book',
            'authorName': doc['author'] ?? 'Unknown Author',
            'bookImage': doc['imageUrl'] ?? '',
          };
        }).toList();

        setState(() {
          myPosts = posts;
        });
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  void deletePost(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final post = myPosts[index];
              final bookId = post['bookId'];  // The custom book ID, not Firestore document ID

              try {
                // Query Firestore to find the document with this bookId
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('AllBooks')
                    .where('bookID', isEqualTo: bookId)
                    .get();

                // If document exists, delete it
                if (querySnapshot.docs.isNotEmpty) {
                  final document = querySnapshot.docs.first;

                  // Delete the document from Firestore
                  await document.reference.delete();

                  // Remove the post from the local list
                  setState(() {
                    myPosts.removeAt(index);
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Post Deleted Successfully',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  );
                } else {
                  // Handle case where the document was not found
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Post not found in database',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
              } catch (e) {
                print("Error deleting post: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to delete post',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
        leading: IconButton(
          icon: Icon(Icons.arrow_circle_left_outlined,color: blue,),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: myPosts.isEmpty
          ? Center(child: Text('You have not uploaded any post yet!'))
          : ListView.builder(
        itemCount: myPosts.length,
        itemBuilder: (context, index) {
          final post = myPosts[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  post['bookImage'] ,// Default image if sellerImage is empty
                  height: 150,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(post['bookName'],overflow: TextOverflow.ellipsis, ),
              subtitle: Text(post['authorName'], overflow: TextOverflow.ellipsis,),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: blue,),
                    onPressed: () {
                      final bookID = post['bookId']; // Get the book ID for this post
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditPost(bookID: bookID,)));
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.delete, color: blue,),
                      onPressed: () {
                           deletePost(index);
                      }
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        foregroundColor: blue,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PostAD()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



