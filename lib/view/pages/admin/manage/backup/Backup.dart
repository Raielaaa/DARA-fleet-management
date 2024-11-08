import "dart:convert";
import 'dart:typed_data';

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

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

  final List<String> firestoreCollections = [FirebaseConstants.userReportCollection, "sample-collection"];
  final List<String> storageDirectories = ["sample_storage_backup"];

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
        collectionData[doc.id] = doc.data();
      }

      data[collection] = collectionData;
    }

    return data;
  }

  // Function to backup multiple Firebase Storage directories
  Future<Map<String, dynamic>> _backupStorageFiles() async {
    final storageFilesData = <String, dynamic>{};

    for (var directory in storageDirectories) {
      final directoryData = <String, dynamic>{};
      final directoryRef = storage.ref().child(directory);
      final ListResult result = await directoryRef.listAll();

      for (var item in result.items) {
        final fileData = await item.getData();
        if (fileData != null) {
          directoryData[item.name] = base64Encode(fileData); // Encode file as base64
        }
      }

      storageFilesData[directory] = directoryData;
    }

    return storageFilesData;
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
      final backupData = await backupRef.getData();

      if (backupData != null) {
        final backupJson = jsonDecode(utf8.decode(backupData));
        await _restoreFirestoreData(backupJson['firestore']);
        await _restoreStorageFiles(backupJson['storage']);
        print("Restore completed successfully.");
      }
    } catch (e) {
      print("Error restoring backup: $e");
    }
  }

  // Restore Firestore data for multiple collections
  // Function to restore Firestore data for multiple collections
  Future<void> _restoreFirestoreData(Map<String, dynamic> firestoreData) async {
    final batch = FirebaseFirestore.instance.batch();

    try {
      // Loop through the collections and documents
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
          batch.set(docRef, docData); // Add set operation to batch
        });
      }

      // Step 3: Commit the batch after all operations are added
      await batch.commit();
    } catch (e) {
      // Handle any errors here
      print("Error during Firestore restore: $e");
    }
  }


  // Restore Firebase Storage files for multiple directories
  // Function to restore Firebase Storage files for multiple directories
  Future<void> _restoreStorageFiles(Map<String, dynamic> storageFiles) async {
    for (var directory in storageFiles.entries) {
      final directoryName = directory.key;
      final files = directory.value as Map<String, dynamic>;();

      // Step 1: Remove existing files in the directory
      final directoryRef = storage.ref().child(directoryName);
      final ListResult result = await directoryRef.listAll();

      // Delete all existing files before restoring
      for (var item in result.items) {
        await item.delete();
      }

      // Step 2: Upload new files from the backup
      for (var fileEntry in files.entries) {
        final fileName = fileEntry.key;
        final fileData = base64Decode(fileEntry.value);
        final fileRef = storage.ref().child('$directoryName/$fileName');

        await fileRef.putData(fileData);
      }
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
              const SizedBox(height: 15),
              // List and Restore backups
              backupRestoreList(),
              const SizedBox(height: 60),
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
          if (!snapshot.hasData) return CircularProgressIndicator(color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)));
      
          final backups = snapshot.data!;
          return ListView.builder(
            itemCount: backups.length,
            itemBuilder: (context, index) {
              final backup = backups[index];
              final date = backup['timestamp'].toLocal();
              final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
      
              return ListTile(
                title: Text('Backup: ${backup['name']}'),
                subtitle: Text('Date: $formattedDate'),
                trailing: IconButton(
                  icon: const Icon(Icons.restore),
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
              );
            },
          );
        },
      ),
    );
  }

  Widget createBackupButton() {
    return GestureDetector(
      onTap: () {
        InfoDialog().showDecoratedTwoOptionsDialog(
          context: context,
          content: "Are you sure you want to proceed with this action?",
          header: "Confirm Action",
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
