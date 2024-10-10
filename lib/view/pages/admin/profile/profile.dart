import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/pages/account/register/widgets/terms_and_conditions.dart";
import "package:dara_app/view/pages/admin/profile/upload_documents.dart";
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

  Future<void> _seeUploadDocumentsDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const UploadDocuments();
      },
    );
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
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 12),
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
                                _seeUploadDocumentsDialog();
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