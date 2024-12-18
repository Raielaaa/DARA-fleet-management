import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../../controller/singleton/persistent_data.dart';
import '../../../../../model/car_list/complete_car_list.dart';
import '../../../../../model/constants/firebase_constants.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/components.dart';
import '../../../../shared/info_dialog.dart';
import '../../../../shared/loading.dart';
import '../../../../shared/strings.dart';

class EditUnit extends StatefulWidget {
  const EditUnit({super.key});

  @override
  State<EditUnit> createState() => _EditUnitState();
}

class _EditUnitState extends State<EditUnit> {
  Map<String, String> userInfo = {};
  Map<String, TextEditingController> controllers = {};
  CompleteCarInfo carUnitInfo = PersistentData().selectedCarUnitForManageUnit!;
  Map<String, XFile> _newImages = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      setState(() {
        userInfo = {
          "name": carUnitInfo.name,
          "price": carUnitInfo.price,
          "color": carUnitInfo.color,
          "capacity": carUnitInfo.capacity,
          "horsepower": carUnitInfo.horsePower.split(" ")[0],
          "engine": carUnitInfo.engine,
          "fuel": carUnitInfo.fuel.split(" ")[0],
          "fuel_variant": carUnitInfo.fuelVariant,
          "type": carUnitInfo.carType,
          "transmission": carUnitInfo.transmission,
          "short_description": carUnitInfo.shortDescription,
          "long_description": carUnitInfo.longDescription,
          "mileage": carUnitInfo.mileage.split(" ")[0],
          "rent_count": carUnitInfo.rentCount,
          "earnings": carUnitInfo.totalEarnings,
          // "owner": carUnitInfo.carOwner,
        };

        userInfo.forEach((key, value) {
          controllers[key] = TextEditingController(text: value);
        });
      });
    });
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _headerSection(),
                    const SizedBox(height: 20),
                    _renterInfoContainer(context),
                    // _bottomSection(),
                    const SizedBox(height: 15),
                    carPhotos(context),
                    const SizedBox(height: 15),
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

  Future<void> updateDB() async {
    await saveReplacements();
    await updatedRecords();
  }

  Future<void> updatedRecords() async {
    final updateData = {
      "car_name": userInfo["name"],
      "car_price": userInfo["price"],
      "car_color": userInfo["color"],
      "car_capacity": userInfo["capacity"],
      "car_horse_power": "${userInfo["horsepower"]} hp",
      "car_engine": userInfo["engine"],
      "car_fuel": userInfo["fuel"],
      "car_fuel_variant": userInfo["fuel_variant"],
      "car_type": userInfo["type"],
      "car_transmission": userInfo["transmission"],
      "car_short_description": userInfo["short_description"],
      "car_long_description": userInfo["long_description"],
      "car_mileage": "${userInfo["mileage"]} km/L",
      "car_rent_count": userInfo["rent_count"],
      "car_total_earnings": userInfo["earnings"]
    };

    // Update Firestore records
    await updateMultipleFields(
      collectionPath: FirebaseConstants.carInfoCollection,
      documentID: carUnitInfo.mainPicUrl.split("/")[1].split("_")[0],
      updateData: updateData,
    );
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
                  ],
                )
              ],
            ),
          ),
          //delete image
          Row(
            children: [
              GestureDetector(
                onTap: () => onReplace(documentName),
                child: CustomComponents.displayText(
                    "replace",
                    color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(width: 30),
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
          )
        ],
      ),
    );
  }

  Future<void> onReplace(String oldImageName) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      setState(() {
        _newImages[oldImageName] = pickedFile;  // Add the new image to the map
      });
    }
  }

  Future<void> saveReplacements() async {
    for (var entry in _newImages.entries) {
      String oldImageName = entry.key;
      XFile newImage = entry.value;

      debugPrint("oldImageName: $oldImageName");
      debugPrint("newImage-name: ${newImage.name}");
      debugPrint("newImage-path: ${newImage.path}");
      try {
        // Delete the old image from Firebase Storage
        final oldImageUrl = FirebaseConstants.retrieveImage("car_images/$oldImageName");
        final oldRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
        await oldRef.delete();

        // Upload the new image
        final newImageRef = FirebaseStorage.instance.ref('car_images/$oldImageName');
        await newImageRef.putFile(File(newImage.path));
        final newDownloadUrl = await newImageRef.getDownloadURL();

        // // Update Firestore with the new image URL
        // await FirebaseFirestore.instance
        //     .collection(FirebaseConstants.carInfoCollection)
        //     .doc(oldImageName.toString().split("_")[0])
        //     .update({'car_images/$oldImageName': newDownloadUrl});

      } catch (e) {
        debugPrint("Error replacing image: $e");
      }
    }

    setState(() {
      _newImages.clear();  // Clear the map after saving all replacements
    });
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
              _infoField("Name/Model", "name"),
              _infoField("Price", "price"),
              _infoField("Color", "color"),
              _infoField("Capacity", "capacity"),
              _infoField("Horsepower", "horsepower"),
              _infoField("Engine", "engine"),
              _infoField("Fuel", "fuel"),
              _infoField("Fuel Variant", "fuel_variant"),
              _infoField("Type", "type"),
              _infoField("Transmission", "transmission"),
              _infoField("Short Description", "short_description"),
              _infoField("Long Description", "long_description"),
              _infoField("Mileage", "mileage"),
              _infoField("Rent Count", "rent_count"),
              _infoField("Earnings", "earnings"),
              // _infoField("Owner", "owner"),

              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoField(String title, String key) {
    // Retrieve the corresponding TextEditingController
    final controller = controllers[key] ?? TextEditingController();

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
          key == "type" ? DropdownButtonFormField<String>(
            value: userInfo[key]?.toLowerCase() == "sedan" ? "sedan" : "suv",
            items: const [
              DropdownMenuItem(
                value: "sedan",
                child: Text(
                  "Sedan",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D1D1D),
                      fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "suv",
                child: Text(
                  "SUV",
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
          ) : key == "fuel_variant" ? DropdownButtonFormField<String>(
            value: userInfo[key]?.toLowerCase() == "gasoline" ? "gasoline" : "diesel",
            items: const [
              DropdownMenuItem(
                value: "gasoline",
                child: Text(
                  "Gasoline",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D1D1D),
                      fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "diesel",
                child: Text(
                  "Diesel",
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
          ) : key == "transmission" ? DropdownButtonFormField<String>(
            value: userInfo[key]?.toLowerCase() == "automatic" ? "automatic" : "manual",
            items: const [
              DropdownMenuItem(
                value: "automatic",
                child: Text(
                  "Automatic",
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1D1D1D),
                      fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
              DropdownMenuItem(
                value: "manual",
                child: Text(
                  "Manual",
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
          ) : key == "price" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) : key == "capacity" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) : key == "fuel" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) : key == "horsepower" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) : key == "mileage" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) : key == "rent_count" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) : key == "earnings" ? TextFormField(
            keyboardType: TextInputType.number,
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
          ) :
          TextFormField(
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

  Widget _renterInfoRow() {
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
          const SizedBox(width: 20),
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
                    "Edit vehicle specification",
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

  Widget _headerSection() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomComponents.displayText("Car Unit Overview",
                fontWeight: FontWeight.bold, fontSize: 12),
            const SizedBox(height: 3),
            CustomComponents.displayText(ProjectStrings.edit_user_info_subheader,
                fontSize: 10),
          ],
        ),
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
            "Edit Unit",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
