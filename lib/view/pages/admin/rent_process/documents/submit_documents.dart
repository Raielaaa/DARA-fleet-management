import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";
import 'package:file_picker/file_picker.dart';

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
    List<String> files = await Storage().getUserFiles();
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

  Future<void> updateDB() async {
    Storage _storage = Storage();

    // Handling deletion
    for (var value in removeDuplicatesString(itemsToBeDeletedToDB)) {
      await _storage.deleteFile(value);
    }

    // Handling upload
    for (var entry in indexStringMap.entries) {
      await _storage.uploadSelectedFile(entry.value, context, null, null);
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
        onPressed: () async {
          try {
            LoadingDialog().show(context: context, content: "Please wait while we process your documents.");
            await updateDB();
            LoadingDialog().dismiss();
            Navigator.of(context).pushNamed("rp_verify_booking");
          } catch(e) {
            LoadingDialog().dismiss();
            InfoDialog().show(context: context, content: "Something wen wrong. ${e.toString()}.", header: "Warning");
          }
        }, // Call to upload all files
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