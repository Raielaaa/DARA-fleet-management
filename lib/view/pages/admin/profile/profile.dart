import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/pages/account/register/widgets/terms_and_conditions.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:file_picker/file_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import "../../../../model/account/register_model.dart";
import "../../../../services/firebase/storage.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  RegisterModel? _currentUserInfo;
  File? _image; // Store the selected image
  final ImagePicker _picker = ImagePicker(); // Initialize the picker
  String? _imageUrl; // Store the URL for displaying the profile picture

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Convert the picked file to a File object
      });
      await _uploadImage(); // After selecting, upload the image
    }
  }

  // Function to upload the image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_image == null) return;

    LoadingDialog().show(context: context, content: "Fetching data, please wait.");
    // Get the current user's ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Create a reference to Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref().child('user_images/$userId');

    // Upload the file to Firebase Storage
    UploadTask uploadTask = storageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL after the upload is complete
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Save the download URL to Firestore under the user's document
    await FirebaseFirestore.instance.collection(FirebaseConstants.registerCollection).doc(userId).update({
      'user_profile': downloadUrl,
    });

    // Update the state with the new image URL
    setState(() {
      _imageUrl = downloadUrl;
    });
    LoadingDialog().dismiss();
  }

  // Function to load the profile image URL from Firestore
  Future<void> _loadProfileImage() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(FirebaseConstants.registerCollection).doc(userId).get();

    setState(() {
      _imageUrl = userDoc["user_profile"]; // Retrieve the URL from Firestore
    });
  }


  @override
  void initState() {
    super.initState();

    _fetchUserInfo();
    _loadProfileImage(); // Load the profile image on initialization
  }

  Future<void> _fetchUserInfo() async {
    // Fetch the user information asynchronously
    _currentUserInfo = await Firestore().getUserInfo(FirebaseAuth.instance.currentUser!.uid);

    // Update the UI after data is fetched
    setState(() {
      // Set the fetched data
      _currentUserInfo = _currentUserInfo;
    });
  }

  Future<void> _showContactBottomDialog() async {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomComponents.displayText(ProjectStrings.to_bottom_title,
                    fontSize: 12, fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                _bottomSheetContactItems(
                    "lib/assets/pictures/bottom_email.png",
                    ProjectStrings.to_bottom_email_title,
                    ProjectStrings.to_bottom_email_content),
                const SizedBox(height: 15),
                _bottomSheetContactItems(
                    "lib/assets/pictures/bottom_chat.png",
                    ProjectStrings.to_bottom_message_title,
                    ProjectStrings.to_bottom_message_content),
                const SizedBox(height: 15),
                _bottomSheetContactItems(
                    "lib/assets/pictures/bottom_call.png",
                    ProjectStrings.to_bottom_call_title,
                    ProjectStrings.to_bottom_call_content),
                const SizedBox(height: 60),
              ],
            ),
          );
        });
  }

  Widget _bottomSheetContactItems(
      String imagePath, String contactTitle, String contactContent) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 38,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomComponents.displayText(contactTitle,
                fontSize: 10, fontWeight: FontWeight.bold),
            const SizedBox(height: 3),
            CustomComponents.displayText(contactContent, fontSize: 10)
          ],
        )
      ],
    );
  }

  Widget _bottomPanelItem(String imagePath, Color bgColor, String itemLabel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose, // Use Flexible with FlexFit.loose
          child: Container(
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: bgColor, // Optional: add background color to the circle
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Image.asset(
                imagePath,
                width: 20, // Adjust the image size as needed
                height: 20, // Adjust the image size as needed
                fit: BoxFit
                    .cover, // Ensure the image covers the entire container
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        CustomComponents.displayText(itemLabel,
            fontWeight: FontWeight.w500, fontSize: 10),
      ],
    );
  }

  Widget _mainPanelItem(String label, String content) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(label,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(
                  int.parse(ProjectColors.lightGray.substring(2), radix: 16))),
          CustomComponents.displayText(
            content,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          )
        ],
      ),
    );
  }

  List<int> selectedIndex = [];

  List<int> removeDuplicates(List<int> originalList) {
    return originalList.toSet().toList();
  }
  List<String> removeDuplicatesString(List<String> originalList) {
    return originalList.toSet().toList();
  }

  Map<int, String> indexStringMap = {
    0: '',
    1: '',
    2: '',
    3: '',
    4: '',
  };
  List<String> itemsToBeDeletedToDB = [];

  // Function to input a string at a specific index
  void inputString(int index, String newString) {
    if (indexStringMap.containsKey(index)) {
      indexStringMap[index] = newString; // Overwrite the string at the index
    } else {
      debugPrint('Index $index is out of range.');
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
        inputString(0, result.files.first.path!);

        // Replace the file at the current index with the newly selected file
        _originalFilePaths[index] = result.files.first.path!;
        String fileName = result.files.first.name; // Extract file name
        String fileExtension = fileName.split('.').last; // Extract file extension

        // Update the display based on file type
        _fileIcons[index] = fileExtension; // Update image icon
        _fileNames[index] = fileName; // Update the file name display

        debugPrint("File path: ${result.files.first.path}");
        debugPrint("File extensions: ${_fileIcons[index]}");
      });
      // Instead of directly calling pop, check if the dialog is still open
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();  // Close the current dialog if possible
      }

      // Reopen the dialog to reflect the updated data
      _seeUploadDocumentsDialog(_originalFilePaths);
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, top: 10, right: 30, bottom: 10),
                  child: Image.asset(
                      _getFileIcon(_fileIcons[index]),
                    height: 60,
                  ),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                )
              ])),
        ));
  }

  List<String> _originalFilePaths = [];
  List<String> _newListTobeAddedToDB = [];
  List<String> _fileNames = List<String>.filled(5, "No file selected"); // Display file names
  List<String> _fileIcons = List<String>.filled(5, 'lib/assets/pictures/user_info_upload.png'); // Display file icons
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

  Future<void> _seeUploadDocumentsDialog(List<String> uploadedFiles) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Color(int.parse(
            ProjectColors.mainColorBackground.substring(2),
            radix: 16,
          )),
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
                    Container(
                      height: 485, // Adjust height as needed
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: uploadedFiles.length,
                        itemBuilder: (context, index) {
                          return _uploadDocumentsItem(
                            uploadedFiles[index],
                            getDocumentTitle(index),
                            index,
                          );
                        },
                      )
                    ),

                    // Save documents button
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          removeDuplicatesString(itemsToBeDeletedToDB).forEach((value) {
                            debugPrint("Itemt to be deleted: $value");
                          });
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
        );
      },
    );
  }

// Helper method to get the document title based on index
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Color(
              int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
          child: Padding(
            padding: const EdgeInsets.only(top: 38),
            child: _currentUserInfo == null ? const Center(child: CircularProgressIndicator()) : Column(
              children: [
                //  ActionBar
                Container(
                  width: double.infinity,
                  height: 65,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset("lib/assets/pictures/left_arrow.png"),
                      ),
                      CustomComponents.displayText(
                        "User Information",
                        fontWeight: FontWeight.bold,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                            "lib/assets/pictures/three_vertical_dots.png"),
                      ),
                    ],
                  ),
                ),

                //  Header
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "lib/assets/pictures/app_logo_circle.png",
                        width: 120.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(int.parse(
                              ProjectColors.mainColorHex.substring(2),
                              radix: 16)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 30, left: 30),
                          child: CustomComponents.displayText(
                            PersistentData().userType,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomComponents.displayText(
                                "Hello, ${_currentUserInfo?.role}",
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                            ),
                            CustomComponents.displayText(
                              "PH ${_currentUserInfo?.number}",
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(int.parse(
                                      ProjectColors.lightGreen.substring(2),
                                      radix: 16)),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Image.asset(
                                        "lib/assets/pictures/rentals_verified.png",
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10, right: 25, left: 5),
                                      child: CustomComponents.displayText(
                                        ProjectStrings
                                            .rentals_header_verified_button,
                                        color: Color(int.parse(
                                            ProjectColors.greenButtonMain
                                                .substring(2),
                                            radix: 16)),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          "lib/assets/pictures/home_top_image.png",
                          fit: BoxFit
                              .contain, // Ensure the image fits within its container
                        ),
                      ),
                    ],
                  ),
                ),

                //  main profile section
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        //  profile image
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                            debugPrint("Image URL: $_imageUrl");
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: _imageUrl != null
                                ? CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(_imageUrl!), // Display image from URL
                            )
                                : const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage('lib/assets/pictures/user_info_user.png'), // Default image
                            ),
                          ),
                        ),
                        //  name
                        CustomComponents.displayText("${_currentUserInfo?.firstName} ${_currentUserInfo?.lastName}",
                            fontWeight: FontWeight.bold, fontSize: 14),
                        //  gray line
                        const SizedBox(height: 20),
                        Container(
                          color: Color(int.parse(
                              ProjectColors.lineGray.substring(2),
                              radix: 16)),
                          height: 1,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 15),

                        //  full name
                        _mainPanelItem(ProjectStrings.user_info_full_name_title,
                            "${_currentUserInfo?.firstName} ${_currentUserInfo?.lastName}"),

                        //  registered number
                        _mainPanelItem(
                            ProjectStrings.user_info_registered_number_title,
                            _currentUserInfo!.number.toString()),

                        //  email address
                        _mainPanelItem(ProjectStrings.user_info_email_address_title,
                            _currentUserInfo!.email),

                        //  rental count
                        _mainPanelItem(ProjectStrings.user_info_rental_count_title,
                            _currentUserInfo!.rentalCount.isEmpty ? "NA" : _currentUserInfo!.rentalCount),

                        //  favorite
                        _mainPanelItem(ProjectStrings.user_info_favorite_title,
                            _currentUserInfo!.favorite.isEmpty ? "NA" : _currentUserInfo!.favorite),

                        //  longest rental period
                        _mainPanelItem(
                            ProjectStrings.user_info_longest_rental_period_title,
                            _currentUserInfo!.longestRentalDate.isEmpty ? "NA" : _currentUserInfo!.longestRentalDate),

                        //  total amount spent
                        Padding(
                          padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.user_info_total_amount_spent_title,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Color(int.parse(
                                      ProjectColors.lightGray.substring(2),
                                      radix: 16))),
                              CustomComponents.displayText(
                                  _currentUserInfo!.totalAmountSpent.isEmpty ? "NA" : _currentUserInfo!.totalAmountSpent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color(int.parse(
                                      ProjectColors.mainColorHex.substring(2),
                                      radix: 16)))
                            ],
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),

                //  bottom panel
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //  item 1
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 40, top: 20, bottom: 20, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed("to_report");
                              },
                              child: _bottomPanelItem(
                                  "lib/assets/pictures/user_info_report.png",
                                  Color(int.parse(
                                      ProjectColors.userInfoRed.substring(2),
                                      radix: 16)),
                                  ProjectStrings.user_info_report),
                            )),

                        //  item 2
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 20, bottom: 20, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              _showContactBottomDialog();
                            },
                            child: _bottomPanelItem(
                                "lib/assets/pictures/user_info_email.png",
                                Color(int.parse(
                                    ProjectColors.userInfoGreen.substring(2),
                                    radix: 16)),
                                ProjectStrings.user_info_contact),
                          ),
                        ),

                        //  item 3
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, bottom: 20, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => termsAndCondition(context, 2)
                                );
                              },
                              child: _bottomPanelItem(
                                  "lib/assets/pictures/user_info_policy.png",
                                  Color(int.parse(
                                      ProjectColors.userInfoBlue.substring(2),
                                      radix: 16)),
                                  ProjectStrings.user_info_policy),
                            )),

                        //  item 4
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, bottom: 20, right: 40),
                            child: GestureDetector(
                              onTap: () async {
                                LoadingDialog().show(context: context, content: "Please wait while we retrieve your documents.");
                                List<String> files = await Storage().getUserFiles();
                                _originalFilePaths.clear();
                                files.asMap().forEach((index, value) {
                                  _originalFilePaths.add(value);

                                  _fileIcons[index] = value.split(".").last;
                                  _fileNames[index] = value.split("/")[5];
                                });

                                LoadingDialog().dismiss();

                                _seeUploadDocumentsDialog(_originalFilePaths);
                              },
                              child: _bottomPanelItem(
                                  "lib/assets/pictures/user_info_documents.png",
                                  Color(int.parse(
                                      ProjectColors.userInfoLightBlue.substring(2),
                                      radix: 16)),
                                  ProjectStrings.user_info_documents),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}