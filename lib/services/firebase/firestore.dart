import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:flutter/material.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserInfo({
    required String collectionName,
    required String documentName,
    required Map<String, String> data,
  }) async {
    await _firestore
    .collection(collectionName)
    .doc(documentName)
    .set(data);
  }

  Future<void> updateUserDataRegister(String userId, String newStatus, String newNumber) async {
    DocumentReference userDoc = _firestore.collection(FirebaseConstants.registerCollection)
        .doc(userId);

    try {
      await userDoc.update({
        "user_status": newStatus,
        "user_number": newNumber
      });
      debugPrint('User data updated successfully');
    } catch(e) {
      debugPrint('Error updating user data: $e');
    }
  }
}