import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String name;
  final String email;
  final String phone;
  final String password;
  String uid;
  String? profileImage; // Optional profile image field
  String? address; // Optional address field


  Users({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.uid,
    this.profileImage,
    this.address,

  });

  // Convert Firestore data to a Patient object
  factory Users.fromFirestore(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      uid: json['uid'],
      profileImage: json['profileImage'], // Assign profile image from Firestore
      address: json['address'], // Assign address from Firestore
    );
  }

  // Convert Patient object to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'profileImage': profileImage, // Store profile image
      'address': address, // Store address

    };
  }
}

class PatientRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Users>> getAllPatients() async {
    List<Users> users = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('PatientMadLab').get();

      users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['uid'] = doc.id; // Assign document ID as UID

        return Users.fromFirestore(data);
      }).toList();

      return users;
    } catch (error) {
      print('Error fetching all patients: $error');
      return users;
    }
  }
}
