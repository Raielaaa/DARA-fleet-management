import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class ShowDialog {
  Future<void> seeCompleteReportInfo(BuildContext context) async {
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
                        height: 150,
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
                                          ProjectStrings.income_page_third_panel_title,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomComponents.displayText(
                                          ProjectStrings.income_page_third_panel_subheader,
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
                                  CustomComponents.displayText(
                                      ProjectStrings.income_page_rent_duration_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.income_page_rent_duration_content,
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
                                      ProjectStrings.income_page_reserved_customers_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.income_page_reserved_customer_content,
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
                                      ProjectStrings.income_page_amount_title,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Color(int.parse(
                                          ProjectColors.lightGray.substring(2),
                                          radix: 16))),
                                  CustomComponents.displayText(
                                    ProjectStrings.income_page_amount_content,
                                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
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
}