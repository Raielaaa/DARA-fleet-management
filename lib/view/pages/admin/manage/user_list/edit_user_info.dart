import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/home/home_controller.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/services/firebase/storage.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:dio/dio.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../shared/loading.dart";
import "../inquiries/pdf_viewer.dart";

class EditUserInfo extends StatefulWidget {
  const EditUserInfo({super.key});

  @override
  State<EditUserInfo> createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  List<Map<String, dynamic>> submittedFiles = [];
  Map<String, String> userInfo = {};
  Map<String, TextEditingController> controllers = {};
  final List<String> documentsToDelete = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is List<Map<String, dynamic>>) {
        setState(() {
          submittedFiles = args;

          userInfo = {
            "name": "${PersistentData().selectedUser?.firstName} ${PersistentData().selectedUser?.lastName}",
            "phone_number": "${PersistentData().selectedUser?.number}",
            "role": "${PersistentData().selectedUser?.role}",
            "birthday": "${PersistentData().selectedUser?.birthday}",
            "age": "${calculateAge(PersistentData().selectedUser!.birthday)}",
            "account_status": "${PersistentData().selectedUser?.status}",
            "date_registered": "${PersistentData().selectedUser?.dateCreated}",
          };

          userInfo.forEach((key, value) {
            controllers[key] = TextEditingController(text: value);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose of all TextEditingControllers
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
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
                    _bottomSection(),
                    const SizedBox(height: 10),
                    confirmCancelButtons(),
                    const SizedBox(height: 80)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void removeDocuments(String documentPath) {
    setState(() {
      documentsToDelete.add(documentPath);
    });
  }

  Future<void> updateMultipleFields({
    required String collectionPath,
    required String documentID,
    required Map<String, dynamic> updateData
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(documentID)
          .update(updateData);
    } catch(e) {
      debugPrint("An error occurred: $e");
    }
  }

  Future<void> updateDB() async {
    debugPrint("entry-1");
    try {
      debugPrint("entry-2");
      // Delete documents from Firebase Storage
      for (var document in documentsToDelete) {
        await FirebaseStorage.instance.refFromURL(document).delete();
      }

      debugPrint("entry-3");
      // Prepare update data
      final updateData = {
        "user_birthday": userInfo["birthday"],
        "user_date_created": userInfo["date_registered"],
        "user_firstname": userInfo["name"]?.split(" ").sublist(0, userInfo["name"]!.split(" ").length - 1).join(' '),
        "user_lastname": userInfo["name"]?.split(" ").last,
        "user_number": userInfo["phone_number"],
        "user_role": userInfo["role"],
        "user_status": userInfo["account_status"]
      };

      debugPrint("entry-4");
      // Update Firestore records
      await updateMultipleFields(
        collectionPath: FirebaseConstants.registerCollection,
        documentID: PersistentData().selectedUser!.id,
        updateData: updateData,
      );
      debugPrint("entry-5");
      setState(() {
        documentsToDelete.clear();
      });
      LoadingDialog().dismiss();
      debugPrint("entry-6");
      // Show success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: CustomComponents.displayText(
              "Documents have been updated successfully.",
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
        ),
      );
    } catch (e) {
      debugPrint("Error updating records: $e");
      LoadingDialog().dismiss();
      InfoDialog().show(context: context, content: "An unexpected error occurred: $e");
    } finally {
      debugPrint("entry-7");
      LoadingDialog().dismiss();
    }
  }

  Widget confirmCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(int.parse(ProjectColors.confirmActionCancelBackground.substring(2), radix: 16))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
              child: CustomComponents.displayText(
                  ProjectStrings.income_page_confirm_delete_cancel,
                  color: Color(int.parse(ProjectColors.confirmActionCancelMain.substring(2), radix: 16)),
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ),
        const SizedBox(width: 30),
        GestureDetector(
          onTap: () {
            InfoDialog().showDecoratedTwoOptionsDialog(
              context: context,
              content: ProjectStrings.edit_user_info_dialog_content,
              header: ProjectStrings.edit_user_info_dialog_header,
                confirmAction: () async {
                  await updateDB();
                  Navigator.of(context).pop();
                }
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
              child: CustomComponents.displayText(
                  "Save",
                  color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          children: [
            _renterInfoRowForBottomPanel(),
            Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
            _attachedDocumentsSection(),
            const SizedBox(height: 20),
          ],
        ),
      )
    );
  }

  void showConfirmDialog() {
    InfoDialog().showDecoratedTwoOptionsDialog(
        context: context,
        content: ProjectStrings.income_page_confirm_delete_content,
        header: ProjectStrings.income_page_confirm_delete
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
              PersistentData().openDrawer(3);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
          ),
          CustomComponents.displayText(
            ProjectStrings.edit_user_info_appbar_title,
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
            CustomComponents.displayText(ProjectStrings.edit_user_info_header,
                fontWeight: FontWeight.bold, fontSize: 12),
            const SizedBox(height: 3),
            CustomComponents.displayText(ProjectStrings.edit_user_info_subheader,
                fontSize: 10),
          ],
        ),
      ),
    );
  }

  Widget _renterInfoContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _renterInfoRow(),
              Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
              _infoField(ProjectStrings.ri_name_title.split(":")[0], "name"),
              _infoField(ProjectStrings.ri_phone_number_title.split(":")[0], "phone_number"),
              _infoField("Role", "role"),
              _infoField("Birthday", "birthday"),
              _infoField(ProjectStrings.admin_user_info_age_title.split(":")[0], "age"),
              _infoField(ProjectStrings.admin_user_info_account_status_title.split(":")[0], "account_status"),
              _infoField(ProjectStrings.admin_user_info_date_registered_title.split(":")[0], "date_registered"),

              const SizedBox(height: 20)
            ],
          ),
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

  Widget _renterInfoRowForBottomPanel() {
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
            child: Icon(
              Icons.folder_copy,
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              size: 25,
            )
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    ProjectStrings.edit_user_info_attached_documents,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    ProjectStrings.edit_user_info_attached_documents_subheader,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ],
            ),
          ),
        ],
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
                    PersistentData().selectedUser!.role,
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

  Widget _infoField(String title, String key) {
    // Retrieve the corresponding TextEditingController
    final controller = controllers[key] ?? TextEditingController();

    // Format function for date
    String formatDate(DateTime date) {
      return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
    }

    // Function to parse the formatted date back to DateTime
    DateTime? parseFormattedDate(String date) {
      try {
        return DateTime.parse(date);
      } catch (e) {
        return null; // If parsing fails, return null
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
          ),
          const SizedBox(height: 10),
          key == "birthday"
              ? GestureDetector(
            onTap: () async {
              // Get the initial date for the date picker
              DateTime initialDate = controller.text.isNotEmpty
                  ? (parseFormattedDate(controller.text) ?? DateTime.now())
                  : DateTime.now();

              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (selectedDate != null) {
                setState(() {
                  String formattedDate = formatDate(selectedDate);
                  userInfo[key] = formattedDate; // Store the formatted date
                  controller.text = formattedDate; // Update the controller
                });
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Select your birthday",
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(bottom: 13),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontFamily: ProjectStrings.general_font_family
                ),
              ),
            ),
          )
              : key == "account_status"
              ? DropdownButtonFormField<String>(
            value: userInfo[key]?.toLowerCase() == "verified" ? "verified" : "unverified",
            items: const [
              DropdownMenuItem(
                value: "verified",
                child: Text(
                  "Verified",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1D1D1D),
                    fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "unverified",
                child: Text(
                  "Unverified",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF1D1D1D),
                    fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  userInfo[key] = newValue;
                  controller.text = newValue; // Update the controller
                });
              }
            },
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                ),
              ),
              contentPadding: const EdgeInsets.only(bottom: 13),
              isDense: true,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family
            ),
          )
              : key == "role" ? DropdownButtonFormField<String>(
            value: userInfo[key]?.toLowerCase(),
            items: const [
              DropdownMenuItem(
                value: "renter",
                child: Text(
                  "Renter",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D1D1D),
                      fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "outsource",
                child: Text(
                  "Outsource",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D1D1D),
                      fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "driver",
                child: Text(
                  "Driver",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D1D1D),
                      fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              )
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  userInfo[key] = newValue;
                  controller.text = newValue; // Update the controller
                });
              }
            },
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                ),
              ),
              contentPadding: const EdgeInsets.only(bottom: 13),
              isDense: true,
            ),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                fontFamily: ProjectStrings.general_font_family
            ),
          ) : TextFormField(
            keyboardType: key == "age"
                ? const TextInputType.numberWithOptions()
                : TextInputType.text,
            controller: controller,
            onChanged: (newValue) {
              // Update userInfo with the new value
              userInfo[key] = newValue;
            },
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                ),
              ),
              contentPadding: const EdgeInsets.only(bottom: 13),
              isDense: true,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family
            ),
          ),
        ],
      ),
    );
  }

// Helper list for month names
  final List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  Widget _attachedDocumentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  viewDocument(documentName);
                },
                child: CustomComponents.displayText(ProjectStrings.ri_view,
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2),
                        radix: 16)),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  InfoDialog().showWithCancelProceedButton(
                    context: context,
                    content: "Are you sure want to proceed? This action cannot be undone.",
                    header: "Warning",
                    actionCode: 1,
                    onProceed: () {
                      setState(() {
                        removeDocuments(documentName);
                        submittedFiles.removeWhere((file) => file["storageLocation"] == documentName);
                      });
                      InfoDialog().dismiss();
                    });
                },
                child: CustomComponents.displayText(ProjectStrings.edit_user_info_delete,
                    color: Color(int.parse(ProjectColors.redButtonMain.substring(2),
                        radix: 16)),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
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
}
