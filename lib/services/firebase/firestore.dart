import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/model/account/register_model.dart';
import 'package:dara_app/model/account/user_role.dart';
import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:dara_app/model/home/featured_car_info.dart';
import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/view/shared/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../../model/accountant/accountant.dart';
import '../../model/car_list/complete_car_list.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> addReport({
    required String documentName,
    required Map<String, String> data
  }) async {
    await _firestore
    .collection(FirebaseConstants.userReportCollection)
    .doc(documentName)
    .set(data);
  }

  Future<void> addOutsourceApplicationInfo({
    required String collectionName,
    required String documentName,
    required Map<String, String> data
  }) async {
    await _firestore
      .collection(collectionName)
      .doc(documentName)
      .set(data);
  }

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

  Future<void> updateUserPhoneNumber(String userId, String newPhoneNumber) async {
    debugPrint("userUID: ${PersistentData().uidForPhoneVerification}");
    DocumentReference userDoc = _firestore.collection(FirebaseConstants.registerCollection).doc(FirebaseAuth.instance.currentUser?.uid);

    try {
      await userDoc.update({
        "user_number" : newPhoneNumber
      });
      debugPrint("User phone number updated successfully");
    } catch(e) {
      debugPrint("Error updating user phone number: $e");
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

  Future<CompleteCarInfo> getSelectedCarInformation({
    required String carName
  }) async {
    QuerySnapshot querySnapshot = await _firestore.collection(FirebaseConstants.carInfoCollection).where("car_name", isEqualTo: carName).get();
    return querySnapshot.docs
        .map((doc) => CompleteCarInfo.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList()
        .first;
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


  Future<List<RentInformation>> getRentRecordsInfo(String currentUserUID) async {
    // Fetch all documents from the collection
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseConstants.rentRecordsCollection)
        .get();

    // Filter documents where the document ID starts with the currentUserUID
    List<QueryDocumentSnapshot> filteredDocs = querySnapshot.docs.where((doc) {
      // Check if the document ID starts with the current user's UID followed by a space and a hyphen
      return doc.id.startsWith('$currentUserUID');
    }).toList();

    // Convert filtered documents into RentInformation objects
    return filteredDocs.map((doc) {
      return RentInformation.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }
  
  Future<List<RentInformation>> getRentInformationForProfile(String currentUserUID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseConstants.rentRecordsCollection)
        .where("rent_renterUID", isEqualTo: currentUserUID)
        .get();

    return querySnapshot.docs.map((doc) => RentInformation.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<RentInformation>> getRentRecords() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseConstants.rentRecordsCollection)
        .get();

    return querySnapshot.docs.map((doc) => RentInformation.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<List<RentInformation>> getSelectedRecordsInfo(String startDate, String endDate, String location) async {
    // Fetch all documents from the collection with location filtering
    QuerySnapshot querySnapshot = await _firestore
        .collection(FirebaseConstants.rentRecordsCollection)
        .where("rent_rentLocation", isEqualTo: location)
        .get();

    // Filter documents locally based on startDateTime and endDateTime
    List<QueryDocumentSnapshot> filteredDocs = querySnapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>;

      // Compare startDateTime and endDateTime (currently stored as strings)
      String docStartDate = data["rent_startDateTime"];
      String docEndDate = data["rent_endDateTime"];

      return docStartDate == startDate && docEndDate == endDate;
    }).toList();

    // Convert filtered documents into RentInformation objects
    return filteredDocs.map((doc) {
      return RentInformation.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<void> updateRenterAndCarUnitRecords({
    required RentInformation rentInformation,
    required Map<String, String> data
  }) async {
    DocumentSnapshot snapshot = await _firestore.collection(FirebaseConstants.carInfoCollection).doc(rentInformation.rent_car_UID).get();
    DocumentSnapshot renterSnapshot = await _firestore.collection(FirebaseConstants.registerCollection).doc(rentInformation.renterUID).get();

    try {
      //  update car status
      await _firestore.collection(FirebaseConstants.carInfoCollection)
          .doc(rentInformation.rent_car_UID)
          .update({
        "car_rent_count": (int.parse(snapshot.get("car_rent_count")) + 1).toString(),
        "car_total_earnings": (double.parse(snapshot.get("car_total_earnings")) + double.parse(rentInformation.totalAmount)).toString(),
        "car_availability": "unavailable"
      });
      debugPrint("firestore.dart@ln197 - checkpoint_1");

      //  update rent inquiry status
      await updateRentStatus(
        carUID: rentInformation.rent_car_UID,
        estimatedDrivingDistance: rentInformation.estimatedDrivingDistance,
        startDateTime: rentInformation.startDateTime,
        endDateTime: rentInformation.endDateTime,
        newStatus: "approved"
      );
      debugPrint("firestore.dart@ln197 - checkpoint_2");


      // Retrieve the user_total_amount_spent value
      var totalAmountSpent = renterSnapshot.get("user_total_amount_spent");

      // Check if the retrieved value is null or an empty string
      if (totalAmountSpent == null || totalAmountSpent.isEmpty) {
        totalAmountSpent = '0.0'; // Default value if empty or null
      }

      // Update user total amount spent
      await _firestore.collection(FirebaseConstants.registerCollection)
          .doc(rentInformation.renterUID)
          .update({
        "user_total_amount_spent": (double.parse(totalAmountSpent) + double.parse(rentInformation.totalAmount)).toString()
      });
      debugPrint("firestore.dart@ln197 - checkpoint_3");

      //  add rent records to accountant
      await _firestore.collection(FirebaseConstants.accountantCollection).add(data);
      debugPrint("firestore.dart@ln197 - checkpoint_4");
    } catch(e) {
      debugPrint("An error occurred@firestore.dart@ln219: $e");
    }
  }

  Future<List<RentInformation>> getAccountantRecords() async {
    QuerySnapshot _querySnapshot = await _firestore
        .collection(FirebaseConstants.accountantCollection)
        .get();

    return _querySnapshot.docs.map((doc) => RentInformation.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> updateRentStatus({
    required String carUID,
    required String estimatedDrivingDistance,
    required String startDateTime,
    required String endDateTime,
    required String newStatus,
  }) async {
    try {
      // Query Firestore to find the document based on the provided filters
      QuerySnapshot querySnapshot = await _firestore
          .collection(FirebaseConstants.rentRecordsCollection)
          .where("rent_car_UID", isEqualTo: carUID)
          .where("rent_estimatedDrivingDistance", isEqualTo: estimatedDrivingDistance)
          .where("rent_startDateTime", isEqualTo: startDateTime)
          .where("rent_endDateTime", isEqualTo: endDateTime)
          .get();

      // If a matching document is found, update its "rent_status" field
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          await doc.reference.update({"rent_status": newStatus});
          debugPrint("Rent status updated for document: ${doc.id}");
        }
      } else {
        debugPrint("No matching rent record found.");
      }
    } catch (e) {
      debugPrint("Error updating rent status: $e");
    }
  }
}