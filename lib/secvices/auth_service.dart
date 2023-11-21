import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser({required String email, required String password}) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    debugPrint(userCredential.user?.email);
  }

  Future<void> signupUser({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String city,
    required String pinCode,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    debugPrint(userCredential.user?.email);
    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'pinCode': pinCode,
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
