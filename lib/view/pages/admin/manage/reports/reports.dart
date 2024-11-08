import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "../../../../../controller/singleton/persistent_data.dart";

class ManageReports extends StatefulWidget {
  const ManageReports({super.key});

  @override
  State<ManageReports> createState() => _ManageReportsState();
}

class _ManageReportsState extends State<ManageReports> {
  Future<void> _seeCompleteReportInfo() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  top design
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: Image.asset(
                            "lib/assets/pictures/header_background_curves.png",
                            width: MediaQuery.of(context).size.width - 10,
                            height: 70, // Adjust height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 15, left: 15, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.dialog_title_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              Image.asset(
                                "lib/assets/pictures/app_logo_circle.png",
                                width: 80.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                        color: Colors.white,
                        height: 250,
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
                                                radix: 16)),
                                            border: Border.all(
                                                color: Color(int.parse(
                                                    ProjectColors.lineGray)),
                                                width: 1)),
                                        child: Center(
                                            child: CustomComponents.displayText(
                                                "1",
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
                                          ProjectStrings.dialog_car_info_title,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomComponents.displayText(
                                          ProjectStrings.dialog_car_info,
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
                            //  car model
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_car_model_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_car_model,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  Transmission
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_transmission_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_transmission,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  seat capacity
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_capacity_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_capacity,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  fuel variant
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_fuel_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_fuel,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  fuel capacity
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_fuel_capacity_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_fuel_capacity,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  unit color
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_unit_color_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog__unit_color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  engine
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_engine_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_engine,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            const SizedBox(height: 10)
                          ],
                        )),
                    //  rent information
                    const SizedBox(height: 20),
                    Container(
                        color: Colors.white,
                        height: 250,
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
                                                radix: 16)),
                                            border: Border.all(
                                                color: Color(int.parse(
                                                    ProjectColors.lineGray)),
                                                width: 1)),
                                        child: Center(
                                            child: CustomComponents.displayText(
                                                "2",
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
                                          ProjectStrings.dialog_title_2,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomComponents.displayText(
                                          ProjectStrings.dialog_title_2_subheader,
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
                            //  rent start date
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_rent_start_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_rent_start,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_rent_end_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog__rent_end,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_delivery_mode_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_delivery_mode,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings
                                          .dialog_delivery_location_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_delivery_location,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  location
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_location_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_location,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  isReserve
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_reserved_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_reserved,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  admin notes
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.dialog_admin_notes_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.dialog_admin_notes,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            const SizedBox(height: 10)
                          ],
                        )),
                      
                    //  report information
                    const SizedBox(height: 20),
                    Container(
                        color: Colors.white,
                        height: 190,
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
                                                radix: 16)),
                                            border: Border.all(
                                                color: Color(int.parse(
                                                    ProjectColors.lineGray)),
                                                width: 1)),
                                        child: Center(
                                            child: CustomComponents.displayText(
                                                "3",
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
                                          ProjectStrings.mr_dialog_title_3,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomComponents.displayText(
                                          ProjectStrings.mr_dialog_title_3_subheader,
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
                            //  photo
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: CustomComponents.displayText(
                                        ProjectStrings.mr_dialog_photo_title,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        color: Color(int.parse(
                                            ProjectColors.lightGray.substring(2),
                                            radix: 16))),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        CustomComponents.displayText(
                                          ProjectStrings.mr_dialog_photo,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                        ),
                                        const SizedBox(width: 7),
                                        Image.asset(
                                          "lib/assets/pictures/right_arrow.png",
                                          width: 10,
                                        )
                                      ]
                                    ),
                                  )
                                ],
                              ),
                            ),
                
                            //  location
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.mr_dialog_3_location_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.mr_dialog_3_location,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  issues
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.mr_dialog_issues_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.mr_dialog_issues,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                
                            //  comments
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings.mr_dialog_comments_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.mr_dialog_comments,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                
                    const SizedBox(height: 15),
                    UnconstrainedBox(
                      child: Row(
                        children: [
                          //  mark as resolved
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(int.parse(
                                    ProjectColors.lightGreen.substring(2),
                                    radix: 16)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      "lib/assets/pictures/rentals_verified.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 25, left: 5),
                                    child: CustomComponents.displayText(
                                      ProjectStrings
                                          .mr_dialog_mark_as_resolve,
                                      color: Color(int.parse(
                                          ProjectColors.greenButtonMain
                                              .substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )
                            ),
                        ],
                      ),
                    ),
                
                    const SizedBox(height: 15)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
              // AppBar
              Container(
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
                      ProjectStrings.manage_reports_appbar,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomComponents.menuButtons(context),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting, date, and user picture
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  ProjectStrings.manage_reports_greetings,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 3),
                                CustomComponents.displayText(
                                  PersistentData().getCurrentFormattedDate(),
                                  fontSize: 12,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "lib/assets/pictures/user_info_user.png",
                              width: 42,
                              height: 42,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Admin Options
                      Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.05,
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomComponents.displayText(
                                ProjectStrings.manage_reports_admin_options,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width * 0.03,
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Color(int.parse(ProjectColors.lineGray)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.05,
                              vertical: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // application list
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("manage_application_list");
                                  },
                                  child: buildAdminOption(
                                    "lib/assets/pictures/application_list.png",
                                    ProjectStrings.application_list_manage_title,
                                    Colors.white,
                                    context,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                // inquiries
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("manage_inquiries");
                                  },
                                  child: buildAdminOption(
                                    "lib/assets/pictures/manage_report_inquiries.png",
                                    ProjectStrings.manage_reports_inquiries,
                                    Colors.white,
                                    context,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                // car status
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("manage_car_status");
                                  },
                                  child: buildAdminOption(
                                    "lib/assets/pictures/manage_report_car_status.png",
                                    ProjectStrings.manage_reports_car_status,
                                    Colors.white,
                                    context,
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                // user list
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("manage_user_list");
                                  },
                                  child: buildAdminOption(
                                    "lib/assets/pictures/user_list.png",
                                    ProjectStrings.manage_reports_user_list,
                                    Colors.white,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // rent logs
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("manage_rent_logs");
                                },
                                child: buildAdminOption(
                                  "lib/assets/pictures/rents.png",
                                  "Rent Logs",
                                  Colors.white,
                                  context,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                              // units
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("manage_car_list");
                                },
                                child: buildAdminOption(
                                  "lib/assets/pictures/check_list.png",
                                  "Units",
                                  Colors.white,
                                  context,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                              // banner
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("manage_banner");
                                },
                                child: buildAdminOption(
                                  "lib/assets/pictures/banner.png",
                                  "Banner",
                                  Colors.white,
                                  context,
                                ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                              // backup restore
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed("manage_backup_restore");
                                },
                                child: buildAdminOption(
                                  "lib/assets/pictures/cloud.png",
                                  "Backup",
                                  Colors.white,
                                  context,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),

                      // Integrated Apps
                      const SizedBox(height: 30),
                      CustomComponents.displayText(
                        ProjectStrings.manage_reports_integrated_apps,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          buildIntegratedApp(
                            "lib/assets/pictures/google_maps_icon.png",
                            ProjectStrings.manage_reports_google_maps,
                            "0xffffffff"
                          ),
                          const SizedBox(width: 15),
                          buildIntegratedApp(
                            "lib/assets/pictures/bottom_nav_bar_antrip.png",
                            ProjectStrings.manage_reports_antrip_iot,
                            ProjectColors.antripIOTColor
                          ),
                        ],
                      ),

                      // Reports Section
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.manage_reports_reports,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.manage_reports_see_all,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.mainColorHex
                                .substring(2),
                                radix: 16)),
                          )
                        ],
                      ),

                      // Main Report List
                      const SizedBox(height: 15),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              height: 90,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _seeCompleteReportInfo();
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(int.parse(ProjectColors
                                                  .reportItemBackground
                                                  .substring(2),
                                                  radix: 16)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(18.0),
                                              child: CustomComponents.displayText(
                                                "SR",
                                                color: Color(int.parse(ProjectColors
                                                    .reportPurple.substring(2),
                                                    radix: 16)),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .manage_reports_sr_title,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                              const SizedBox(height: 5),
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .manage_reports_sr_report_number,
                                                fontSize: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Image.asset(
                                      "lib/assets/pictures/trash.png",
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAdminOption(String imagePath, String label, Color itemBgColor, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: itemBgColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.01,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.width * 0.12,
              decoration: BoxDecoration(
                color: Color(int.parse(ProjectColors.reportManageItemBackground)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(
                  imagePath,
                  color: const Color(0xFF3FA2BE),
                  width: imagePath.contains("manage_report_inquiries.png")
                      ? MediaQuery.of(context).size.width * 0.055
                      : imagePath.contains("application_list.png")
                      ? MediaQuery.of(context).size.width * 0.035
                      : imagePath.contains("banner")
                      ? MediaQuery.of(context).size.width * 0.048
                      : imagePath.contains("backup")
                      ? MediaQuery.of(context).size.width * 0.055
                      : imagePath.contains("check_list.png")
                      ? MediaQuery.of(context).size.width * 0.055
                      : imagePath.contains("cloud.png")
                      ? MediaQuery.of(context).size.width * 0.043
                      : MediaQuery.of(context).size.width * 0.045,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.008,
            child: CustomComponents.displayText(
              label,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIntegratedApp(String imagePath, String label, String bgColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 90,
          decoration: BoxDecoration(
            color: Color(int.parse(ProjectColors.reportMangeSelectedItem
                .substring(2),
                radix: 16)),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Color(int.parse(bgColor)),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Image.asset(
            imagePath,
            width: 30,
          ),
        ),
        Positioned(
          bottom: 10,
          child: CustomComponents.displayText(
            label,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
