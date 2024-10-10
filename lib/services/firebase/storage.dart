import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> getUserFiles() async {
    List<String> filePaths = [];

    try {
      // Reference to the folder where your files are stored
      final ListResult result = await _storage
          .ref("${FirebaseConstants.rentDocumentsUpload}/${FirebaseAuth.instance.currentUser?.uid}")
          .listAll();

      // Iterate through each item and get the full path of the file
      result.items.forEach((Reference ref) {
        // Get the full path of the file
        String fullPath = ref.fullPath;

        // Format it to include the `gs://` prefix and your Firebase bucket name
        String storageLocation = 'gs://${_storage.bucket}/$fullPath';

        // Add the storage location to the list
        filePaths.add(storageLocation);
      });
    } catch (e) {
      debugPrint("Error listing files: $e");
    }

    return filePaths;
  }
}
