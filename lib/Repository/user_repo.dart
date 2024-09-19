import 'package:bookstore/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../loaders.dart';

class FirestoreController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithFirebaseAuth(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Error signing in with Firebase Authentication: $e');
      return false;
    }
  }

  Future<bool> signUp(BuildContext context, BookStoreUser bookstoreuser) async {
    if (bookstoreuser.email.isEmpty || bookstoreuser.password.isEmpty) {
      SnackbarHelper.show(context, 'Email and password cannot be empty.', backgroundColor: Colors.red);
      return false;
    }

    try {
      bool registeredInAuth = await registerUser(bookstoreuser.email, bookstoreuser.password);

      if (registeredInAuth) {
        User? user = _auth.currentUser;
        if (user != null) {
          bookstoreuser.uid = user.uid;

          await _db.collection("UsersBookStore").doc(user.uid).set(bookstoreuser.toJson());
          return true;
        }
      } else {
        SnackbarHelper.show(context, 'Failed to create account. Please try again.', backgroundColor: Colors.red);
      }
    } catch (error) {
      SnackbarHelper.show(context, 'Something went wrong. Please try again.', backgroundColor: Colors.red);
    }
    return false;
  }

  Future<bool> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Error registering user in Firebase Authentication: $e');
      return false;
    }
  }

  Future<bool> checkAccountExists(BuildContext context, String email) async {
    try {
      final emailQuery = await _db
          .collection('UsersBookStore')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        SnackbarHelper.show(context, 'Email already exists. Please login or try another email.', backgroundColor: Colors.red);
        return true;
      }
      return false;
    } catch (error) {
      print('Error checking account existence: $error');
      return false;
    }
  }

}
