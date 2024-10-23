import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/model/outsource/OutsourceApplication.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:file_picker/file_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

import "../../../../../services/firebase/storage.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/strings.dart";

class DocumentSubmission extends StatefulWidget {
  const DocumentSubmission({super.key});

  @override
  State<DocumentSubmission> createState() => _DocumentSubmissionState();
}

class _DocumentSubmissionState extends State<DocumentSubmission> {

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
          "lib/assets/pictures/oap_vehicle_selected.png",
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
          "lib/assets/pictures/oap_employment_selected.png",
          width: MediaQuery.of(context).size.width / 20,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_business_selected.png",
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          CustomComponents.displayText(
            ProjectStrings.outsource_ds_appbar_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Ensure _originalFilePaths has exactly 5 items by filling with empty strings if necessary
    while (_originalFilePaths.length < 5) {
      _originalFilePaths.add("");
    }
    while (_originalFilePaths_business.length < 5) {
      _originalFilePaths_business.add("");
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
                      businessPanel(),
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







  //////////////////////////////////////////////////////    employed panel    //////////////////////////////////////
  List<int> selectedIndex = [];
  Map<int, String> indexStringMap = {
    0: '',
    1: '',
    2: '',
    3: '',
    4: '',
  };
  List<String> itemsToBeDeletedToDB = [];
  List<String> _originalFilePaths = [];
  List<String> _newListTobeAddedToDB = [];
  List<String> _fileNames = List<String>.filled(5, "No file selected"); // Display file names
  List<String> _fileIcons = List<String>.filled(5, 'lib/assets/pictures/user_info_upload.png');

  List<int> removeDuplicates(List<int> originalList) {
    return originalList.toSet().toList();
  }

  List<String> removeDuplicatesString(List<String> originalList) {
    return originalList.toSet().toList();
  }

  String getDocumentTitle(int index) {
    switch (index) {
      case 0:
        return ProjectStrings.user_info_government1;
      case 1:
        return ProjectStrings.user_info_government2;
      case 2:
        return ProjectStrings.user_info_driver_license;
      case 3:
        return ProjectStrings.user_info_proof_of_billing;
      case 4:
        return ProjectStrings.user_info_ltms_portal;
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
                          ProjectStrings.outsource_ds_employed,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 2),
                        CustomComponents.displayText(
                          ProjectStrings.outsource_ds_employed_subheader,
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
              height: 485, // Adjust height as needed
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
////////////////////      employed panel            ////////////////////////////////////////////////////////////////















/////////////////////////////////////////       business panel        /////////////////////////////////////////////////
  List<int> selectedIndex_business = [];
  Map<int, String> indexStringMap_business = {
    0: '',
    1: '',
    2: '',
    3: '',
    4: '',
  };
  List<String> itemsToBeDeletedToDB_business = [];
  List<String> _originalFilePaths_business = [];
  List<String> _newListTobeAddedToDB_business = [];
  List<String> _fileNames_business = List<String>.filled(5, "No file selected"); // Display file names
  List<String> _fileIcons_business = List<String>.filled(5, 'lib/assets/pictures/user_info_upload.png');

  List<int> removeDuplicates_business(List<int> originalList) {
    return originalList.toSet().toList();
  }

  List<String> removeDuplicatesString_business(List<String> originalList) {
    return originalList.toSet().toList();
  }

  String getDocumentTitle_business(int index) {
    switch (index) {
      case 0:
        return ProjectStrings.user_info_government1;
      case 1:
        return ProjectStrings.user_info_government2;
      case 2:
        return ProjectStrings.user_info_driver_license;
      case 3:
        return ProjectStrings.user_info_proof_of_billing;
      case 4:
        return ProjectStrings.user_info_ltms_portal;
      default:
        return "Unknown Document";
    }
  }

  void inputString_business(int index, String newString) {
    if (indexStringMap_business.containsKey(index)) {
      indexStringMap_business[index] = newString; // Overwrite the string at the index
    } else {
      debugPrint('Index $index is out of range.');
    }
  }

  String _getFileIcon_business(String extension) {
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

  Future<void> _pickFile_business(int index, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedIndex_business.add(index);
        itemsToBeDeletedToDB_business.add(_originalFilePaths_business[index]);
        _newListTobeAddedToDB_business.add(result.files.first.path!);
        inputString_business(index, result.files.first.path!);

        // Replace the file at the current index with the newly selected file
        _originalFilePaths_business[index] = result.files.first.path!;
        String fileName = result.files.first.name; // Extract file name
        String fileExtension = fileName.split('.').last; // Extract file extension

        // Update the display based on file type
        _fileIcons_business[index] = fileExtension; // Update image icon
        _fileNames_business[index] = fileName; // Update the file name display
      });
    }
  }

  Widget _uploadDocumentsItem_business(String documentName, String headerName, int index) {
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
                      _getFileIcon_business(_fileIcons_business[index]),
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
                            _fileNames_business[index],
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
                              _pickFile_business(index, context);
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
  Widget businessPanel() {
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
                    // Use Expanded only if the parent widget has constraints
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomComponents.displayText(
                          ProjectStrings.outsource_ds_business,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 2),
                        CustomComponents.displayText(
                          ProjectStrings.outsource_ds_business_subheader,
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

            SizedBox(
              height: 485, // Adjust height as needed
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _originalFilePaths_business.length,
                itemBuilder: (context, index) {
                  return _uploadDocumentsItem_business(
                    _originalFilePaths_business[index],
                    getDocumentTitle_business(index),
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


  ///////////////////////////////////////////   business panel        //////////////////////



  Widget proceedButton(String buttonText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          PersistentData _persistentData = PersistentData();

          _originalFilePaths.forEach((value) {
            debugPrint("Employed paths: $value");
          });
          _originalFilePaths_business.forEach((value) {
            debugPrint("Business paths: $value");
          });
          if (_originalFilePaths.where((path) => path.isEmpty).length > 2) {
            InfoDialog().show(
                context: context,
                header: "Warning",
                content: "Please ensure that at least three required documents in the employment section are not empty."
            );
          } else {
            // Fill the _outsourceApplicationData with data from _persistentData
            try {
              OutsourceApplication _outsourceApplicationData = OutsourceApplication(
                  viCarModel: _persistentData.viCarModel,
                  viCarBrand: _persistentData.viCarBrand,
                  viManufacturingYear: _persistentData.viManufacturingYear,
                  viNumber: _persistentData.viNumber,
                  ppFirstName: _persistentData.ppFirstName,
                  ppMiddleName: _persistentData.ppMiddleName,
                  ppLastName: _persistentData.ppLastName,
                  ppBirthday: _persistentData.ppBirthday,
                  ppAge: _persistentData.ppAge,
                  ppBirthPlace: _persistentData.ppBirthPlace,
                  ppCitizenship: _persistentData.ppCitizenship,
                  ppCivilStatus: _persistentData.ppCivilStatus,
                  ppMotherName: _persistentData.ppMotherName,
                  ppContactNumber: _persistentData.ppContactNumber,
                  ppEmailAddress: _persistentData.ppEmailAddress,
                  ppAddress: _persistentData.ppAddress,
                  ppYearsStayed: _persistentData.ppYearsStayed,
                  ppHouseStatus: _persistentData.ppHouseStatus,
                  ppTinNumber: _persistentData.ppTinNumber,
                  eiCompanyName: _persistentData.eiCompanyName,
                  eiAddress: _persistentData.eiAddress,
                  eiTelephoneNumber: _persistentData.eiTelephoneNumber,
                  eiPosition: _persistentData.eiPosition,
                  eiLengthOfStay: _persistentData.eiLengthOfStay,
                  eiMonthlySalary: _persistentData.eiMonthlySalary,
                  biBusinessName: _persistentData.biBusinessName,
                  biCompleteAddress: _persistentData.biCompleteAddress,
                  biYearsOfOperation: _persistentData.biYearsOfOperation,
                  biBusinessContactNumber: _persistentData.biBusinessContactNumber,
                  biBusinessEmailAddress: _persistentData.biBusinessEmailAddress,
                  biPosition: _persistentData.biPosition,
                  biMonthlyIncomeGross: _persistentData.biMonthlyIncomeGross,
                  rentalAgreementOptions: _persistentData.rentalAgreementOptions,
                  applicationStatus: _persistentData.applicationStatus,
                  userID: _persistentData.userInfo!.id,
                  userFirstName: _persistentData.userInfo!.firstName,
                  userLastName: _persistentData.userInfo!.lastName,
                  userEmail: _persistentData.userInfo!.email,
                  userDateRegistered: _persistentData.getCurrentFormattedDate(),
                  userType: _persistentData.userType,
                  userNumber: _persistentData.userInfo!.number,
                  ppEducationalAttainment: _persistentData.ppEducationalAttainment
              );

              // Add the outsource application info to Firestore
              LoadingDialog().show(context: context, content: "Please wait while we send your application details.");
              await Firestore().addOutsourceApplicationInfo(
                  collectionName: FirebaseConstants.outsourceApplication,
                  documentName: FirebaseAuth.instance.currentUser?.uid ?? "",
                  data: _outsourceApplicationData.getModelData()
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

  Future<void> updateDB() async {
    Storage _storage = Storage();

    //  employed documents
    // Handling deletion
    for (var value in removeDuplicatesString(itemsToBeDeletedToDB)) {
      await _storage.deleteFile(value);
    }

    // Handling upload
    for (var entry in indexStringMap.entries) {
      await _storage.uploadSelectedFile(entry.value, context, "employed", "outsource_application");
    }


    //  business documents
    // Handling deletion
    for (var value in removeDuplicatesString(itemsToBeDeletedToDB)) {
      await _storage.deleteFile(value);
    }

    // Handling upload
    for (var entry in indexStringMap.entries) {
      await _storage.uploadSelectedFile(entry.value, context, "business", "outsource_application");
    }
  }
}
