import "package:file_picker/file_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

import "../../../../model/constants/firebase_constants.dart";
import "../../../../services/firebase/storage.dart";
import "../../../shared/colors.dart";
import "../../../shared/components.dart";
import "../../../shared/loading.dart";
import "../../../shared/strings.dart";

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  State<UploadDocuments> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends State<UploadDocuments> {
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
  bool _isLoading = true; // Add a loading state variable


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

  Widget _uploadDocumentsItem(String documentName, String headerName, int index) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: DashedBorder.fromBorderSide(
                  dashLength: 4,
                  side: BorderSide(
                      color: Color(int.parse(
                          ProjectColors.userInfoDialogBrokenLinesColor
                              .substring(2),
                          radix: 16)),
                      width: 1)),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Center(
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, top: 10, right: 0, bottom: 10),
                    child: Image.asset(
                      _getFileIcon(_fileIcons[index]),
                      height: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomComponents.displayText(
                            headerName,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                        Text(
                          _fileNames[index],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: ProjectStrings.general_font_family,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
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
                                  radix: 16)),
                            ),
                            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            padding: MaterialStatePropertyAll<EdgeInsets>(
                                EdgeInsets.only(
                                    left: 18,
                                    right: 18,
                                    top: 8,
                                    bottom: 8)), // Remove default padding
                            minimumSize: MaterialStatePropertyAll<Size>(
                                Size(0, 0)), // Ensures no minimum size
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap, // Shrinks the tap target size
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
                        )
                      ],
                    ),
                  ),
                )
              ])),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      backgroundColor: Color(int.parse(
        ProjectColors.mainColorBackground.substring(2),
        radix: 16,
      )),
      child: FractionallySizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top design
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    child: Image.asset(
                      "lib/assets/pictures/header_background_curves.png",
                      width: MediaQuery.of(context).size.width - 10,
                      height: 70, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, left: 15, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomComponents.displayText(
                          ProjectStrings.dialog_title_1,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        Image.asset(
                          "lib/assets/pictures/app_logo_circle.png",
                          width: 80.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Main content
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    // Main panel numbered header
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(
                                  ProjectColors.mainColorBackground.substring(2),
                                  radix: 16,
                                )),
                                border: Border.all(
                                  color: Color(int.parse(ProjectColors.lineGray)),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: CustomComponents.displayText(
                                  "1",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  ProjectStrings.user_info_header_title,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 2),
                                CustomComponents.displayText(
                                  ProjectStrings.user_info_header,
                                  color: Color(int.parse(
                                    ProjectColors.lightGray.substring(2),
                                    radix: 16,
                                  )),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Color(int.parse(
                        ProjectColors.lineGray.substring(2),
                        radix: 16,
                      )),
                    ),

                    // ListView for uploaded documents
                    SizedBox(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _originalFilePaths.length,
                        itemBuilder: (context, index) {
                          return _uploadDocumentsItem(
                            _originalFilePaths[index],
                            getDocumentTitle(index),
                            index,
                          );
                        },
                      ),
                    ),

                    // Save documents button
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          LoadingDialog().show(context: context, content: "Please wait while we process your documents.");
                          await updateDB();
                          LoadingDialog().dismiss();
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(Color(int.parse(
                                ProjectColors.userInfoDialogBrokenLinesColor.substring(2),
                                radix: 16))),
                            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomComponents.displayText(
                              ProjectStrings.user_info_save_documents,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
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
}
