import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/driver/driver_application.dart";
import "package:file_picker/file_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

import "../../../../model/constants/firebase_constants.dart";
import "../../../../services/firebase/firestore.dart";
import "../../../../services/firebase/storage.dart";
import "../../../shared/colors.dart";
import "../../../shared/components.dart";
import "../../../shared/info_dialog.dart";
import "../../../shared/loading.dart";
import "../../../shared/strings.dart";

class DriverSupportingDocuments extends StatefulWidget {
  const DriverSupportingDocuments({super.key});

  @override
  State<DriverSupportingDocuments> createState() => _DriverSupportingDocumentsState();
}

class _DriverSupportingDocumentsState extends State<DriverSupportingDocuments> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    while (_originalFilePaths.length < 4) {
      _originalFilePaths.add("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: Column(
            children: [
              actionBar(),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      progressIndicator(),
                      const SizedBox(height: 15),
                      employedPanel(),
                      const SizedBox(height: 15),
                      proceedButton(ProjectStrings.outsource_ds_proceed_button),
                      const SizedBox(height: 80)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> removeDuplicatesString(List<String> originalList) {
    return originalList.toSet().toList();
  }

  Future<void> updateDB() async {
    Storage _storage = Storage();

    // Handle deletion of files from the database
    for (var value in removeDuplicatesString(itemsToBeDeletedToDB)) {
      await _storage.deleteFile(value);
    }

    // Handle uploading of new files
    for (var entry in indexStringMap.entries) {
      await _storage.uploadSelectedFileDriver(entry.value, context, "driver_application");
    }
  }


  Widget proceedButton(String buttonText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_originalFilePaths.where((path) => path.isEmpty).length > 2) {
            InfoDialog().show(
                context: context,
                header: "Warning",
                content: "Please ensure that at least three required documents in the employment section are not empty."
            );
          } else {
            // Fill the _outsourceApplicationData with data from _persistentData
            PersistentData _persistentData = PersistentData();

            try {
              DriverApplication _driverApplicationData = DriverApplication(
                  piFirstName: _persistentData.dpiFirstName,
                  piMiddleName: _persistentData.dpiMiddleName,
                  piLastName: _persistentData.dpiLastName,
                  piBirthday: _persistentData.dpiBirthday,
                  piCivilStatus: _persistentData.dpiCivilStatus,
                  piReligion: _persistentData.dpiReligion,
                  piCompleteAddress: _persistentData.dpiCompleteAddress,
                  piMobileNumber: _persistentData.dpiMobileNumber,
                  piEmailAddress: _persistentData.dpiEmailAddress,
                  piFatherName: _persistentData.dpiFatherName,
                  piFatherBirthplace: _persistentData.dpiFatherBirthPlace,
                  piMotherName: _persistentData.dpiMotherName,
                  piMotherBirthplace: _persistentData.dpiMotherBirthplace,
                  piHeight: _persistentData.dpiHeight,
                  piWeight: _persistentData.dpiWeight,
                  ecNameContactPerson: _persistentData.decNameContactPerson,
                  ecRelationship: _persistentData.decRelationshipToApplicant,
                  ecContactNumber: _persistentData.decContactNumber,
                  ecCompleteAddress: _persistentData.decCompleteAddress,
                  epiEducationAttainment: _persistentData.depiEducationalAttainment,
                  epiDriverLicense: _persistentData.depiDriverLicenseNumber,
                  epiSSSNumber: _persistentData.depiSSSNumber,
                  epiTINNumber: _persistentData.depiTINNumber,
                  driverApplicationStatus: "pending",
                  userID: _persistentData.userInfo!.id,
                  userFirstName: _persistentData.userInfo!.firstName,
                  userLastName: _persistentData.userInfo!.lastName,
                  userEmail: _persistentData.userInfo!.email,
                  userDateRegistered: _persistentData.getCurrentFormattedDate(),
                  userType: _persistentData.userType,
                  userNumber: _persistentData.userInfo!.number
              );

              // Add the outsource application info to Firestore
              LoadingDialog().show(context: context, content: "Please wait while we send your application details.");
              await Firestore().addOutsourceApplicationInfo(
                  collectionName: FirebaseConstants.driverApplication,
                  documentName: FirebaseAuth.instance.currentUser?.uid ?? "",
                  data: _driverApplicationData.getModelData()
              );
              await updateDB();
              LoadingDialog().dismiss();
              Navigator.of(context).pushNamed("ap_process_complete");
            } catch(e) {
              LoadingDialog().dismiss();
              InfoDialog().show(context: context, content: "Something went wrong: $e");
            }
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color(int.parse(
              ProjectColors.mainColorHex.substring(2),
              radix: 16,
            )),
          ),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CustomComponents.displayText(
            buttonText,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  List<String> _fileNames = List<String>.filled(4, "No file selected"); // Display file names
  List<String> _fileIcons = List<String>.filled(4, 'lib/assets/pictures/user_info_upload.png');

  String getDocumentTitle(int index) {
    switch (index) {
      case 0:
        return ProjectStrings.driver_sd_photocopy_driver_license;
      case 1:
        return ProjectStrings.driver_sd_original_copy_valid_nbi_police_clearance;
      case 2:
        return ProjectStrings.driver_sd_recent_id_photo_1;
      case 3:
        return ProjectStrings.driver_sd_recent_id_photo_2;
      default:
        return "Unknown Document";
    }
  }

  void inputString(int index, String newString) {
    if (indexStringMap.containsKey(index)) {
      indexStringMap[index] = newString; // Overwrite the string at the index
    } else {
      debugPrint('Index $index is out of range.');
    }
  }

  Future<void> _pickFile(int index, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'doc', 'docx'],
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
                          "1",
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
                          "Personal Documents",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 2),
                        CustomComponents.displayText(
                          "Upload your personal documents below.",
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

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget progressIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: horizontalIcons(),
        ),
      ),
    );
  }

  Widget horizontalIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "lib/assets/pictures/oap_profile_selected.png",
          width: MediaQuery.of(context).size.width / 17,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/dap_emergency_contact_selected.png",
          width: MediaQuery.of(context).size.width / 17,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/dap_book_selected.png",
          width: MediaQuery.of(context).size.width / 15,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_documents_selected.png",
          width: MediaQuery.of(context).size.width / 20,
        ),
        const SizedBox(width: 5),
      ],
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
            ProjectStrings.driver_sd_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
