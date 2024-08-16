import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class Inquiries extends StatefulWidget {
  const Inquiries({super.key});

  @override
  State<Inquiries> createState() => _InquiriesState();
}

class _InquiriesState extends State<Inquiries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              // ActionBar
              Container(
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
                      ProjectStrings.ri_appbar,
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                          "lib/assets/pictures/three_vertical_dots.png"),
                    ),
                  ],
                ),
              ),

              // title and subheader
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(ProjectStrings.ri_title,
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      ProjectStrings.ri_subheader,
                      fontSize: 10),
                ),
              ),

              // main body
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Column(
                                children: [
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
                                                  child: CustomComponents.displayText("1",
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
                                  //  name
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings.ri_name_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_name,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  email
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings.ri_email_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_email,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  phone number
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings
                                                .ri_phone_number_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_phone_number,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  rent start date
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings
                                                .ri_rent_start_date_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_rent_start_date,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  rent end date
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings
                                                .ri_rent_end_date_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_rent_end_date,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  delivery mode
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings
                                                .ri_delivery_mode_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_delivery_mode,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  delivery location
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings
                                                .ri_delivery_location_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_delivery_location,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

                                  //  reserved
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomComponents.displayText(
                                            ProjectStrings.ri_reserved_title,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.lightGray
                                                    .substring(2),
                                                radix: 16))),
                                        CustomComponents.displayText(
                                          ProjectStrings.ri_reserved,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        )
                                      ],
                                    ),
                                  ),

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
                                    ),
                                  ),

                                  displayDocuments(
                                      ProjectStrings.ri_government_id_1),
                                  displayDocuments(
                                      ProjectStrings.ri_government_id_2),
                                  displayDocuments(
                                      ProjectStrings.ri_driver_license),
                                  displayDocuments(
                                      ProjectStrings.ri_proof_of_billing),
                                  displayDocuments(
                                      ProjectStrings.ri_ltms_portal),

                                  const SizedBox(height: 30),

                                  //  add note/approve button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //  report
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                    left: 20),
                                                child: Image.asset(
                                                  "lib/assets/pictures/rentals_denied.png",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      "rentals_report");
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          right: 25,
                                                          left: 5),
                                                  child: CustomComponents
                                                      .displayText(
                                                    ProjectStrings.ri_add_note,
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
                                          )),

                                      //  approved
                                      const SizedBox(width: 20),
                                      Container(
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
                                                    left: 20),
                                                child: Image.asset(
                                                  "lib/assets/pictures/rentals_verified.png",
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 25,
                                                    left: 5),
                                                child: CustomComponents
                                                    .displayText(
                                                  ProjectStrings.ri_approve,
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
                                          )),
                                    ],
                                  ),

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

  Widget displayDocuments(String documentName) {
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
                    CustomComponents.displayText(documentName,
                        fontSize: 10, fontWeight: FontWeight.w500),
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
}
