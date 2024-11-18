import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/account/register_model.dart";
import "package:dara_app/view/pages/admin/manage/inquiries/pdf_viewer.dart";
import "package:dio/dio.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

import "../../../../../controller/admin_manage/inquiries/inquiries.dart";
import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/accountant/accountant.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../../model/renting_proccess/renting_process.dart";
import "../../../../../services/firebase/firestore.dart";
import "../../../../../services/firebase/storage.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/loading.dart";
import "../../../../shared/strings.dart";

class ViewInquiry extends StatefulWidget {
  final RentInformation rentInfo;
  const ViewInquiry({
    Key? key,
    required this.rentInfo
  }) : super(key: key);

  @override
  State<ViewInquiry> createState() => _ViewInquiryState();
}

class _ViewInquiryState extends State<ViewInquiry> {
  late RegisterModel userInfo;
  late List<Map<String, dynamic>> submittedFiles;
  final TextEditingController _denyController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      retrieveRentInformation();
    });
  }

  Future<void> retrieveRentInformation() async {
    LoadingDialog().show(context: context, content: "Retrieving complete rent information. Please wait a moment.");
    try {
      userInfo = (await Firestore().getUserInfo(widget.rentInfo.renterUID))!;
      submittedFiles = await Storage().getUserFilesForInquiry(
        FirebaseConstants.rentDocumentsUpload, widget.rentInfo.renterUID,
      );
      setState(() {
        _isLoading = false;
      });
    } catch(e) {
      InfoDialog().show(context: context, content: "An error occurred: $e");
      debugPrint("Error@view_inquiry.dart@retrieveRentInformation@ln63");
    } finally {
      LoadingDialog().dismiss();
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText("Review Renter Profile",
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      "View all the information and documents of the renter", fontSize: 10),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(child: _renterInfoItem()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Future<void> updateDenyDB(RentInformation rentInformation) async {
    await updateRentNotes(
      rentRenterUID: rentInformation.renterUID,
      rentStartDateTime: rentInformation.startDateTime,
      rentEndDateTime: rentInformation.endDateTime,
      rentDeliveryLocation: rentInformation.deliveryLocation,
      rentRentLocation: rentInformation.rentLocation,
      rentTotalAmount: rentInformation.totalAmount,
      updatedNotes: _denyController.value.text
    );
  }

  Future<void> updateRentNotes({
    required String rentRenterUID,
    required String rentStartDateTime,
    required String rentEndDateTime,
    required String rentDeliveryLocation,
    required String rentRentLocation,
    required String rentTotalAmount,
    required String updatedNotes,
  }) async {
    try {
      // Reference to the Firestore collection
      final rentRecordsRef = FirebaseFirestore.instance.collection('dara-rent-records');

      // Query the collection with the provided field values
      final querySnapshot = await rentRecordsRef
          .where('rent_renterUID', isEqualTo: rentRenterUID)
          .where('rent_startDateTime', isEqualTo: rentStartDateTime)
          .where('rent_endDateTime', isEqualTo: rentEndDateTime)
          .where('rent_deliveryLocation', isEqualTo: rentDeliveryLocation)
          .where('rent_rentLocation', isEqualTo: rentRentLocation)
          .where('rent_totalAmount', isEqualTo: rentTotalAmount)
          .get();

      // Check if documents match the query
      if (querySnapshot.docs.isEmpty) {
        CustomComponents.showToastMessage("No matching documents found.", Colors.red, Colors.white);
        return;
      }

      // Iterate through the matched documents and update the rent_notes field
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          "rent_notes": updatedNotes,
          "rent_status": "declined"
        });
        CustomComponents.showToastMessage("Updated rent_notes for document ID: ${doc.id}", Colors.green, Colors.white);
      }
    } catch (e) {
      InfoDialog().show(context: context, content: "Error updating rent_notes: $e");
    }
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

  Widget _renterInfoItem() {
    RentInformation currentItem = widget.rentInfo;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
      )
          : ListView(
        padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                      "1",
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
                      buildInfoRow(ProjectStrings.ri_name_title, "${userInfo.firstName} ${userInfo.lastName}"),
                      buildInfoRow(ProjectStrings.ri_email_title, userInfo.email),
                      buildInfoRow(ProjectStrings.ri_phone_number_title, userInfo.number),
                      buildInfoRow("Car Unit:", currentItem.carName),
                      buildInfoRow("Car Owner:", currentItem.carOwner),
                      buildInfoRow("Role:", userInfo.role),
                      buildInfoRow("Rent Location:", currentItem.rentLocation),
                      buildInfoRow("Est. Driving Distance:", currentItem.estimatedDrivingDistance),
                      buildInfoRow("Est. Driving Duration:", currentItem.estimatedDrivingDuration),
                      buildInfoRow(ProjectStrings.ri_rent_start_date_title, currentItem.startDateTime),
                      buildInfoRow(ProjectStrings.ri_rent_end_date_title, currentItem.endDateTime),
                      buildInfoRow(ProjectStrings.ri_delivery_mode_title, currentItem.pickupOrDelivery),
                      buildInfoRow(ProjectStrings.ri_delivery_location_title, currentItem.deliveryLocation),
                      buildInfoRow(ProjectStrings.ri_reserved_title, currentItem.reservationFee == "0" ? "No" : "Yes"),
                      buildInfoRow("With Driver:", currentItem.withDriver.toLowerCase() == "no" ? "No" : "Yes"),
                      buildInfoRow("Driver Fee:", currentItem.driverFee),
                      buildInfoRow("Total Amount:", currentItem.totalAmount),
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
                                _showDeclineBottomDialog(context, currentItem);
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
                                        await updateDB(currentItem);
                                        LoadingDialog().dismiss();
                                        Navigator.of(context).pop();
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
              ),
              const SizedBox(height: 50),
            ]
          ),
    );
  }

  Future _showDeclineBottomDialog(BuildContext parentContext, RentInformation currentItem) {
    return showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true, // Ensures it respects its content size
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          "lib/assets/pictures/home_top_report.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomComponents.displayText(
                          "Please provide a note explaining why this rent application was declined. (Optional)",
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomComponents.displayText(
                      "Message",
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(int.parse(
                          ProjectColors.blackHeader.substring(2), radix: 16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomComponents.displayTextField(
                    "Your message",
                    controller: _denyController,
                    labelColor: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                    maxLength: 50
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        InfoDialog().showDecoratedTwoOptionsDialog(
                          context: context,
                          content: "Are you sure you want to proceed with this option? This action cannot be undone!",
                          header: "Confirm Action",
                          confirmAction: () async {
                            Navigator.of(context).pop();
                            try {
                              await updateDenyDB(currentItem);
                              Navigator.of(parentContext).pop();
                            } catch(e) {
                              InfoDialog().show(
                                context: parentContext,
                                content: "An error occurred while updating the records. Please try again later. Error details: $e",
                              );
                            }
                          }
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color(int.parse(
                              ProjectColors.mainColorHex
                                  .substring(2),
                              radix: 16)),
                        ),
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(17),
                        child: CustomComponents.displayText(
                          "Update Rent Record",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
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
            "Renter Profile",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
