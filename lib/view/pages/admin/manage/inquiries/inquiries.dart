import "package:cached_network_image/cached_network_image.dart";
import "package:dara_app/controller/admin_manage/inquiries/inquiries.dart";
import "package:dara_app/model/account/register_model.dart";
import "package:dara_app/model/accountant/accountant.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:dara_app/view/pages/admin/manage/inquiries/pdf_viewer.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import "package:slide_switcher/slide_switcher.dart";
import 'package:open_file/open_file.dart';

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../../model/renting_proccess/renting_process.dart";
import "../../../../../services/firebase/storage.dart";

class Inquiries extends StatefulWidget {
  const Inquiries({super.key});

  @override
  State<Inquiries> createState() => _InquiriesState();
}

class _InquiriesState extends State<Inquiries> {
  RegisterModel? _userInfoTemp;
  List<RentInformation> ongoingInquiry = [];
  List<RentInformation> pastDuesInquiry = [];
  List<Map<String, dynamic>> _submittedFiles = [];

  List<RentInformation> rentInformationList = [];
  List<Map<String, dynamic>> inquiriesWithUserData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _retrieveRentRecords();
    });
  }

  Future<void> _retrieveRentRecords() async {
    try {
      // Show loading dialog
      LoadingDialog().show(
        context: context,
        content: "Retrieving rent inquiries. Please wait a moment.",
      );

      // Retrieve all rent records
      List<RentInformation> pendingRecords = [];

      List<RentInformation> records = await Firestore().getRentRecords();
      records.forEach((item) {
        if (item.rentStatus.toLowerCase() == "pending") {
          pendingRecords.add(item);
        }
      });
      List<Map<String, dynamic>> tempData = [];

      // Clear existing lists
      ongoingInquiry.clear();
      pastDuesInquiry.clear();

      // Retrieve user data and submitted files for each record
      for (var record in pendingRecords) {
        RegisterModel? userInfo = await Firestore().getUserInfo(record.renterUID);
        List<Map<String, dynamic>> userFiles = await Storage().getUserFilesForInquiry(FirebaseConstants.rentDocumentsUpload, record.renterUID);

        // Add the data to a temporary list
        tempData.add({
          'rentInformation': record,
          'userInfo': userInfo,
          'submittedFiles': userFiles,
        });

        // Separate records into ongoing and past dues based on the startDateTime
        if (isDateInPast(record.startDateTime)) {
          pastDuesInquiry.add(record);
        } else {
          ongoingInquiry.add(record);
        }
      }

      if (!mounted) return;

      // Update the state with the initial data (current dues)
      setState(() {
        inquiriesWithUserData = tempData;
        rentInformationList = ongoingInquiry;  // Set the default view to ongoingInquiry
        _isLoading = false;
      });

      // Dismiss the loading dialog
      LoadingDialog().dismiss();
    } catch (e) {
      if (mounted) {
        // Dismiss loading dialog and show error dialog
        LoadingDialog().dismiss();
        InfoDialog().show(
          context: context,
          content: "Something went wrong: $e",
          header: "Warning",
        );
      }
      debugPrint("Error@inquiries.dart@ln45: $e");
    }
  }


  bool isDateInPast(String dateStr) {
    DateFormat format = DateFormat("MMMM d, yyyy | hh:mm a");
    DateTime parsedDate = format.parse(dateStr);
    return parsedDate.isBefore(DateTime.now());
  }

  Widget buildInfoRow(String title, String value, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: Color(int.parse(
              ProjectColors.lightGray.substring(2),
              radix: 16,
            )),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: CustomComponents.displayText(
              value,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              textAlign: TextAlign.end,
            ),
          ),
        ],
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
          child: _isLoading
              ? Center(
            child: CircularProgressIndicator(
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
            ),
          )
              : Column(
            children: [
              actionBar(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(ProjectStrings.ri_title,
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      ProjectStrings.ri_subheader, fontSize: 10),
                ),
              ),
              // Switch option
              const SizedBox(height: 15),
              // switcher(ongoingInquiry, pastDuesInquiry),
              switcher(),
              const SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: inquiriesWithUserData.isEmpty
                      ? const Center(
                    child: Text(
                      "No inquiries found.",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: rentInformationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final rentInfo = rentInformationList[index]; // Use rentInformationList for rentInfo

                      // Get user info and submitted files using the appropriate logic
                      final userInfo = inquiriesWithUserData
                          .firstWhere((element) => element['rentInformation'] == rentInfo)['userInfo'];
                      final submittedFiles = inquiriesWithUserData
                          .firstWhere((element) => element['rentInformation'] == rentInfo)['submittedFiles'];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Column(
                            children: [
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
                                              ProjectColors.mainColorBackground.substring(2), radix: 16)),
                                          border: Border.all(
                                              color: Color(int.parse(ProjectColors.lineGray)), width: 1),
                                        ),
                                        child: Center(
                                          child: CustomComponents.displayText(
                                              "${index + 1}",
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                            ProjectStrings.ri_renter_information_title,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const SizedBox(height: 2),
                                          CustomComponents.displayText(
                                            ProjectStrings.ri_renter_information_subheader,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray.substring(2), radix: 16)),
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
                                color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                              ),
                              buildInfoRow(ProjectStrings.ri_name_title, "${userInfo?.firstName} ${userInfo?.lastName}"),
                              buildInfoRow(ProjectStrings.ri_email_title, userInfo?.email ?? "N/A"),
                              buildInfoRow(ProjectStrings.ri_phone_number_title, userInfo?.number ?? "N/A"),
                              buildInfoRow("car Unit:", rentInfo.carName),
                              buildInfoRow("Role:", userInfo?.role ?? "N/A"),
                              buildInfoRow("Rent Location:", rentInfo.rentLocation),
                              buildInfoRow(ProjectStrings.ri_rent_start_date_title, rentInfo.startDateTime),
                              buildInfoRow(ProjectStrings.ri_rent_end_date_title, rentInfo.endDateTime),
                              buildInfoRow(ProjectStrings.ri_delivery_mode_title, rentInfo.pickupOrDelivery),
                              buildInfoRow(ProjectStrings.ri_delivery_location_title, rentInfo.deliveryLocation),
                              buildInfoRow(ProjectStrings.ri_reserved_title, rentInfo.reservationFee == "0" ? "No" : "Yes"),
                              buildInfoRow("Total Amount:", rentInfo.totalAmount),
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomComponents.displayText(
                                    ProjectStrings.ri_attached_document,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              ...submittedFiles.map((file) {
                                return displayDocuments(
                                  file["storageLocation"],
                                  (file["fileSize"] / 1024).toStringAsFixed(2),
                                  DateFormat("MMMM dd, yyyy | hh:mm a").format(file["uploadDate"]).toString(),
                                );
                              }),
                              //  add note/approve button
                              const SizedBox(height: 30),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    actionButton(
                                      iconPath: "lib/assets/pictures/rentals_denied.png",
                                      backgroundColor: ProjectColors.redButtonBackground,
                                      labelText: ProjectStrings.ri_add_note,
                                      textColor: ProjectColors.redButtonMain,
                                      onTap: () {
                                        Navigator.pushNamed(context, "rentals_report");
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    actionButton(
                                      iconPath: "lib/assets/pictures/rentals_verified.png",
                                      backgroundColor: ProjectColors.lightGreen,
                                      labelText: ProjectStrings.ri_approve,
                                      textColor: ProjectColors.greenButtonMain,
                                      onTap: () {
                                        InfoDialog().showWithCancelProceedButton(
                                            context: context,
                                            content: "Are you sure you want to approve this rent application? This action cannot be undone, and the applicant will be notified.",
                                            header: "Confirm Approval",
                                            actionCode: 1,
                                            onProceed: () async {
                                              InfoDialog().dismiss();
                                              try {
                                                LoadingDialog().show(
                                                    context: context,
                                                    content: "Please wait while we update renting records"
                                                );
                                                await updateDB(rentInformationList[index]);
                                                LoadingDialog().dismiss();
                                                setState(() {
                                                  for (int i = ongoingInquiry.length - 1; i >= 0; i--) {
                                                    if (
                                                    ongoingInquiry[i].rent_car_UID == rentInformationList[index].rent_car_UID &&
                                                        ongoingInquiry[i].renterUID == rentInformationList[index].renterUID &&
                                                        ongoingInquiry[i].startDateTime == rentInformationList[index].startDateTime &&
                                                        ongoingInquiry[i].estimatedDrivingDistance == rentInformationList[index].estimatedDrivingDistance &&
                                                        ongoingInquiry[i].estimatedDrivingDuration == rentInformationList[index].estimatedDrivingDuration
                                                    ) {
                                                      ongoingInquiry.removeAt(i);
                                                      debugPrint("Item deleted");
                                                    }
                                                  }
                                                });
                                              } catch(e) {
                                                InfoDialog().show(
                                                  context: context,
                                                  content: "An error occurred while updating the records. Please try again later. Error details: $e",
                                                );
                                              }
                                            }
                                        );
                                      },
                                    )
                                  ]
                              ),

                              const SizedBox(height: 30)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateDB(RentInformation rentInformation) async {
    InquiriesController _inquiriesController = InquiriesController();

    try {
      AccountantModel _accountantModel = AccountantModel(
          rentCarName: rentInformation.carName,
          rentCarType: rentInformation.carType,
          rentCarUID: rentInformation.rent_car_UID,
          rentDeliveryDistance: rentInformation.deliveryDistance,
          rentDeliveryDuration: rentInformation.deliveryDuration,
          rentDeliveryFee: rentInformation.deliveryFee,
          rentDeliveryLocation: rentInformation.deliveryLocation,
          rentDriverFee: rentInformation.driverFee,
          rentEndDateTime: rentInformation.endDateTime,
          rentEstimatedDrivingDistance: rentInformation.estimatedDrivingDistance,
          rentEstimatedDrivingDuration: rentInformation.estimatedDrivingDuration,
          rentMileageFee: rentInformation.mileageFee,
          rentNotes: rentInformation.adminNotes,
          rentPickupOrDelivery: rentInformation.pickupOrDelivery,
          rentRentLocation: rentInformation.rentLocation,
          rentRentalFee: rentInformation.rentalFee,
          rentRenterEmail: rentInformation.renterEmail,
          rentRenterUID: rentInformation.renterUID,
          rentReservationFee: rentInformation.reservationFee,
          rentStartDateTime: rentInformation.startDateTime,
          rentStatus: rentInformation.rentStatus,
          rentTotalAmount: rentInformation.totalAmount,
          rentWithDriver: rentInformation.withDriver
      );

      await _inquiriesController.updateDB(
          rentInformation,
          _accountantModel.getModelData()
      );
    } catch(e) {
      debugPrint("Error@inquiries.dart@ln394: $e");
    }
  }

  Widget switcher() {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [
        Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
      ],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      onSelect: (index) {
        setState(() {
          rentInformationList = index == 0 ? ongoingInquiry : pastDuesInquiry;
        });
      },
      children: [
        CustomComponents.displayText(
          "Current Dues",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Past Dues",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }

  Widget displayDocuments(String? documentName, String fileSize, String fileDateUploaded) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Color(int.parse(
                          ProjectColors.mainColorHex.substring(2),
                          radix: 16))),
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

  Widget actionButton({
    required String iconPath,
    required String backgroundColor,
    required String labelText,
    required String textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(int.parse(backgroundColor.substring(2), radix: 16)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, right: 25, left: 5),
              child: CustomComponents.displayText(
                labelText,
                color: Color(int.parse(textColor.substring(2), radix: 16)),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget actionBar() {
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
            ProjectStrings.ri_appbar,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
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
