import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dara_app/model/account/register_model.dart';
import 'package:dara_app/model/account/user_role.dart';
import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:dara_app/model/home/featured_car_info.dart';
import 'package:flutter/material.dart';

import '../../model/car_list/complete_car_list.dart';

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

  Future<void> addRentRecords({
    required String collectionName,
    required String documentName,
    required Map<String, String> data
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

  Future<List<FeaturedCarInfo>> getCars() async {
    QuerySnapshot querySnapshot = await _firestore.collection(FirebaseConstants.carInfoCollection).get();
    return querySnapshot.docs
        .map((doc) => FeaturedCarInfo.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<CompleteCarInfo>> getCompleteCars() async {
    QuerySnapshot querySnapshot = await _firestore.collection(FirebaseConstants.carInfoCollection).get();
    return querySnapshot.docs
        .map((doc) => CompleteCarInfo.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserRoleLocal>> getUserRoleInfo() async {
    QuerySnapshot querySnapshot = await _firestore.collection(FirebaseConstants.registerRoleCollection).get();
    return querySnapshot.docs
        .map((doc) => UserRoleLocal.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<RegisterModel?> getUserInfo(String currentUserUID) async {
    // Fetch the specific document using the UID as the document ID
    DocumentSnapshot docSnapshot = await _firestore
        .collection(FirebaseConstants.registerCollection)
        .doc(currentUserUID) // Use UID to get the document
        .get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Parse the data and return a RegisterModel
      return RegisterModel.fromFirestore(docSnapshot.data() as Map<String, dynamic>);
    }

    // Return null if no data is found or user is not logged in
    return null;
  }
}