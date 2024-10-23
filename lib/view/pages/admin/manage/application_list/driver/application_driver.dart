import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/model/outsource/OutsourceApplication.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dio/dio.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

import "../../../../../../model/driver/driver_application.dart";
import "../../../../../../services/firebase/storage.dart";
import "../../../../../shared/colors.dart";
import "../../../../../shared/components.dart";
import "../../../../../shared/strings.dart";
import "../../inquiries/pdf_viewer.dart";

class ApplicationDriver extends StatefulWidget {
  const ApplicationDriver({super.key});

  @override
  State<ApplicationDriver> createState() => _ApplicationDriverState();
}

class _ApplicationDriverState extends State<ApplicationDriver> {
  late DriverApplication _driverApplicantData;
  List<Map<String, dynamic>> submittedFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      retrieveApplicantInfo();
    });
  }

  Future<void> retrieveApplicantInfo() async {
    try {
      LoadingDialog().show(context: context, content: "Please wait while we retrieve the applicant's data");
      DocumentSnapshot docSnapshot  = await FirebaseFirestore.instance.collection(FirebaseConstants.driverApplication)
          .doc(PersistentData().selectedApplicantUID)
          .get();

      List<Map<String, dynamic>> userFiles = await Storage().getUserFilesForInquiry("driver_application", PersistentData().selectedApplicantUID);

      setState(() {
        submittedFiles = userFiles;
        _driverApplicantData = DriverApplication.fromFirestore(docSnapshot.data() as Map<String, dynamic>);
        _isLoading = false;
      });
      LoadingDialog().dismiss();
    } catch(e) {
      LoadingDialog().dismiss();
      debugPrint("Error@retrieveApplicantInfo()@application_driver.dart");
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

              Expanded(
                child: _isLoading ? Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
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
                                "No records found at the moment. Please try again later.",
                                fontWeight: FontWeight.bold,
                                fontSize: 10
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      ),
                    ),
                  ),
                ) : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // title and sub-header
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.application_list_driver_outsource_detailed_info_header,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.application_list_driver_outsource_detailed_info_subheader,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    // body
                    const SizedBox(height: 20),
                    _applicantInfoContainer(context),
                    const SizedBox(height: 20),
                    _approveDeclineButton(),
                    const SizedBox(height: 75),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _approveDeclineButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //  decline
        GestureDetector(
          onTap: () {
            InfoDialog().showDecoratedTwoOptionsDialog(
                context: context,
                content: ProjectStrings.application_list_dialog_subheader,
                header: ProjectStrings.application_list_dialog_header,
                confirmAction: () async {
                  await FirebaseFirestore.instance.collection(FirebaseConstants.driverApplication)
                      .doc(PersistentData().selectedApplicantUID)
                      .update({
                    "application_status": "declined"
                  });
                  Navigator.of(context).pop();
                }
            );
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(5),
                color: Color(int.parse(
                    ProjectColors
                        .redButtonBackground
                        .substring(2),
                    radix: 16)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40),
                    child: Image.asset(
                      "lib/assets/pictures/rentals_denied.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 45,
                          left: 10),
                      child: CustomComponents
                          .displayText(
                        ProjectStrings.application_list_driver_outsource_detailed_info_decline,
                        color: Color(int.parse(
                            ProjectColors
                                .redButtonMain
                                .substring(2),
                            radix: 16)),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),

        //  approve
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            InfoDialog().showDecoratedTwoOptionsDialog(
              context: context,
              content: ProjectStrings.application_list_dialog_subheader,
              header: ProjectStrings.application_list_dialog_header,
              confirmAction: () async {
                await FirebaseFirestore.instance.collection(FirebaseConstants.driverApplication)
                    .doc(PersistentData().selectedApplicantUID)
                    .update({
                      "application_status": "approved"
                    });
                Navigator.of(context).pop();
              }
            );
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(10),
                color: Color(int.parse(
                    ProjectColors.lightGreen
                        .substring(2),
                    radix: 16)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40),
                    child: Image.asset(
                      "lib/assets/pictures/rentals_verified.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        right: 45,
                        left: 10),
                    child: CustomComponents
                        .displayText(
                      ProjectStrings.application_list_driver_outsource_detailed_info_approve,
                      color: Color(int.parse(
                          ProjectColors
                              .greenButtonMain
                              .substring(2),
                          radix: 16)),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }

  Widget _applicantInfoContainer(BuildContext context) {
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: CustomComponents.displayText(
                    ProjectStrings.application_list_driver_personal_information_title,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 5),
              _infoField(ProjectStrings.application_list_driver_name_title, "${_driverApplicantData.piFirstName} ${_driverApplicantData.piMiddleName} ${_driverApplicantData.piLastName}"),
              _infoField(ProjectStrings.application_list_driver_address_title, _driverApplicantData.piCompleteAddress),
              _infoField(ProjectStrings.application_list_driver_birthday_title, _driverApplicantData.piBirthday),
              _infoField(ProjectStrings.application_list_driver_civil_status_title, _driverApplicantData.piCivilStatus),
              _infoField(ProjectStrings.application_list_driver_contact_number_title, _driverApplicantData.ecContactNumber),
              _infoField(ProjectStrings.application_list_driver_father_name_title, _driverApplicantData.piFatherName),
              _infoField(ProjectStrings.application_list_driver_father_birthplace_title, _driverApplicantData.piFatherBirthplace),
              _infoField(ProjectStrings.application_list_driver_mother_name_title, _driverApplicantData.piMotherName),
              _infoField(ProjectStrings.application_list_driver_mother_birthplace_title, _driverApplicantData.piMotherBirthplace),
              _infoField(ProjectStrings.application_list_driver_educ_attainment_title, _driverApplicantData.epiEducationAttainment),
              _infoField(ProjectStrings.application_list_driver_email_add_title, _driverApplicantData.piEmailAddress),
              _infoField(ProjectStrings.application_list_driver_religion_title, _driverApplicantData.piReligion),
              _infoField(ProjectStrings.application_list_driver_height_title, _driverApplicantData.piHeight),
              _infoField(ProjectStrings.application_list_driver_weight_title, _driverApplicantData.piWeight),
              _infoField(ProjectStrings.application_list_driver_driver_license_title, _driverApplicantData.epiDriverLicense),
              _infoField(ProjectStrings.application_list_driver_sss_number_title, _driverApplicantData.epiSSSNumber),
              _infoField(ProjectStrings.application_list_driver_tin_number_title, _driverApplicantData.epiTINNumber),

              //  second list of items
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: CustomComponents.displayText(
                      ProjectStrings.application_list_driver_emergency_contact_title,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              _infoField(ProjectStrings.application_list_driver_ec_name_title, _driverApplicantData.ecNameContactPerson),
              _infoField(ProjectStrings.application_list_driver_ec_relationship_to_the_applicant_title, _driverApplicantData.ecRelationship),
              _infoField(ProjectStrings.application_list_driver_ec_contact_number_title, _driverApplicantData.ecContactNumber),
              _infoField(ProjectStrings.application_list_driver_ec_address_title, _driverApplicantData.ecCompleteAddress),

              const SizedBox(height: 20),
              _attachedDocumentsSection(),
              const SizedBox(height: 15),
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
                    "${_driverApplicantData.piFirstName} ${_driverApplicantData.piLastName}",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    ProjectStrings.application_list_driver,
                    color: Color(int.parse(ProjectColors.userListDriverHex.substring(2), radix: 16)),
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
            ProjectStrings.application_list_driver_outsource_detailed_info_applicant_info,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
