import 'package:bookstore/Authentication/user-login-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../commons/colors.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  Future<void> deleteAccount() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (user != null) {

        // Deleting user data from the 'UsersBookStore' collection
        await _firestore.collection('UsersBookStore').doc(user.uid).delete();

        // Delete the account from Firebase Authentication
        await user.delete();

        // Sign the user out
        await _auth.signOut();

        // Optionally navigate to a different screen (e.g., login screen)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your account has been deleted successfully.')),
        );
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmDeleteAccount() async {
    bool? confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you really want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      deleteAccount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_circle_left_outlined, color:blue),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              'After deleting your account:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text('Your account will be deleted right away permanentaly, '
                'along with all associated personal data.',
              style: TextStyle(fontSize: 16),
              maxLines: 4,
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: InkWell(
              onTap: isLoading ? null : confirmDeleteAccount,
              child: Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
