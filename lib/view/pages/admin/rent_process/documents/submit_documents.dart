import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class SubmitDocuments extends StatefulWidget {
  const SubmitDocuments({super.key});

  @override
  State<SubmitDocuments> createState() => _SubmitDocumentsState();
}

class _SubmitDocumentsState extends State<SubmitDocuments> {
  List<String?> _filePaths = List<String?>.filled(5, null); // For 5 documents
  List<String> _uploadedUrls = List<String>.filled(5, '');
  List<String> _fileNames = List<String>.filled(5, "No file selected"); // Display file names
  List<String> _fileIcons = List<String>.filled(5, "lib/assets/pictures/user_info_upload.png"); // Display file icons
  String userUID = "";
  // Function to pick file
  // Function to pick multiple files
  Future<void> _pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        // Replace the file at the current index with the newly selected file
        _filePaths[index] = result.files.first.path;
        String fileName = result.files.first.name; // Extract file name
        String fileExtension = fileName.split('.').last; // Extract file extension

        // Update the display based on file type
        _fileIcons[index] = _getFileIcon(fileExtension); // Update image icon
        _fileNames[index] = fileName; // Update the file name display

        debugPrint("File path: ${result.files.first.path}");
      });
    }
  }


// Helper function to determine which icon to display
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


  // Function to upload the selected file to Firebase Storage
  Future<void> _uploadFile(int index) async {
    if (_filePaths[index] != null) {
      File file = File(_filePaths[index]!);
      try {
        String fileName = file.uri.pathSegments.last;
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("rent_documents_upload/$userUID/$fileName");

        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        setState(() {
          _uploadedUrls[index] = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File uploaded: $fileName")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading file: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No file selected for document ${index + 1}")),
      );
    }
  }

  // Function to upload all files when the 'Proceed' button is clicked
  Future<void> _uploadAllFiles() async {
    bool allFilesSelected = true;
    for (int i = 0; i < _filePaths.length; i++) {
      if (_filePaths[i] == null) {
        allFilesSelected = false;
      }
    }

    if (allFilesSelected) {
      LoadingDialog().show(context: context, content: "Please wait while we upload your documents.");
      for (int i = 0; i < _filePaths.length; i++) {
        await _uploadFile(i);
      }
      LoadingDialog().dismiss();
      InfoDialog().show(context: context, content: "All files uploaded successfully!", header: "Success");
      Navigator.of(context).pushNamed("rp_verify_booking");
    } else {
      InfoDialog().show(context: context, content: "Kindly select a file. Please ensure that all required fields are completed.", header: "Warning");
    }
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
                  _fileIcons[index], // Dynamically change the image based on file type
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
                    CustomComponents.displayText(
                      _fileNames[index], // Dynamically change the displayed file name
                      color: Color(int.parse(
                        ProjectColors.lightGray.substring(2),
                        radix: 16,
                      )),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {
                        _pickFile(index);
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

  Widget _proceedButton() {
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
        onPressed: _uploadAllFiles, // Call to upload all files
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: CustomComponents.displayText(
              ProjectStrings.ps_proceed_button,
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userUID = FirebaseAuth.instance.currentUser?.uid ?? "";

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
                            _proceedButton(),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
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