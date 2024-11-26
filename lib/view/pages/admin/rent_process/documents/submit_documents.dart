import "dart:convert";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/car_list/car_list_controller.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:googleapis_auth/auth_io.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../../services/firebase/auth.dart";
import "../../../../../services/firebase/storage.dart";


class SubmitDocuments extends StatefulWidget {
  const SubmitDocuments({super.key});

  @override
  State<SubmitDocuments> createState() => _SubmitDocumentsState();
}

class _SubmitDocumentsState extends State<SubmitDocuments> {
  List<int> selectedIndex = [];
  Map<int, String> indexStringMap = {
    0: '',
    1: '',
    2: '',
    3: '',
    4: '',
  };

  List<String> itemsToBeDeletedToDB = [];
  List<String> _originalFilePaths = [];
  List<String> _newListTobeAddedToDB = [];
  List<String> _fileNames = List<String>.filled(5, "No file selected"); // Display file names
  List<String> _fileIcons = List<String>.filled(5, 'lib/assets/pictures/user_info_upload.png'); // Display file icons
  bool _isLoading = true; // A

  @override
  void initState() {
    super.initState();

    // Defer the retrieval until the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      retrieveItems();
    });
  }

  Future<void> retrieveItems() async {
    BuildContext? currentContext = context;

    LoadingDialog().show(context: currentContext, content: "Please wait while we retrieve your documents.");
    List<String> files = await Storage().getUserFiles(FirebaseConstants.rentDocumentsUpload, FirebaseAuth.instance.currentUser!.uid);
    _originalFilePaths.clear();

    // Fill the _originalFilePaths with retrieved files
    try {
      files.asMap().forEach((index, value) {
        _originalFilePaths.add(value);
        debugPrint("value: $value");

        _fileIcons[index] = value.split(".").last;
        _fileNames[index] = value.split("/")[5];
      });
    } catch(e) {
      debugPrint("Error on getting file icons and names at upload_documents.dart: $e");
    }

    // Ensure _originalFilePaths has exactly 5 items by filling with empty strings if necessary
    while (_originalFilePaths.length < 5) {
      _originalFilePaths.add("");
    }

    if (mounted) {
      LoadingDialog().dismiss();
    }

    setState(() {
      _isLoading = false; // Set loading state to false after fetching
    });
  }

  List<int> removeDuplicates(List<int> originalList) {
    return originalList.toSet().toList();
  }

  List<String> removeDuplicatesString(List<String> originalList) {
    return originalList.toSet().toList();
  }

  String getDocumentTitle(int index) {
    switch (index) {
      case 0:
        return ProjectStrings.user_info_government1;
      case 1:
        return ProjectStrings.user_info_government2;
      case 2:
        return ProjectStrings.user_info_driver_license;
      case 3:
        return ProjectStrings.user_info_proof_of_billing;
      case 4:
        return ProjectStrings.user_info_ltms_portal;
      default:
        return "Unknown Document";
    }
  }

  void inputString(int index, String newString) {
    if (indexStringMap.containsKey(index)) {
      indexStringMap[index] = newString; // Overwrite the string at the index
    } else {
      debugPrint('Index $index is out of range.');
    }
  }

  String _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'lib/assets/pictures/pdf.png';
      case 'doc':
      case 'docx':
        return 'lib/assets/pictures/docx.png';
      case 'jpg':
        return 'lib/assets/pictures/jpg.png';
      case 'jpeg':
        return 'lib/assets/pictures/jpeg.png';
      case 'png':
        return 'lib/assets/pictures/png.png';
      default:
        return 'lib/assets/pictures/user_info_upload.png'; // Default icon for unsupported types
    }
  }

  Future<void> _pickFile(int index, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedIndex.add(index);
        itemsToBeDeletedToDB.add(_originalFilePaths[index]);
        _newListTobeAddedToDB.add(result.files.first.path!);
        inputString(index, result.files.first.path!);

        // Replace the file at the current index with the newly selected file
        _originalFilePaths[index] = result.files.first.path!;
        String fileName = result.files.first.name; // Extract file name
        String fileExtension = fileName.split('.').last; // Extract file extension

        // Update the display based on file type
        _fileIcons[index] = fileExtension; // Update image icon
        _fileNames[index] = fileName; // Update the file name display
      });
    }
  }

  int getCurrentTimeOfTheDayInSeconds() {
    // Get the current time
    DateTime now = DateTime.now();

    // Extract hours, minutes, and seconds
    int hoursInSeconds = now.hour * 3600;  // 1 hour = 3600 seconds
    int minutesInSeconds = now.minute * 60; // 1 minute = 60 seconds
    int seconds = now.second;

    // Calculate the total time in seconds
    return hoursInSeconds + minutesInSeconds + seconds;
  }

  Future<void> updateDB() async {
    String docName = "${Auth().currentUser!.uid} - ${getCurrentTimeOfTheDayInSeconds()}";
    await CarListController().submitRentRecords(
        collectionName: FirebaseConstants.rentRecordsCollection,
        documentName: docName,
        data: PersistentData().rentInfoToBeSaved.getModelData()
    );
    await FirebaseFirestore.instance.collection(FirebaseConstants.rentRecordsCollection)
    .doc(docName)
    .update({
      "rent_image_path_for_alternative_payment" : PersistentData().gcashAlternativeImagePath
    });


    Storage _storage = Storage();

    // Handling deletion
    for (var value in removeDuplicatesString(itemsToBeDeletedToDB)) {
      await _storage.deleteFile(value);
    }

    // Handling upload
    for (var entry in indexStringMap.entries) {
      await _storage.uploadSelectedFile(entry.value, context, null, null);
    }
    debugPrint("Update finished");
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          Center(
            child: CustomComponents.displayText(
              ProjectStrings.sd_appbar_title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitDocuments(String documentName, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: DashedBorder.fromBorderSide(
            dashLength: 4,
            side: BorderSide(
              color: Color(int.parse(
                ProjectColors.userInfoDialogBrokenLinesColor.substring(2),
                radix: 16,
              )),
              width: 1,
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 30,
                  bottom: 10,
                ),
                child: Image.asset(
                  _getFileIcon(_fileIcons[index]),
                  height: 60,
                ),
              ),
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomComponents.displayText(
                      ProjectStrings.user_info_upload_file,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        _fileNames[index],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontFamily: ProjectStrings.general_font_family,
                            fontSize: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        _pickFile(index, context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color(int.parse(
                            ProjectColors.userInfoDialogBrokenLinesColor
                                .substring(2),
                            radix: 16,
                          )),
                        ),
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        padding: MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.only(
                              left: 18, right: 18, top: 8, bottom: 8),
                        ),
                        minimumSize: MaterialStatePropertyAll<Size>(Size(0, 0)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: CustomComponents.displayText(
                          ProjectStrings.user_info_choose_a_file,
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proceedButton(BuildContext parentContext) {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                )
            )
        ),
        onPressed: () async {
          try {
            InfoDialog().showDecoratedTwoOptionsDialog(
              context: context,
              header: "Confirm Booking",
              content: "Are you sure you want to proceed with this booking? This action cannot be undone!",
              confirmAction: () async {
                await updateDB();
                await notifyAdminOnNewRent(PersistentData().rentInfoToBeSaved.carName, PersistentData().rentInfoToBeSaved.renterEmail);
                Navigator.of(parentContext).pushNamed("rp_verify_booking");
              }
            );
          } catch(e) {
            LoadingDialog().dismiss();
            InfoDialog().show(context: context, content: "Something wen wrong. ${e.toString()}.", header: "Warning");
          }
        }, // Call to upload all files
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: CustomComponents.displayText(
              "Proceed",
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> notifyAdminOnNewRent(String carName, String renterName) async {
    try {
      // Retrieve the service account credentials JSON from your Firebase console
      final serviceAccountCredentials = ServiceAccountCredentials.fromJson(r'''{
      "type": "service_account",
  "project_id": "dara-renting-app",
  "private_key_id": "71989bd22ccca7cd7a496d4b850676efaa6b0c13",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7XhYJ59GP4/hC\nMWV2LRZUHZX/Af+CCEzCk1xGbzQuYZniNmwJHmTMjN5KKo+/yXrXoGioyLZwKj6U\nhzqjcQRE3fgqvncNfl+S4bqs6oBF50kgqMNrT7bnZzEoNvtdbsUFUNHl8q7/QAPt\nR31/GLfPa3Fo8qYi6rWhyvqEIku9j/62B6fgLhOM1pJKqe9NZOfY9Xxnc04mQ6a9\nChML79XtnKxkE0NjxtjUYDNPA8gRJOgvNcreWaG9PzzIJKnhgVaFWowgwfl9SjP1\nuDSpooOecmt6yW+IDTLQjCxxFZ4UyMX8v5IdNHBaQDRjGXzdbLP8bBU+DOqk0E+B\nDCb+RIfTAgMBAAECggEAIsApgD7RnElg0w4MTmXAXWt7VWeOdxSJABGKrLmVSQDr\nJIyJbwuHEHUUCVdpf92jffiPULahN55uKugF1Shx7T/p9iuLMyJ8IWbiU43Oqqhh\n5L/INs/7EWIPOPExn7uaqQi7VVW0ZTz/PXPj772q4bqAt0FB1PoJI+/clMMznv2T\nqgseS1/U3z8ZsQYpxcMINK4ZV0WW2hBbOV9D4aFZ+HzhWNzST9FELfcA3sE/l16j\nIdtf53thHA4CRYpeaToeeaVqj5NYu0Ot89U2jJt/bkZfffAOvVo0i8l0zzZbovy9\n1hPPXqSH+EO1rs34jqn82Tl4C8PgLJxNO8049BGQOQKBgQDjFg59YbDwNnOa/fOI\nz4MreERFqkjDBg5aEvQBtxRC7YjQ37dP4bZgjeNJbcfHfTGowW6f/jZPsNOLEFZM\naMUpkpwVbh9EDd1DwclbCk3V49gUPgeg9C+FdhuWGfG9jMARSePOklnmXxKUiXHa\npwZIm5OMnN0puuOgBoX4PwW5vwKBgQDTOWNpwHigL+h+8+vQ6n+9A/69cGuZZEC6\nzLNegJN4AMv6kRkDxmVjlpnrIKW+Y+z1/64RRJ2MO1JZwSTSn39rhrkRTxSvnAZS\nt3/ZWjTldj34igpZTLjX1YWdbIjurWOGntDID6BKp3dh1b6lYR84s0tKfm/i8EZo\n682grrju7QKBgQDiVZGLllrskNkYmhSpP2rVYMFrThXHi7myPUHGk9s1+dprlQ74\nJ1fHVKQ9A5YjVrywHltMS+uF8hBmgpoA/kvE68N1+JRhGBB5ACTZAKQjkzxCsLCZ\n08epldZY/PLcofStRqAvu96upgO22GcKL38rzyR4+b/VX9iQHvBYRThHsQKBgQDS\nbmsPMTQ7il8bE1FM6kJmgbNo8bYQtGMUdtj//iJsvIZ609FTBHWAGMqxB+531j99\n+MJm66/1xCfPyW8w8rvT2P1JNDrMlSlrgOq7FHZ8YCdvE78pphjE1jFuW3G0L0Nn\nG5OurHqpxVtXOcXcJv0e1Ojeh0ZalbvfzYQnX8pYJQKBgQCwgqPfg8ahsy5ooFpo\n6I33kjCCwVqqG13CBumTuaePDHxSvShXSdSDVyrcF+mC7kzicXOWu1TnPOzNqAeb\nNzVv1m2M/SQWfRXrR7zV0nvj4V6LrfH3ihy1hlcs3/Na+n8/vOJHQvXcUPJpRmAd\nNDRcIng4rBBE33m4ZXw30zVp5A==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-mvg9p@dara-renting-app.iam.gserviceaccount.com",
  "client_id": "103374805067281690715",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mvg9p%40dara-renting-app.iam.gserviceaccount.com",
    }''');

      // Create an auth client
      final authClient = await clientViaServiceAccount(
          serviceAccountCredentials,
          ['https://www.googleapis.com/auth/firebase.messaging']
      );

      // Get the OAuth 2.0 token for FCM
      final token = await authClient.credentials.accessToken;

      // Fetch admin device tokens from Firestore
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance.collection("adminTokens").get();

      List<String> tokens = [];
      for (var doc in adminSnapshot.docs) {
        String? token = doc["deviceToken"];
        if (token != null) {
          tokens.add(token);
        }
      }

      if (tokens.isNotEmpty) {
        // Create FCM notification payload
        Map<String, dynamic> notificationPayload = {
          "registration_ids": tokens, // Target all admin devices
          "notification": {
            "title": "New Rent Request",
            "body": "$renterName has requested to rent $carName. View details in the app.",
          },
          "data": {
            "type": "rent_notification",
            "renterName": renterName,
          },
        };

        // Send the notification using FCM's API
        final response = await http.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/dara-renting-app/messages:send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}',
          },
          body: json.encode({
            "message": notificationPayload,
          }),
        );

        if (response.statusCode == 200) {
          debugPrint("Notification sent successfully!");
          CustomComponents.showToastMessage("Notification sent successfully!", Colors.green, Colors.white);
        } else {
          debugPrint("Failed to send notification: ${response.body}");
          CustomComponents.showToastMessage("Failed to send notification", Colors.red, Colors.white);
        }
      }
    } catch (e) {
      debugPrint("Error sending notifications: $e");
      CustomComponents.showToastMessage("Error sending notifications: $e", Colors.red, Colors.white);
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
              _buildAppBar(),
              // main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Column(
                          children: [
                            //  header
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: CustomComponents.displayText(
                                  "Submit Required Documents",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                ),
                              ),
                            ),
                            //  subheader
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: CustomComponents.displayText(
                                    "Upload the necessary documents for review. Our team will assess your application and notify you once it's approved.",
                                    fontSize: 10
                                ),
                              ),
                            ),


                            const SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.user_info_government1,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  color: Colors.red
                                ),
                              ),
                            ),
                            _submitDocuments("No file selected", 0),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 25),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.user_info_government2,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                              ),
                            ),
                            _submitDocuments("No file selected", 1),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 25),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.user_info_driver_license,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                              ),
                            ),
                            _submitDocuments("No file selected", 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 25),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.user_info_proof_of_billing,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                              ),
                            ),
                            _submitDocuments("No file selected", 3),
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 25),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    ProjectStrings.user_info_ltms_portal,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                              ),
                            ),
                            _submitDocuments("No file selected", 4),
                            _proceedButton(context),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      const SizedBox(height: 70)
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}