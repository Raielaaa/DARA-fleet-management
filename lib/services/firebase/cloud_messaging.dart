import "package:cloud_firestore/cloud_firestore.dart";
// import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
class FirebaseCloudMessaging {
  static Future<void> saveAdminDeviceToken(String userId) async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // String? token = await messaging.getToken();
    //
    // if (token != null) {
    //   await FirebaseFirestore.instance.collection("adminTokens")
    //       .doc(userId)
    //       .set({
    //     "deviceToken" : token,
    //     "lastLogin" : DateTime.now().toUtc()
    //   }, SetOptions(merge: true));
    // } else {
    //   debugPrint("Token is null");
    // }
  }
}