import 'package:cloud_firestore/cloud_firestore.dart';

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
}