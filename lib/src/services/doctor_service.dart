import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import 'dart:convert';

class DoctorService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _generateSecurePassword() {
    final random = Random.secure();
    final values = List<int>.generate(6, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  Future<String> addDoctor({
    required String email,
    required String name,
    required String specialty,
    required String experience,
    required int price,
    required String about,
    required List<String> availableTimes,
  }) async {
    try {
      final password = 'Doctor@${DateTime.now().millisecondsSinceEpoch}';
      
      //Create auth account with generated password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Add to doctors collection
      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'specialty': specialty,
        'experience': experience,
        'about': about,
        'price': price,
        'rating': 0.0,
        'isOnline': false,
        'isActive': true,
        'availableTimes': availableTimes,
        'totalReviews': 0,
        'reviews': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Send password reset email to doctor
      await _auth.sendPasswordResetEmail(email: email);
      
      return password; // Return password untuk ditampilkan ke admin
    } catch (e) {
      throw Exception('Failed to add doctor: $e');
    }
  }
}