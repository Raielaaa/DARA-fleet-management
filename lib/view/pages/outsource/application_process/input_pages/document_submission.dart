import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/model/outsource/OutsourceApplication.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/strings.dart";

class DocumentSubmission extends StatefulWidget {
  const DocumentSubmission({super.key});

  @override
  State<DocumentSubmission> createState() => _DocumentSubmissionState();
}

class _DocumentSubmissionState extends State<DocumentSubmission> {
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

  Widget proceedButton(String buttonText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          PersistentData _persistentData = PersistentData();

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
                applicationStatus: _persistentData.applicationStatus
            );

            // Add the outsource application info to Firestore
            LoadingDialog().show(context: context, content: "Please wait while we send your application details.");
            await Firestore().addOutsourceApplicationInfo(
                collectionName: FirebaseConstants.outsourceApplication,
                documentName: FirebaseAuth.instance.currentUser?.uid ?? "",
                data: _outsourceApplicationData.getModelData()
            );
            LoadingDialog().dismiss();
            Navigator.of(context).pushNamed("ap_process_complete");
          } catch(e) {
            LoadingDialog().dismiss();
            InfoDialog().show(context: context, content: "Something went wrong: $e");
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

            //  government valid id 1
            _uploadDocumentsItem(ProjectStrings.user_info_government1),

            //  government valid id 2
            _uploadDocumentsItem(ProjectStrings.user_info_government2),

            //  driver's license
            _uploadDocumentsItem(
                ProjectStrings.outsource_ds_business_business_permit),

            //  proof of billing
            _uploadDocumentsItem(
                ProjectStrings.outsource_ds_proof_of_billing),

            //  ltms portal
            _uploadDocumentsItem(ProjectStrings.outsource_ds_business_bank_statement),

            //  save documents button
            const SizedBox(height: 30),
          ],
        ),
      ),
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

            //  government valid id 1
            _uploadDocumentsItem(ProjectStrings.user_info_government1),

            //  government valid id 2
            _uploadDocumentsItem(ProjectStrings.user_info_government2),

            //  driver's license
            _uploadDocumentsItem(
                ProjectStrings.outsource_ds_certificate_of_employment),

            //  proof of billing
            _uploadDocumentsItem(
                ProjectStrings.outsource_ds_proof_of_billing),

            //  ltms portal
            _uploadDocumentsItem(ProjectStrings.outsource_ds_payslip),

            //  save documents button
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _uploadDocumentsItem(String documentName) {
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, top: 10, right: 30, bottom: 10),
                  child: Image.asset(
                    "lib/assets/pictures/user_info_upload.png",
                    height: 60,
                  ),
                ),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomComponents.displayText(
                          ProjectStrings.user_info_upload_file,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                      CustomComponents.displayText(documentName,
                          color: Color(int.parse(
                            ProjectColors.lightGray.substring(2),
                            radix: 16,
                          )),
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                      const SizedBox(height: 5),
                      TextButton(
                        onPressed: () {},
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
              ])),
        ));
  }

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
}
