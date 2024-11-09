import "dart:convert";
import 'dart:typed_data';

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:http/http.dart' as http;

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";

class BackupRestore extends StatefulWidget {
  const BackupRestore({super.key});

  @override
  State<BackupRestore> createState() => _BackupRestoreState();
}

class _BackupRestoreState extends State<BackupRestore> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final List<String> firestoreCollections = [
    FirebaseConstants.accountantCollection,
    FirebaseConstants.carInfoCollection,
    FirebaseConstants.driverApplication,
    FirebaseConstants.outsourceApplication,
    FirebaseConstants.registerCollection,
    FirebaseConstants.rentRecordsCollection,
    FirebaseConstants.registerRoleCollection,
    FirebaseConstants.userReportCollection,
  ];
  final List<String> storageDirectories = [
    "banner_popups",
    "banner_promos",
    "car_images",
    "driver_application",
    "outsource_application",
    "personal_documents_upload",
    "rent_documents_upload",
    "report_images",
    "user_images"
  ];

  // Function to create a backup of all specified Firestore collections and Storage directories
  Future<void> createBackup() async {
    try {
      // backup Firestore data from all collections
      final firestoreData = await _backupFirestoreData();

      // backup Storage files from all directories
      final storageFiles = await _backupStorageFiles();

      // combine Firestore and Storage data into one JSON
      final backupData = {
        'firestore': firestoreData,
        'storage': storageFiles,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // uploads JSON to Firebase Storage with timestamp
      await _uploadBackupToStorage(backupData);
      debugPrint("Backup completed successfully.");
    } catch (e) {
      debugPrint("Error creating backup: $e");
    }
  }

  // Function to backup multiple Firestore collections
  Future<Map<String, dynamic>> _backupFirestoreData() async {
    final data = <String, dynamic>{};

    for (var collection in firestoreCollections) {
      final collectionData = <String, dynamic>{};
      final querySnapshot = await firestore.collection(collection).get();

      for (var doc in querySnapshot.docs) {
        final docData = doc.data();
        // Sanitize the document data
        final sanitizedData = _sanitizeMap(docData);
        collectionData[doc.id] = sanitizedData;
      }

      data[collection] = collectionData;
    }

    return data;
  }

  Map<String, dynamic> _sanitizeMap(Map<dynamic, dynamic> map) {
    final sanitizedMap = <String, dynamic>{};

    map.forEach((key, value) {
      if (value is String) {
        sanitizedMap[key] = sanitizeJsonData(value);
      } else if (value is Map) {
        sanitizedMap[key] = _sanitizeMap(value); // Recursively sanitize nested maps
      } else {
        sanitizedMap[key] = value;
      }
    });

    return sanitizedMap;
  }


  // Function to backup multiple Firebase Storage directories
  Future<Map<String, dynamic>> _backupStorageFiles() async {
    final storageFilesData = <String, dynamic>{};

    for (var directory in storageDirectories) {
      final directoryData = await _listFilesRecursively(directory);
      storageFilesData[directory] = directoryData;
    }

    return storageFilesData;
  }

// Helper function to recursively list files
  Future<Map<String, dynamic>> _listFilesRecursively(String path) async {
    final directoryData = <String, dynamic>{};
    final directoryRef = storage.ref().child(path);
    final result = await directoryRef.listAll();

    // List files in the current directory
    for (var item in result.items) {
      final fileData = await item.getData();
      if (fileData != null) {
        directoryData[item.fullPath] = base64Encode(fileData);
      }
    }

    // Recurse into subdirectories
    for (var prefix in result.prefixes) {
      final subdirectoryData = await _listFilesRecursively(prefix.fullPath);
      directoryData.addAll(subdirectoryData);
    }

    return directoryData;
  }


  // Function to upload backup JSON data to Firebase Storage
  Future<void> _uploadBackupToStorage(Map<String, dynamic> backupData) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupJson = jsonEncode(backupData);
    final backupRef = storage.ref('backups/backup_$timestamp.json');

    await backupRef.putData(Uint8List.fromList(backupJson.codeUnits));
  }

  // Function to list all available backups
  Future<List<Map<String, dynamic>>> listBackups() async {
    final backupList = <Map<String, dynamic>>[];
    final backupDir = storage.ref().child('backups');
    final ListResult result = await backupDir.listAll();

    for (var backup in result.items) {
      final meta = await backup.getMetadata();
      backupList.add({
        'name': backup.name,
        'timestamp': meta.timeCreated,
      });
    }

    return backupList;
  }

  // Function to restore a specific backup
  Future<void> restoreBackup(String backupFileName) async {
    try {
      final backupRef = storage.ref('backups/$backupFileName');
      // Fetch the download URL instead of using getData() directly
      final backupDownloadUrl = await backupRef.getDownloadURL();

      // Download the file content using HTTP or any method to fetch the data as a byte array
      final backupData = await _downloadFileData(backupDownloadUrl);

      if (backupData != null) {
        final backupJson;
        try {
          backupJson = jsonDecode(utf8.decode(backupData));
        } catch (e) {
          debugPrint("Decoding error at byte: ${backupData.length}");
          debugPrint("Error message: $e");
          return;
        }
        await _restoreFirestoreData(backupJson['firestore']);
        await _restoreStorageFiles(backupJson['storage']);
        debugPrint("Restore completed successfully.");
      } else {
        throw Exception("Backup data is null.");
      }
    } catch (e) {
      debugPrint("Error restoring backup: $e");
      // Optional: Show user-friendly error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to restore backup: $e')),
      );
    }
  }

  String sanitizeJsonData(String input) {
    return input.replaceAll("ñ", "n").replaceAll("Ñ", "N").replaceAll("'", "");
  }

  Future<List<int>?> _downloadFileData(String downloadUrl) async {
    try {
      // Use the HTTP package to download the file from the URL (This is a simplified example)
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes; // Return the file as bytes
      } else {
        throw Exception("Failed to download file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error downloading file: $e");
      return null;
    }
  }


  // Restore Firestore data for multiple collections
  // Function to restore Firestore data for multiple collections
  Future<void> _restoreFirestoreData(Map<String, dynamic> firestoreData) async {
    final batch = FirebaseFirestore.instance.batch();

    try {
      for (var collectionName in firestoreData.keys) {
        final collectionData = firestoreData[collectionName];

        final collectionRef = FirebaseFirestore.instance.collection(collectionName);

        // Step 1: Delete existing documents in the collection
        final existingDocs = await collectionRef.get();
        for (var doc in existingDocs.docs) {
          await doc.reference.delete();
        }

        // Step 2: Add new documents to the batch
        collectionData.forEach((docId, docData) {
          final docRef = collectionRef.doc(docId);
          final sanitizedData = _sanitizeMap(docData); // Sanitize data before saving
          batch.set(docRef, sanitizedData);
        });
      }

      // Step 3: Commit the batch after all operations are added
      await batch.commit();
    } catch (e) {
      debugPrint("Error during Firestore restore: $e");
    }
  }



  // Restore Firebase Storage files for multiple directories
  // Function to restore Firebase Storage files for multiple directories
  // Restore Firebase Storage files for multiple directories
  Future<void> _restoreStorageFiles(Map<String, dynamic> storageFiles) async {
    for (var directory in storageFiles.entries) {
      final directoryName = directory.key;
      final files = directory.value as Map<String, dynamic>;

      debugPrint("directory name: $directoryName");

      // First, delete the contents of the directory
      await deleteDirectory(directoryName);

      // Step 1: Upload new files from the backup (optional)
      for (var fileEntry in files.entries) {
        final fileName = fileEntry.key;
        final fileData = base64Decode(fileEntry.value);

        // Use the correct path structure
        final fileRef = FirebaseStorage.instance.ref().child(fileName); // Assumes full path in `fileEntry.key`

        await fileRef.putData(fileData);
      }
    }
  }

  Future<void> deleteDirectory(String directoryPath) async {
    final storage = FirebaseStorage.instance;

    // Recursively delete all files under the specified directory
    await _deleteFilesRecursively(directoryPath, storage);

    // After deleting files, check if the folder is now empty
    await _checkAndRemoveEmptyFolder(directoryPath, storage);
  }

  Future<void> _deleteFilesRecursively(String path, FirebaseStorage storage) async {
    try {
      // Get reference to the directory
      final directoryRef = storage.ref().child(path);

      // List all items in the directory
      final ListResult result = await directoryRef.listAll();

      // Delete all files in the current directory
      for (var item in result.items) {
        try {
          // Deleting each file
          await item.delete();
          debugPrint('Deleted: ${item.fullPath}');
        } catch (e) {
          debugPrint('Error deleting file ${item.fullPath}: $e');
        }
      }

      // Recursively delete files in subdirectories
      for (var prefix in result.prefixes) {
        await _deleteFilesRecursively(prefix.fullPath, storage);
      }
    } catch (e) {
      debugPrint('Error listing or deleting files in directory: $path, Error: $e');
    }
  }

// After deleting files, check if the folder is now empty
  Future<void> _checkAndRemoveEmptyFolder(String path, FirebaseStorage storage) async {
    try {
      final directoryRef = storage.ref().child(path);
      final ListResult result = await directoryRef.listAll();

      // If there are no items or prefixes left, it should be "empty"
      if (result.items.isEmpty && result.prefixes.isEmpty) {
        debugPrint('Folder is empty, folder: $path is now effectively deleted.');
      } else {
        debugPrint('Folder is not empty, something is still there.');
      }
    } catch (e) {
      debugPrint('Error checking folder: $path, Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              appBar(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      "Data Management",
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      "Manage backup and restore options",
                      fontSize: 10
                  ),
                ),
              ),
              const SizedBox(height: 15),
              createBackupButton(),
              // List and Restore backups
              const SizedBox(height: 15),
              backupRestoreList(),
              const SizedBox(height: 65),
            ],
          )
        )
      )
    );
  }

  Widget backupRestoreList() {
    return Expanded(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: listBackups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                ),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Image.asset(
                          "lib/assets/pictures/data_not_found.jpg",
                          width: MediaQuery.of(context).size.width - 200,
                        ),
                        const SizedBox(height: 20),
                        CustomComponents.displayText(
                            "No records found at the moment. Create your backup now.",
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        ),
                        const SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading backups. Please try again.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontFamily: ProjectStrings.general_font_family
                ),
              ),
            );
          }

          final backups = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: backups.length,
            itemBuilder: (context, index) {
              final backup = backups[index];
              final date = backup['timestamp'].toLocal();
              final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

              return Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomComponents.displayText(
                                backup["name"],
                                color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                fontStyle: FontStyle.italic,
                                fontSize: 12
                            ),
                            const SizedBox(height: 3),
                            CustomComponents.displayText(
                                "Date: $formattedDate",
                                fontSize: 10
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.restore_page, color: Colors.red, size: 25),
                              onPressed: () async {
                                InfoDialog().showDecoratedTwoOptionsDialog(
                                    context: context,
                                    content: "Are you sure you want to proceed with this option? This action cannot be undone.",
                                    header: "Warning!",
                                    confirmAction: () async {
                                      await restoreBackup(backup['name']);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Restore completed successfully!')),
                                      );
                                    }
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)), size: 25),
                              onPressed: () async {
                                InfoDialog().showDecoratedTwoOptionsDialog(
                                    context: context,
                                    content: "Are you sure you want to delete this backup? This action cannot be undone.",
                                    header: "Confirm Deletion",
                                    confirmAction: () async {
                                      await deleteBackup(backup['name']);
                                      setState(() {}); // Refresh list after deletion
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Backup deleted successfully!')),
                                      );
                                    }
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

// Function to delete a specific backup
  Future<void> deleteBackup(String backupFileName) async {
    try {
      final backupRef = storage.ref('backups/$backupFileName');
      await backupRef.delete();
      debugPrint("Backup deleted successfully.");
    } catch (e) {
      debugPrint("Error deleting backup: $e");
    }
  }

  Widget createBackupButton() {
    return GestureDetector(
      onTap: () {
        InfoDialog().showDecoratedTwoOptionsDialog(
          context: context,
          content: "Are you sure you want to proceed with this action?",
          header: "Create Backup",
          confirmAction: () async {
            await createBackup();
          }
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              borderRadius: BorderRadius.circular(7)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_circle_outline_outlined,
                  size: 17,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                CustomComponents.displayText(
                    "Create new backup",
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              PersistentData().openDrawer(0);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
          ),
          CustomComponents.displayText(
            "Backup and Restore",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
