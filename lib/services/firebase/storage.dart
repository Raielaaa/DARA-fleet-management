import 'dart:io';

import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadSelectedFile(String filePath, BuildContext context) async {
    // Check if the file path is not null or empty
    if (filePath.isNotEmpty) {
      File file = File(filePath);

      try {
        // Extract the file name from the file path
        String fileName = file.uri.pathSegments.last;

        // Get a reference to Firebase Storage for the target path
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("rent_documents_upload/${FirebaseAuth.instance.currentUser!.uid}/$fileName");

        // Start the file upload
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;

        // Show success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File uploaded successfully: $fileName")),
        );
      } catch (e) {
        // Handle any errors during the file upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
      }
    } else {
      debugPrint("Invalid file path. Please select a valid file.");
    }
  }

  Future<void> deleteFile(String filePath) async {
    // Check if the file path is valid
    if (!isValidFilePath(filePath)) {
      debugPrint("Invalid file path: $filePath");
      return; // Exit the function if the path is invalid
    }

    // Create a reference to the file you want to delete
    Reference fileRef = FirebaseStorage.instance.refFromURL(filePath);

    try {
      // Delete the file
      await fileRef.delete();
      debugPrint("File deleted successfully");
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      if (e.code == 'object-not-found') {
        debugPrint("File not found: ${e.message}");
      } else if (e.code == 'permission-denied') {
        debugPrint("Permission denied: ${e.message}");
      } else {
        debugPrint("Error occurred while deleting file: ${e.message}");
      }
    } catch (e) {
      // Handle any other exceptions
      debugPrint("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Function to check if the file path is valid
  bool isValidFilePath(String filePath) {
    return filePath.startsWith('gs://') && filePath.split('/').length > 3; // Adjust logic as needed
  }


  Future<List<String>> getUserFiles() async {
    List<String> filePaths = [];

    try {
      // Reference to the folder where your files are stored
      final ListResult result = await _storage
          .ref("${FirebaseConstants.rentDocumentsUpload}/${FirebaseAuth.instance.currentUser?.uid}")
          .listAll();

      // Iterate through each item and get the full path of the file
      for (var ref in result.items) {
        // Get the full path of the file
        String fullPath = ref.fullPath;

        // Format it to include the `gs://` prefix and your Firebase bucket name
        String storageLocation = 'gs://${_storage.bucket}/$fullPath';

        // Add the storage location to the list
        filePaths.add(storageLocation);
      }
    } catch (e) {
      debugPrint("Error listing files: $e");
    }

    return filePaths;
  }
}
