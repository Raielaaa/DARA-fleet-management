import "package:cached_network_image/cached_network_image.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dio/dio.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:open_file/open_file.dart";
import "package:path_provider/path_provider.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/loading.dart";
import "../../../../shared/strings.dart";
import "../inquiries/pdf_viewer.dart";

class ViewMore extends StatefulWidget {
  const ViewMore({super.key});

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  CompleteCarInfo carUnitInfo = PersistentData().selectedCarUnitForManageUnit!;

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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                            "Car Rental Unit Details",
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                            "Comprehensive view of car and owner details",
                            fontSize: 10
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    vehicleInformationPanel(context),
                    const SizedBox(height: 15),
                    carPhotos(context),
                    const SizedBox(height: 15),
                    editDeleteFunction(),
                    const SizedBox(height: 80),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteSelectedCarUnit() async {
    await FirebaseFirestore.instance
        .collection(FirebaseConstants.carInfoCollection)
        .doc(carUnitInfo.carUID)
        .delete();
    await deleteFilesWithPrefix("car_images", carUnitInfo.carUID);
  }

  Future<void> deleteFilesWithPrefix(String storagePath, String prefix) async {
    try {
      // Reference to the storage path
      final Reference storageRef = FirebaseStorage.instance.ref(storagePath);

      // List all items in the storage path
      final ListResult listResult = await storageRef.listAll();

      // Loop through each item and check if the file name starts with the specified prefix
      for (Reference item in listResult.items) {
        String fileName = item.name; // Get file name

        if (fileName.startsWith(prefix)) {
          // Delete the file
          await item.delete();
          debugPrint("Deleted file: $fileName");
        }
      }

      debugPrint("All files with prefix '$prefix' have been deleted.");
    } catch (e) {
      debugPrint("Error deleting files: $e");
    }
  }

  Widget editDeleteFunction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                InfoDialog().showDecoratedTwoOptionsDialog(
                    context: context,
                    content: ProjectStrings.edit_user_info_dialog_content,
                    header: ProjectStrings.edit_user_info_dialog_header,
                    confirmAction: () async {
                      await deleteSelectedCarUnit();
                      Navigator.of(context).pop();
                    }
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Center(
                      child: CustomComponents.displayText(
                        "Delete",
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    )
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed("manage_edit_unit", arguments: carUnitInfo);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16)),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Center(
                      child: CustomComponents.displayText(
                        "Edit",
                        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  Widget carPhotos(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _carInfoRow(),
              Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
              displayPhotoRow(carUnitInfo.mainPicUrl.split("/")[1], "", ""),
              displayPhotoRow(carUnitInfo.pic1Url.split("/")[1], "", ""),
              displayPhotoRow(carUnitInfo.pic2Url.split("/")[1], "", ""),
              displayPhotoRow(carUnitInfo.pic3Url.split("/")[1], "", ""),
              displayPhotoRow(carUnitInfo.pic4Url.split("/")[1], "", ""),
              displayPhotoRow(carUnitInfo.pic5Url.split("/")[1], "", ""),

              const SizedBox(height: 20),
              // _attachedDocumentsSection(),
              //
              // const SizedBox(height: 10),
              // _bottomPanel(context),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayPhotoRow(String? documentName, String fileSize, String fileDateUploaded) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
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
              viewDocument(FirebaseConstants.retrieveImage("car_images/$documentName"));
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

  Widget ownerInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ownerInfoRow(),
              Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
              _infoField("Owner Name", "${PersistentData().selectedUser?.id}"),
              _infoField("Phone Number", "${PersistentData().selectedUser?.firstName} ${PersistentData().selectedUser?.lastName}"),
              _infoField("Email Address", "${PersistentData().selectedUser?.email}"),

              const SizedBox(height: 20),
              // _attachedDocumentsSection(),
              //
              // const SizedBox(height: 10),
              // _bottomPanel(context),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget vehicleInformationPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _vehicleInfoRow(),
              Divider(color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16))),
              _infoField("Name/Model", carUnitInfo.name),
              _infoField("Price", "PHP ${carUnitInfo.price}"),
              _infoField("Color", carUnitInfo.color),
              _infoField("Capacity", "${carUnitInfo.capacity} seats"),
              _infoField("Horsepower", carUnitInfo.horsePower),
              _infoField("Engine", carUnitInfo.engine),
              _infoField("Fuel", carUnitInfo.fuel),
              _infoField("Fuel Variant", carUnitInfo.fuelVariant),
              _infoField("Type", carUnitInfo.carType),
              _infoField("Transmission", carUnitInfo.transmission),
              _infoField("Short Description", carUnitInfo.shortDescription),
              _infoField("Long Description", carUnitInfo.longDescription),
              _infoField("Owner", carUnitInfo.carOwner),
              _infoField("Mileage", carUnitInfo.mileage),
              _infoField("Rent Count", carUnitInfo.rentCount),
              _infoField("Total Earnings", carUnitInfo.totalEarnings),

              const SizedBox(height: 20),
              // _attachedDocumentsSection(),
              //
              // const SizedBox(height: 10),
              // _bottomPanel(context),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vehicleInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
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
                    "Vehicle Information",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    "Overview of vehicle details",
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

  Widget _ownerInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
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
                    "2",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    "Owner Information",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    "Overview of owner details",
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

  Widget _carInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
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
                    "2",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    "Vehicle Photos",
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    "Overview of car photos",
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomComponents.displayText(title,
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))),
          ),
          Expanded(
            child: CustomComponents.displayText(value,
                fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ),
    );
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
            "Manage Units",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}