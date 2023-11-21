import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DBService {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  Future<void> addTask({
    required String taskName,
    required String taskDesc,
    required String taskTag,
  }) async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    DocumentReference docRef =
        await firebase.collection('tasks').doc(uid).collection('mytasks').add({
      'taskName': taskName,
      'taskDesc': taskDesc,
      'taskTag': taskTag,
    });
    String taskId = docRef.id;
    await firebase
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(taskId)
        .update({'id': taskId});
  }

  Future<void> deleteTask({
    required String taskId,
  }) async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    await firebase
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(taskId)
        .delete();
  }

  Future<void> updateTask({
    required String taskId,
    required String taskName,
    required String taskDesc,
    required String taskTag,
  }) async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    await firebase
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(taskId)
        .update({
      'taskName': taskName,
      'taskDesc': taskDesc,
      'taskTag': taskTag,
    });
  }

  Future<Map<String, dynamic>> getUser() async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    DocumentSnapshot doc = await firebase.collection('users').doc(uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return data;
  }

  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phoneNumber,
    required String city,
    required String pinCode,
  }) async {
    User? user = auth.currentUser;
    String? uid = user?.uid;
    firebase.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'city': city,
      'pinCode': pinCode,
    });
  }
}
