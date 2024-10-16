import 'package:dara_app/services/firebase/firestore.dart';
import 'package:flutter/material.dart';

import '../../../model/renting_proccess/renting_process.dart';

class InquiriesController {
  Future<void> updateDB(
      RentInformation rentInformation,
      Map<String, String> data
  ) async {
    try {
      await Firestore().updateRenterAndCarUnitRecords(
        rentInformation: rentInformation,
        data: data,
      );
    } catch(e) {
      debugPrint("An error occurred@inquiries.dart@ln8: $e");
    }
  }
}