import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

import "../../../shared/colors.dart";
import "../../../shared/components.dart";
import "../../../shared/strings.dart";

class DriverSupportingDocuments extends StatefulWidget {
  const DriverSupportingDocuments({super.key});

  @override
  State<DriverSupportingDocuments> createState() => _DriverSupportingDocumentsState();
}

class _DriverSupportingDocumentsState extends State<DriverSupportingDocuments> {
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

  Widget proceedButton(String buttonText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed("ap_process_complete");
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomComponents.displayText(
                          ProjectStrings.driver_sd_panel_header,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 2),
                        CustomComponents.displayText(
                          ProjectStrings.driver_sd_panel_subheader,
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

            //  photocopy of driver's license
            _uploadDocumentsItem(ProjectStrings.driver_sd_photocopy_driver_license),

            //  original copy of valid NBI and/or police clearance
            _uploadDocumentsItem(ProjectStrings.driver_sd_original_copy_valid_nbi_police_clearance),

            //  2x2 recent ID photo 1
            _uploadDocumentsItem(
                ProjectStrings.driver_sd_recent_id_photo_1),

            //  2x2 recent ID photo 2
            _uploadDocumentsItem(ProjectStrings.driver_sd_recent_id_photo_2),

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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
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
