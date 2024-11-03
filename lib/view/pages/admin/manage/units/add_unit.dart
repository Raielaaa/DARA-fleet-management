import "package:cloud_firestore/cloud_firestore.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/car_list/complete_car_list.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/strings.dart";

class AddUnit extends StatefulWidget {
  const AddUnit({super.key});

  @override
  State<AddUnit> createState() => _AddUnitState();
}

class _AddUnitState extends State<AddUnit> {
  Map<String, String> carInfo = {};
  Map<String, TextEditingController> controllers = {};
  List<int> selectedIndex = [];
  Map<int, String> indexStringMap = {
    0: '',
    1: '',
    2: '',
    3: ''
  };
  List<String> itemsToBeDeletedToDB = [];
  List<String> _originalFilePaths = [];
  List<String> _newListTobeAddedToDB = [];
  List<String> _fileNames = List<String>.filled(6, "No picture selected"); // Display file names
  List<String> _fileIcons = List<String>.filled(6, 'lib/assets/pictures/user_info_upload.png');

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

  String getDocumentTitle(int index) {
    switch (index) {
      case 0:
        return "Transparent BG Picture";
      case 1:
        return "Picture 1";
      case 2:
        return "Picture 2";
      case 3:
        return "Picture 3";
      case 4:
        return "Picture 4";
      case 5:
        return "Picture 5";
      default:
        return "Unknown Document";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    while (_originalFilePaths.length < 6) {
      _originalFilePaths.add("");
    }

    Future.microtask(() {
      setState(() {
        carInfo = {
          "name": "",
          "price": "",
          "color": "",
          "capacity": "",
          "horsepower": "",
          "engine": "",
          "fuel": "",
          "fuel_variant": "",
          "type": "",
          "transmission": "",
          "short_description": "",
          "long_description": "",
          "mileage": "",
          "rent_count": "",
          "earnings": "",
          "owner": ""
        };

        carInfo.forEach((key, value) {
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
                    const SizedBox(height: 15),
                    employedPanel(),
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

  Future<String> getNextDocumentName() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Replace 'your_collection' with the actual collection name where documents are stored
    QuerySnapshot querySnapshot = await firestore.collection(FirebaseConstants.carInfoCollection).get();

    List<String> documentNames = [];

    // Extract document names
    for (var doc in querySnapshot.docs) {
      String docName = doc.id; // Assuming document ID is the name you want
      if (docName.startsWith('C')) {
        documentNames.add(docName);
      }
    }

    // Find the maximum number
    int maxNumber = 0;

    for (String name in documentNames) {
      int number = int.parse(name.substring(1));
      if (number > maxNumber) {
        maxNumber = number;
      }
    }

    // Increment and format the new name
    maxNumber++;
    return 'C${maxNumber.toString().padLeft(3, '0')}'; // Returns C011, C012, etc.
  }

  Future<void> updateDB() async {
    // await saveReplacements();
    await updatedRecords();
  }

  Future<void> updatedRecords() async {
    final updateData = {
      "car_name": carInfo["name"],
      "car_price": carInfo["price"],
      "car_color": carInfo["color"],
      "car_capacity": carInfo["capacity"],
      "car_horse_power": "${carInfo["horsepower"]} hp",
      "car_engine": carInfo["engine"],
      "car_fuel": carInfo["fuel"],
      "car_fuel_variant": carInfo["fuel_variant"],
      "car_type": carInfo["type"],
      "car_transmission": carInfo["transmission"],
      "car_short_description": carInfo["short_description"],
      "car_long_description": carInfo["long_description"],
      "car_mileage": "${carInfo["mileage"]} km/L",
      "car_rent_count": carInfo["rent_count"],
      "car_total_earnings": carInfo["earnings"]
    };

    String documentID = await getNextDocumentName();

    // Update Firestore records
    await updateMultipleFields(
      collectionPath: FirebaseConstants.carInfoCollection,
      documentID: documentID,
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
          .set(updateData);
    } catch(e) {
      debugPrint("An error occurred: $e");
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

  Widget employedPanel() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
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
                          ProjectColors.mainColorBackground
                              .substring(2),
                          radix: 16,
                        )),
                        border: Border.all(
                          color:
                          Color(int.parse(ProjectColors.lineGray)),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: CustomComponents.displayText(
                          "2",
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
                          "Vehicle Photos",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 2),
                        CustomComponents.displayText(
                          "Upload your vehicle photos below.",
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
            SizedBox(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _originalFilePaths.length,
                itemBuilder: (context, index) {
                  return _uploadDocumentsItem(
                    _originalFilePaths[index],
                    getDocumentTitle(index),
                    index,
                  );
                },
              ),
            ),

            //  save documents button
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10, right: 0, bottom: 10),
                    child: Image.asset(
                      _getFileIcon(_fileIcons[index]),
                      height: 60,
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
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
                )
              ])),
        ));
  }

  Future<void> _pickFile(int index, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'], // Only allow image extensions
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedIndex.add(index);
        itemsToBeDeletedToDB.add(_originalFilePaths[index]);
        _newListTobeAddedToDB.add(result.files.first.path!);
        inputString(index, result.files.first.path!);

        // Replace the file at the current index with the newly selected file
        _originalFilePaths[index] = result.files.first.path!;
        String fileName = result.files.first.name; // Extract file name
        String fileExtension = fileName.split('.').last; // Extract file extension

        // Update the display based on file type
        _fileIcons[index] = fileExtension; // Update image icon
        _fileNames[index] = fileName; // Update the file name display
      });
    }
  }

  void inputString(int index, String newString) {
    if (indexStringMap.containsKey(index)) {
      indexStringMap[index] = newString; // Overwrite the string at the index
    } else {
      debugPrint('Index $index is out of range.');
    }
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
            value: carInfo[key]?.toLowerCase() == "sedan" ? "sedan" : "suv",
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
                  carInfo[key] = newValue;
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
            value: carInfo[key]?.toLowerCase() == "gasoline" ? "gasoline" : "diesel",
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
                  carInfo[key] = newValue;
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
            value: carInfo[key]?.toLowerCase() == "automatic" ? "automatic" : "manual",
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
                  carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
              carInfo[key] = newValue;
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
                    "Add vehicle specification",
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
            CustomComponents.displayText("Vehicle Information", fontWeight: FontWeight.bold, fontSize: 12),
            const SizedBox(height: 3),
            CustomComponents.displayText("Enter details for the new car unit", fontSize: 10),
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
            "Add Unit",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
