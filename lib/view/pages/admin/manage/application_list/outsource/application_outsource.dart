import "package:dara_app/view/shared/info_dialog.dart";
import "package:flutter/material.dart";

import "../../../../../shared/colors.dart";
import "../../../../../shared/components.dart";
import "../../../../../shared/strings.dart";

class ApplicationOutsource extends StatefulWidget {
  const ApplicationOutsource({super.key});

  @override
  State<ApplicationOutsource> createState() => _ApplicationOutsourceState();
}

class _ApplicationOutsourceState extends State<ApplicationOutsource> {
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

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // title and sub-header
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.application_list_driver_outsource_detailed_info_header,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.application_list_driver_outsource_detailed_info_subheader,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    // body
                    const SizedBox(height: 20),
                    _applicantInfoContainer(context),
                    const SizedBox(height: 20),
                    _approveDeclineButton(),
                    const SizedBox(height: 75),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _approveDeclineButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //  decline
        GestureDetector(
          onTap: () {
            InfoDialog().showDecoratedTwoOptionsDialog(
                context: context,
                content: ProjectStrings.application_list_dialog_subheader,
                header: ProjectStrings.application_list_dialog_header
            );
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(5),
                color: Color(int.parse(
                    ProjectColors
                        .redButtonBackground
                        .substring(2),
                    radix: 16)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40),
                    child: Image.asset(
                      "lib/assets/pictures/rentals_denied.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                          top: 15,
                          bottom: 15,
                          right: 45,
                          left: 10),
                      child: CustomComponents
                          .displayText(
                        ProjectStrings.application_list_driver_outsource_detailed_info_decline,
                        color: Color(int.parse(
                            ProjectColors
                                .redButtonMain
                                .substring(2),
                            radix: 16)),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),

        //  approve
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            InfoDialog().showDecoratedTwoOptionsDialog(
                context: context,
                content: ProjectStrings.application_list_dialog_subheader,
                header: ProjectStrings.application_list_dialog_header
            );
          },
          child: Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(10),
                color: Color(int.parse(
                    ProjectColors.lightGreen
                        .substring(2),
                    radix: 16)),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 40),
                    child: Image.asset(
                      "lib/assets/pictures/rentals_verified.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        right: 45,
                        left: 10),
                    child: CustomComponents
                        .displayText(
                      ProjectStrings.application_list_driver_outsource_detailed_info_approve,
                      color: Color(int.parse(
                          ProjectColors
                              .greenButtonMain
                              .substring(2),
                          radix: 16)),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }

  Widget _applicantInfoContainer(BuildContext context) {
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
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: CustomComponents.displayText(
                      ProjectStrings.application_list_driver_personal_information_title,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 5),
              _infoField(ProjectStrings.application_list_driver_name_title, ProjectStrings.application_list_driver_name),
              _infoField(ProjectStrings.application_list_driver_address_title, ProjectStrings.application_list_driver_address),
              _infoField(ProjectStrings.application_list_driver_birthday_title, ProjectStrings.application_list_driver),
              _infoField(ProjectStrings.application_list_driver_civil_status_title, ProjectStrings.application_list_driver_civil_status),
              _infoField(ProjectStrings.application_list_driver_contact_number_title, ProjectStrings.application_list_driver_contact_number),
              _infoField(ProjectStrings.application_list_driver_educ_attainment_title, ProjectStrings.application_list_driver_educ_attainment),
              _infoField(ProjectStrings.application_list_driver_email_add_title, ProjectStrings.application_list_driver_email_add),
              _infoField(ProjectStrings.application_list_driver_tin_number_title, ProjectStrings.application_list_driver_tin_number),
              _infoField(ProjectStrings.application_list_outsource_age_title, ProjectStrings.application_list_outsource_age),
              _infoField(ProjectStrings.application_list_outsource_place_of_birth_title, ProjectStrings.application_list_outsource_place_of_birth),
              _infoField(ProjectStrings.application_list_outsource_citizenship_title, ProjectStrings.application_list_outsource_citizenship),
              _infoField(ProjectStrings.application_list_outsource_civil_status_title, ProjectStrings.application_list_outsource_civil_status),
              _infoField(ProjectStrings.application_list_outsource_years_in_residence_title, ProjectStrings.application_list_outsource_years_in_residence),
              _infoField(ProjectStrings.application_list_outsource_house_status_title, ProjectStrings.application_list_outsource_house_status),

              //  vehicle information
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: CustomComponents.displayText(
                      ProjectStrings.application_list_outsource_vi_title,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              _infoField(ProjectStrings.application_list_outsource_vi_model_title, ProjectStrings.application_list_outsource_vi_model),
              _infoField(ProjectStrings.application_list_outsource_vi_brand_title, ProjectStrings.application_list_outsource_vi_brand),
              _infoField(ProjectStrings.application_list_outsource_vi_year_title, ProjectStrings.application_list_outsource_vi_year),
              _infoField(ProjectStrings.application_list_outsource_vi_plate_number_title, ProjectStrings.application_list_outsource_vi_plate_number),

              //  employment information
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: CustomComponents.displayText(
                      ProjectStrings.application_list_outsource_ei_title,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              _infoField(ProjectStrings.application_list_outsource_ei_company_name_title, ProjectStrings.application_list_outsource_ei_company_name),
              _infoField(ProjectStrings.application_list_outsource_ei_address_title, ProjectStrings.application_list_outsource_ei_address),
              _infoField(ProjectStrings.application_list_outsource_ei_telephone_number_title, ProjectStrings.application_list_outsource_ei_telephone_number),
              _infoField(ProjectStrings.application_list_outsource_ei_position_title, ProjectStrings.application_list_outsource_ei_position),
              _infoField(ProjectStrings.application_list_outsource_ei_length_of_stay_title, ProjectStrings.application_list_outsource_ei_length_of_stay),
              _infoField(ProjectStrings.application_list_outsource_ei_monthly_salary_title, ProjectStrings.application_list_outsource_ei_monthly_salary),

              //  business information
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: CustomComponents.displayText(
                      ProjectStrings.application_list_outsource_bi_title,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              _infoField(ProjectStrings.application_list_outsource_bi_business_name_title, ProjectStrings.application_list_outsource_bi_business_name),
              _infoField(ProjectStrings.application_list_outsource_bi_address_title, ProjectStrings.application_list_outsource_bi_address),
              _infoField(ProjectStrings.application_list_outsource_bi_position_title, ProjectStrings.application_list_outsource_bi_position),
              _infoField(ProjectStrings.application_list_outsource_bi_years_of_operation_title, ProjectStrings.application_list_outsource_bi_years_of_operation),
              _infoField(ProjectStrings.application_list_outsource_bi_contact_number_title, ProjectStrings.application_list_outsource_bi_contact_number),
              _infoField(ProjectStrings.application_list_outsource_bi_email_address_title, ProjectStrings.application_list_outsource_bi_email_address),
              _infoField(ProjectStrings.application_list_outsource_bi_monthly_income_title, ProjectStrings.application_list_outsource_bi_monthly_income),

              const SizedBox(height: 20),
              _attachedDocumentsSection(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renterInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100)
            ),
            width: 40,
            height: 40,
            child: Image.asset(
              "lib/assets/pictures/user_info_user.png",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    ProjectStrings.admin_user_info_name,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 2),
                CustomComponents.displayText(
                    ProjectStrings.application_list_name_outsource,
                    color: Color(int.parse(ProjectColors.userListOutsourceHex.substring(2), radix: 16)),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(title,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))),
          CustomComponents.displayText(value,
              fontWeight: FontWeight.bold, fontSize: 10),
        ],
      ),
    );
  }

  Widget _attachedDocumentsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomComponents.displayText(ProjectStrings.ri_attached_document,
              fontWeight: FontWeight.bold, fontSize: 12),
          _documentRow(ProjectStrings.ri_government_id_1),
          _documentRow(ProjectStrings.ri_government_id_2),
          _documentRow(ProjectStrings.ri_driver_license),
          _documentRow(ProjectStrings.ri_proof_of_billing),
          _documentRow(ProjectStrings.ri_ltms_portal),
        ],
      ),
    );
  }

  Widget _documentRow(String document) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
                    child: CustomComponents.displayText(ProjectStrings.ri_jpg,
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
                    CustomComponents.displayText(document,
                        fontSize: 10, fontWeight: FontWeight.w500),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        CustomComponents.displayText(ProjectStrings.ri_size,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16))),
                        const SizedBox(width: 20),
                        CustomComponents.displayText(
                            ProjectStrings.ri_document_date,
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
          CustomComponents.displayText(ProjectStrings.ri_view,
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2),
                  radix: 16)),
              fontSize: 10,
              fontWeight: FontWeight.bold)
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          CustomComponents.displayText(
            ProjectStrings.application_list_driver_outsource_detailed_info_applicant_info,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
                "lib/assets/pictures/three_vertical_dots.png"),
          ),
        ],
      ),
    );
  }
}
