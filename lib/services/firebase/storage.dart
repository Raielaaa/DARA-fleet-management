import 'dart:io';

import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Storage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadSelectedFile(String filePath, BuildContext context, String? employedOrBusiness,  String? storagePath) async {
    // Check if the file path is not null or empty
    if (filePath.isNotEmpty) {
      File file = File(filePath);

      try {
        // Extract the file name from the file path
        String fileName = file.uri.pathSegments.last;

        // Add a prefix to the file name based on the employedOrBusiness argument
        if (employedOrBusiness == "business") {
          fileName = "business.$fileName";
        } else if (employedOrBusiness == "employed") {
          fileName = "employed.$fileName";
        }

        // Get a reference to Firebase Storage for the target path
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("${storagePath ?? "rent_documents_upload"}/${FirebaseAuth.instance.currentUser!.uid}/$fileName");

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

  // Uploading a selected file as a personal document
  Future<void> uploadSelectedFileDriver(String filePath, BuildContext context, String? storagePath) async {
    // Check if the file path is not null or empty
    if (filePath.isNotEmpty) {
      File file = File(filePath);

      try {
        // Extract the file name from the file path
        String fileName = file.uri.pathSegments.last;

        // Get a reference to Firebase Storage for the target path
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("${storagePath ?? "personal_documents_upload"}/${FirebaseAuth.instance.currentUser!.uid}/$fileName");

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


  Future<List<String>> getUserFiles(String storagePath, String userUID) async {
    List<String> filePaths = [];

    try {
      // Reference to the folder where your files are stored
      final ListResult result = await _storage
          .ref("$storagePath/$userUID")
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

  Future<List<Map<String, dynamic>>> getUserFilesForInquiry(String storagePath, String userUID) async {
    List<Map<String, dynamic>> fileDetails = [];

    try {
      // Reference to the folder where your files are stored
      final ListResult result = await _storage
          .ref("$storagePath/$userUID")
          .listAll();

      // Iterate through each item and get the full path, size, and upload date of the file
      for (var ref in result.items) {
        // Get the full path of the file
        String fullPath = ref.fullPath;

        // Format it to include the `gs://` prefix and your Firebase bucket name
        String storageLocation = 'gs://${_storage.bucket}/$fullPath';

        // Get the metadata of the file
        final FullMetadata metadata = await ref.getMetadata();

        // Get the file size and upload date
        int fileSize = metadata.size ?? 0; // File size in bytes
        DateTime? uploadDate = metadata.updated;

        // Add the details to the list
        fileDetails.add({
          'storageLocation': storageLocation,
          'fileSize': fileSize,
          'uploadDate': uploadDate,
        });
      }
    } catch (e) {
      debugPrint("Error listing files: $e");
    }

    return fileDetails;
  }
}
