
import 'package:cloud_firestore/cloud_firestore.dart';

class BookStoreUser {
  final String name;
  final String email;
  final String password;
  String uid;
  String? profileImage; // Optional profile image field
  String? address; // Optional address field

  BookStoreUser({
    required this.name,
    required this.email,
    required this.password,
    required this.uid,
    this.profileImage,
    this.address,
  });

  // Convert Firestore data to a Patient object
  factory BookStoreUser.fromFirestore(Map<String, dynamic> json) {
    return BookStoreUser(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      uid: json['uid'],
      profileImage: json['profileImage'], // Assign profile image from Firestore
      address: json['address'], // Convert Firestore Timestamp to DateTime
    );
  }

  // Convert Patient object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'profileImage': profileImage, // Store profile image
      'address': address,
    };
  }
}

class BookStoreUserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<BookStoreUser>> getAllUsers() async {
    List<BookStoreUser> bookstoreuser = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('UsersBookStore').get();

      bookstoreuser = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['uid'] = doc.id; // Assign document ID as UID

        return BookStoreUser.fromFirestore(data);
      }).toList();

      return bookstoreuser;
    } catch (error) {
      print('Error fetching all users: $error');
      return bookstoreuser;
    }
  }
}
