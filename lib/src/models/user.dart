import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final Map<String, String> address;
  final int? age;
  final String bloodType;
  final String allergies;
  final String? profileImageUrl;
  final DateTime? lastUpdated;
  final String role;

  User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone = '',
    Map<String, String>? address,
    this.age,
    this.bloodType = '',
    this.allergies = '',
    this.profileImageUrl,
    this.lastUpdated,
    this.role = 'patient',
  }) : address = {
    'street': '',
    'city': '',
    'state': '',
    'postalCode': '',
    ...?address,
  };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      phone: map['phone'] ?? '',
      address: Map<String, String>.from(map['address'] ?? {}).map(
            (key, value) => MapEntry(key, value ?? ''),
      ),
      age: map['age'],
      bloodType: map['bloodType'],
      allergies: map['allergies'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate(),
      role: map['role'] ?? 'patient',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'age': age,
      'bloodType': bloodType,
      'allergies': allergies,
      'profileImageUrl': profileImageUrl,
      'lastUpdated': lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'role': role,
    };
  }
}

