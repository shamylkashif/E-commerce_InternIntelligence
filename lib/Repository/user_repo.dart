import 'package:bookstore/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loaders.dart';

class FirestoreController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In Functionality
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

  // Sign Up and Save Data to Firestore
  Future<bool> signUp(BuildContext context, Users users) async {
    if (users.email.isEmpty || users.password.isEmpty) {
      SnackbarHelper.show(context, 'Email and password cannot be empty.', backgroundColor: Colors.red.shade900);
      return false;
    }

    try {
      bool registeredInAuth = await registerUser(users.email, users.password);

      if (registeredInAuth) {
        User? user = _auth.currentUser;
        if (user != null) {
          users.uid = user.uid;

          // Try saving user data to Firestore
          await _db.collection("BookStoreUsers").doc(user.uid).set(users.toJson());

          // Data saved successfully, return true
          return true;
        }
      } else {
        SnackbarHelper.show(context, 'Failed to create account. Please try again.', backgroundColor: Colors.red.shade900);
      }
    } catch (error) {
      print('Error during sign-up and Firestore save: $error');
      SnackbarHelper.show(context, 'Something went wrong. Please try again.', backgroundColor: Colors.red.shade900);
    }

    return false;
  }

  // Register the user in Firebase Auth
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

  // Check if an account with the same email exists in Firestore
  Future<bool> checkAccountExists(BuildContext context, String email) async {
    try {
      final emailQuery = await _db
          .collection('BookStoreUsers')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        SnackbarHelper.show(context, 'Email already exists. Please login or try another email.', backgroundColor: Colors.red.shade900);
        return true;
      }
      return false;
    } catch (error) {
      print('Error checking account existence: $error');
      return false;
    }
  }
}
