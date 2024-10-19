import "package:cached_network_image/cached_network_image.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:dio/dio.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

import "../../../controller/singleton/persistent_data.dart";
import "../../../model/account/register_model.dart";
import "../../../model/constants/firebase_constants.dart";
import "../../../model/renting_proccess/renting_process.dart";
import "../../../services/firebase/firestore.dart";
import "../../../services/firebase/storage.dart";
import "../../shared/info_dialog.dart";
import "../../shared/loading.dart";
import "../admin/manage/inquiries/pdf_viewer.dart";

class OutsourceInquiries extends StatefulWidget {
  const OutsourceInquiries({super.key});

  @override
  State<OutsourceInquiries> createState() => _OutsourceInquiriesState();
}

class _OutsourceInquiriesState extends State<OutsourceInquiries> {
  List<RentInformation> recordsToBeDisplayed = [];
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
      List<RentInformation> tempRecords = [];
      List<Map<String, dynamic>> tempData = [];

      List<RentInformation> records = await Firestore().getRentRecords();
      for (var item in records) {
        // Check if the renter is associated with the current user's outsource unit
        if (item.carOwner.toLowerCase().contains(FirebaseAuth.instance.currentUser!.uid.toLowerCase())) {
          tempRecords.add(item);
        }
      }

      // Retrieve user data and submitted files for each record
      for (var record in tempRecords) {
        RegisterModel? userInfo = await Firestore().getUserInfo(record.renterUID);
        List<Map<String, dynamic>> userFiles = await Storage().getUserFilesForInquiry(
          FirebaseConstants.rentDocumentsUpload,
          record.renterUID,
        );

        // Add the data to a temporary list
        tempData.add({
          'rentInformation': record,
          'userInfo': userInfo,
          'submittedFiles': userFiles,
        });
      }

      if (!mounted) return;

      // Update the state with the data
      setState(() {
        recordsToBeDisplayed = tempRecords;
        inquiriesWithUserData = tempData;
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
      debugPrint("Error@_retrieveRentRecords: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
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
              // ActionBar
              actionBar(),

              // title and subheader
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(ProjectStrings.outsource_inquiries_header,
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      ProjectStrings.outsource_inquiries_subheader,
                      fontSize: 10),
                ),
              ),

              // main body
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child:  inquiriesWithUserData.isEmpty
                      ? Container(
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
                  )
                      : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: inquiriesWithUserData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final inquiryData = inquiriesWithUserData[index];
                        // Access the data for each inquiry, such as:
                        RentInformation rentInfo = inquiryData['rentInformation'];
                        RegisterModel userInfo = inquiryData['userInfo'];
                        List<Map<String, dynamic>> submittedFiles = inquiryData['submittedFiles'];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Column(
                                children: [
                                  //  header
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(int.parse(
                                                      ProjectColors.mainColorBackground
                                                          .substring(2),
                                                      radix: 16)),
                                                  border: Border.all(
                                                      color: Color(int.parse(ProjectColors
                                                          .lineGray)),
                                                      width: 1)),
                                              child: Center(
                                                  child: CustomComponents.displayText("${index + 1}",
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold))),
                                        ),
                                        const SizedBox(
                                            width:
                                                20.0), // Optional: Add spacing between the Text and the Column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .ri_renter_information_title,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              const SizedBox(height: 2),
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .ri_renter_information_subheader,
                                                color: Color(int.parse(
                                                    ProjectColors.lightGray
                                                        .substring(2),
                                                    radix: 16)),
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
                                        radix: 16)),
                                  ),
                                  // Name
                                  buildInfoRow(ProjectStrings.ri_name_title, ProjectStrings.ri_name, padding: const EdgeInsets.only(right: 15, left: 15, top: 15)),

                                  buildInfoRow(ProjectStrings.ri_name_title, "${userInfo.firstName} ${userInfo.lastName}"),
                                  buildInfoRow(ProjectStrings.ri_email_title, userInfo.email ?? "N/A"),
                                  buildInfoRow(ProjectStrings.ri_phone_number_title, userInfo.number ?? "N/A"),
                                  buildInfoRow("Car Unit:", rentInfo.carName),
                                  buildInfoRow("Role:", userInfo.role ?? "N/A"),
                                  buildInfoRow("Rent Location:", rentInfo.rentLocation),
                                  buildInfoRow("Est. Driving Distance:", rentInfo.estimatedDrivingDistance),
                                  buildInfoRow("Est. Driving Duration:", rentInfo.estimatedDrivingDuration),
                                  buildInfoRow(ProjectStrings.ri_rent_start_date_title, rentInfo.startDateTime),
                                  buildInfoRow(ProjectStrings.ri_rent_end_date_title, rentInfo.endDateTime),
                                  buildInfoRow(ProjectStrings.ri_delivery_mode_title, rentInfo.pickupOrDelivery),
                                  buildInfoRow(ProjectStrings.ri_delivery_location_title, rentInfo.deliveryLocation),
                                  buildInfoRow(ProjectStrings.ri_reserved_title, rentInfo.reservationFee == "0" ? "No" : "Yes"),
                                  buildInfoRow("With Driver:", rentInfo.withDriver.toLowerCase() == "no" ? "No" : "Yes"),
                                  buildInfoRow("Driver Fee:", rentInfo.driverFee),
                                  buildInfoRow("Total Amount:", rentInfo.totalAmount),
                                  buildInfoRow("Status", CustomComponents.capitalizeFirstLetter(rentInfo.rentStatus)),

                                  const SizedBox(height: 30),

                                  //  attached documents
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Expanded(
                                        child: CustomComponents.displayText(
                                            ProjectStrings.ri_attached_document,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    )
                                  ),

                                  ...submittedFiles.map((file) {
                                    return displayDocuments(
                                      file["storageLocation"],
                                      (file["fileSize"] / 1024).toStringAsFixed(2),
                                      DateFormat("MMMM dd, yyyy | hh:mm a").format(file["uploadDate"]).toString(),
                                    );
                                  }),

                                  const SizedBox(height: 30)
                                ],
                              )),
                        );
                      }),
                ),
              ),

              const SizedBox(height: 50)
            ],
          ),
        ),
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
          CustomComponents.menuButtons(context)
        ],
      ),
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
}
