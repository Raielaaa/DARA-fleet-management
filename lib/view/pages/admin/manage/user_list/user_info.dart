import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/home/home_controller.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:dio/dio.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";
import 'package:cloud_functions/cloud_functions.dart';

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../../services/firebase/storage.dart";
import "../inquiries/pdf_viewer.dart";

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<Map<String, dynamic>> submittedFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      retrieveUserFiles();
    });
  }

  Future<void> retrieveUserFiles() async {
    LoadingDialog().show(context: context, content: "Please wait while we retrieve the users information");
    List<Map<String, dynamic>> userFiles = await Storage().getUserFilesForInquiry(FirebaseConstants.rentDocumentsUpload, PersistentData().selectedUser!.id);
    LoadingDialog().dismiss();

    // Add the data to a temporary list
    setState(() {
      submittedFiles = userFiles;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              _actionBar(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _headerSection(),
                    const SizedBox(height: 20),
                    _renterInfoContainer(context),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteUser(String uid) async {
    if (uid.isEmpty) {
      debugPrint('UID is empty');
      return;
    }

    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('deleteUser');
      debugPrint("UID to be deleted: $uid");
      debugPrint("Calling Cloud Function with data: {'uid': $uid}");
      final response = await callable.call(<String, dynamic>{'uid': uid});

      if (response.data['error'] != null) {
        debugPrint('Cloud Function error: ${response.data['error']}');
      } else {
        debugPrint(response.data['message']);
      }
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  void showConfirmDialog() {
    InfoDialog().showDecoratedTwoOptionsDialog(
      context: context,
      content: ProjectStrings.income_page_confirm_delete_content,
      header: ProjectStrings.income_page_confirm_delete,
      confirmAction: () async {
        try {
          // Access the Firestore instance and specify the collection and document ID
          await FirebaseFirestore.instance
              .collection(FirebaseConstants.registerCollection)
              .doc(PersistentData().selectedUser!.id)
              .delete();
          // await deleteUser(PersistentData().selectedUser!.id);

          debugPrint('Document has been successfully removed.');
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: CustomComponents.displayText(
                "The selected record has been deleted successfully.",
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        } catch (e) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: CustomComponents.displayText(
                "An error occurred while trying to delete the record. Please try again. $e",
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
          debugPrint('Error deleting document: $e');
        }
      },
    );
  }

  Widget _actionBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
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
            ProjectStrings.admin_user_info_user_list,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }

  Widget _headerSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomComponents.displayText(ProjectStrings.ri_title,
                fontWeight: FontWeight.bold, fontSize: 12),
            const SizedBox(height: 3),
            CustomComponents.displayText(ProjectStrings.ri_subheader,
                fontSize: 10),
          ],
        ),
      ),
    );
  }

  int calculateAge(String birthDateString) {
    // Parse the input date string to a DateTime object
    DateFormat dateFormat = DateFormat("MMMM d, yyyy");
    DateTime birthDate = dateFormat.parse(birthDateString);

    // Get the current date
    DateTime today = DateTime.now();

    // Calculate the age
    int age = today.year - birthDate.year;

    // Adjust the age if the birthdate hasn't occurred yet this year
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Widget _renterInfoContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Expanded(
          child: _isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
            ),
          ) : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _renterInfoRow(),
              Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
              _infoField("Account UID", "${PersistentData().selectedUser?.id}"),
              _infoField(ProjectStrings.ri_name_title, "${PersistentData().selectedUser?.firstName} ${PersistentData().selectedUser?.lastName}"),
              _infoField(ProjectStrings.ri_email_title, "${PersistentData().selectedUser?.email}"),
              _infoField(ProjectStrings.ri_phone_number_title, "${PersistentData().selectedUser?.number}"),
              _infoField("Role", "${PersistentData().selectedUser?.role}"),
              _infoField("Birthday", PersistentData().selectedUser?.birthday ?? ""),
              _infoField(ProjectStrings.admin_user_info_age_title, PersistentData().selectedUser!.birthday.isNotEmpty ? "${calculateAge(PersistentData().selectedUser!.birthday)} years old" : ""),
              _infoField(ProjectStrings.admin_user_info_account_status_title, "${PersistentData().selectedUser?.status}"),
              _infoField(ProjectStrings.admin_user_info_date_registered_title, "${PersistentData().selectedUser?.dateCreated}"),
          
              const SizedBox(height: 20),
              _attachedDocumentsSection(),
          
              const SizedBox(height: 10),
              _bottomPanel(context),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renterInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100)
            ),
            width: 40,
            height: 40,
            child: Image.asset(
              "lib/assets/pictures/user_info_user.png",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    "${PersistentData().selectedUser?.firstName} ${PersistentData().selectedUser?.lastName}",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    CustomComponents.capitalizeFirstLetter(PersistentData().selectedUser!.role),
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(title,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))),
          CustomComponents.displayText(value,
              fontWeight: FontWeight.bold, fontSize: 10),
        ],
      ),
    );
  }

  Widget _attachedDocumentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomComponents.displayText(ProjectStrings.ri_attached_document,
              fontWeight: FontWeight.bold, fontSize: 12),

          ...submittedFiles.map((file) {
            return displayDocuments(
              file["storageLocation"],
              (file["fileSize"] / 1024).toStringAsFixed(2),
              DateFormat("MMMM dd, yyyy | hh:mm a").format(file["uploadDate"]).toString(),
            );
          }),
        ],
      ),
    );
  }

  Widget displayDocuments(String? documentName, String fileSize, String fileDateUploaded) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomComponents.displayText(documentName!.split(".").last.toUpperCase(),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      documentName?.split("/").last ?? "Empty",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          fontFamily: ProjectStrings.general_font_family
                      ),
                    ),
                    Row(
                      children: [
                        CustomComponents.displayText("$fileSize KB",
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16))),
                        const SizedBox(width: 20),
                        CustomComponents.displayText(
                            fileDateUploaded,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)))
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          //  view text
          GestureDetector(
            onTap: () {
              viewDocument(documentName);
            },
            child: CustomComponents.displayText(ProjectStrings.ri_view,
                color: Color(int.parse(ProjectColors.mainColorHex.substring(2),
                    radix: 16)),
                fontSize: 10,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Future<void> viewDocument(String gsUrl) async {
    try {
      // Show loading dialog
      LoadingDialog().show(context: context, content: "Retrieving the document, please wait.");

      // Convert gs:// URL to a download URL
      final ref = FirebaseStorage.instance.refFromURL(gsUrl);
      final downloadUrl = await ref.getDownloadURL();
      LoadingDialog().dismiss();

      // Determine file type based on extension
      String fileExtension = gsUrl.split('.').last.toLowerCase();

      if (fileExtension == 'pdf') {
        // Open PDF viewer for PDF files
        // Download the file to a local path
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/temp_document.pdf';

        // Download the file using Dio
        await Dio().download(downloadUrl, filePath);

        LoadingDialog().dismiss();

        // Open PDF viewer for PDF files
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerScreen(downloadUrl: filePath),
          ),
        );
      } else if (fileExtension == 'doc' || fileExtension == 'docx') {
        LoadingDialog().show(context: context, content: "Please wait while we try to process the document.");
        // Download DOC or DOCX files directly to the app
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/temp_document.$fileExtension';

        // Use Dio to download the document
        await Dio().download(downloadUrl, filePath);
        LoadingDialog().dismiss();

        // Open the downloaded DOC or DOCX file
        final result = await OpenFile.open(filePath);
        // if (result.message != 'Success') {
        //   // Handle the case where the file couldn't be opened
        //   InfoDialog().show(
        //     context: context,
        //     content: "Could not open the document.",
        //     header: "Error",
        //   );
        // }
      } else {
        // Handle image files (PNG, JPG, JPEG)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: CachedNetworkImage(
                imageUrl: downloadUrl,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          },
        );
      }
    } catch (e) {
      LoadingDialog().dismiss();
      debugPrint("Error fetching download URL: $e");
      // Show an error dialog
      InfoDialog().show(
        context: context,
        content: "Something went wrong while retrieving the document.",
        header: "Error",
      );
    }
  }

  HomeController homeController = HomeController();
  Widget _bottomPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _bottomPanelItem(
            "lib/assets/pictures/user_info_edit.png",
            ProjectColors.userInfoLightBlue,
            ProjectStrings.admin_user_info_edit,
            () {
              Navigator.of(context).pushNamed("manage_user_info_edit", arguments: submittedFiles);
            }
          ),
          const SizedBox(width: 18),
          _bottomPanelItem(
            "lib/assets/pictures/delete.png",
            ProjectColors.userInfoRed,
            ProjectStrings.admin_user_info_delete,
            () {
              showConfirmDialog();
            }
          ),
          const SizedBox(width: 18),
          _bottomPanelItem(
            "lib/assets/pictures/user_info_email.png",
            ProjectColors.userInfoGreen,
            ProjectStrings.user_info_contact,
            () {
              homeController.showContactBottomDialog(
                context,
                email: PersistentData().selectedUser!.email,
                number: PersistentData().selectedUser!.number
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _bottomPanelItem(String iconPath, String color, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(int.parse(color.substring(2), radix: 16)),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset(iconPath, width: 25, height: 25),
            ),
          ),
          const SizedBox(height: 5),
          CustomComponents.displayText(label, fontSize: 10),
        ],
      ),
    );
  }
}