import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:slide_switcher/slide_switcher.dart";

class Rentals extends StatefulWidget {
  const Rentals({super.key});

  @override
  State<Rentals> createState() => _Rentals();
}

class _Rentals extends State<Rentals> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _seeCompleteBookingInfo();
    });
  }

  Future<void> _seeCompleteBookingInfo() async {
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

                          const SizedBox(height: 20)
                        ],
                      )),
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

                          const SizedBox(height: 20)
                        ],
                      )),
                  const SizedBox(height: 20),
                  UnconstrainedBox(
                    child: Row(
                      children: [
                        //  report
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(int.parse(
                                  ProjectColors.redButtonBackground
                                      .substring(2),
                                  radix: 16)),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                    "lib/assets/pictures/rentals_denied.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "rentals_report");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 25, left: 5),
                                    child: CustomComponents.displayText(
                                      ProjectStrings.dialog_report_button,
                                      color: Color(int.parse(
                                          ProjectColors.redButtonMain
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
                                        .dialog_approved_button,
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

                  const SizedBox(height: 15),
                  UnconstrainedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.dialog_transaction_number_title,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.lightGray)),
                            fontStyle: FontStyle.italic
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.dialog_transaction,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.lightGray)),
                            fontStyle: FontStyle.italic
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20)
                ],
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
              //  ActionBar
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
                      "Rent Profile",
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

              //  Header
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "lib/assets/pictures/app_logo_circle.png",
                      width: 120.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(int.parse(
                            ProjectColors.mainColorHex.substring(2),
                            radix: 16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 30, left: 30),
                        child: CustomComponents.displayText(
                          "Admin",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomComponents.displayText(
                            "Hello, Admin",
                            fontWeight: FontWeight.bold,
                          ),
                          CustomComponents.displayText(
                            "PH +63 ****** 8475",
                            fontWeight: FontWeight.w600,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)),
                          ),
                          const SizedBox(height: 10),
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
                                        top: 10,
                                        bottom: 10,
                                        right: 25,
                                        left: 5),
                                    child: CustomComponents.displayText(
                                      ProjectStrings
                                          .rentals_header_verified_button,
                                      color: Color(int.parse(
                                          ProjectColors.greenButtonMain
                                              .substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "lib/assets/pictures/home_top_image.png",
                        fit: BoxFit
                            .contain, // Ensure the image fits within its container
                      ),
                    ),
                  ],
                ),
              ),

              // Switch option
              const SizedBox(height: 15),
              SlideSwitcher(
                indents: 3,
                containerColor: Colors.white,
                containerBorderRadius: 7,
                slidersColors: [
                  Color(int.parse(
                      ProjectColors.mainColorHexBackground.substring(2),
                      radix: 16))
                ],
                containerHeight: 50,
                containerWight: MediaQuery.of(context).size.width - 50,
                onSelect: (index) {},
                children: [
                  CustomComponents.displayText(
                    ProjectStrings.rentals_options_ongoing,
                    color: Color(int.parse(ProjectColors.mainColorHex)),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomComponents.displayText(
                    ProjectStrings.rentals_options_history,
                    color: Color(int.parse(ProjectColors.mainColorHex)),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),

              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 0, bottom: 100),
                  scrollDirection: Axis.vertical,
                  children: [
                    //  First item
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      "lib/assets/pictures/rental_car_placeholder.png",
                                      width: 120,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Ensures children are aligned to the start horizontally
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings
                                              .rentals_car_name_placeholder,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_location,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10),
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_location_placeholder,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                              ProjectStrings.rentals_car_date,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10),
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_date_placeholder,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10)
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () {
                                          _seeCompleteBookingInfo();
                                        },
                                        child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(width: 40),
                                                CustomComponents.displayText(
                                                  ProjectStrings
                                                      .rentals_see_booking_info,
                                                  color: Color(int.parse(
                                                      ProjectColors.mainColorHex
                                                          .substring(2),
                                                      radix: 16)),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                                const SizedBox(width: 5),
                                                Image.asset(
                                                  "lib/assets/pictures/right_arrow.png",
                                                  width: 10,
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 7, bottom: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings
                                          .rentals_total_amount_placeholder,
                                      color: Color(int.parse(
                                          ProjectColors.mainColorHex
                                              .substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(int.parse(
                                            ProjectColors.lightGreen
                                                .substring(2),
                                            radix: 16)),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
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
                                            child: CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_status_approved,
                                              color: Color(int.parse(
                                                  ProjectColors.greenButtonMain
                                                      .substring(2),
                                                  radix: 16)),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //  Second item
                    const SizedBox(height: 5),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      "lib/assets/pictures/rental_car_placeholder.png",
                                      width: 120,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Ensures children are aligned to the start horizontally
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings
                                              .rentals_car_name_placeholder,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_location,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10),
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_location_placeholder,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                              ProjectStrings.rentals_car_date,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10),
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_date_placeholder,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10)
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 40),
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .rentals_see_booking_info,
                                                color: Color(int.parse(
                                                    ProjectColors.mainColorHex
                                                        .substring(2),
                                                    radix: 16)),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                              const SizedBox(width: 5),
                                              Image.asset(
                                                "lib/assets/pictures/right_arrow.png",
                                                width: 10,
                                              ),
                                            ],
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 7, bottom: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings
                                          .rentals_total_amount_placeholder,
                                      color: Color(int.parse(
                                          ProjectColors.mainColorHex
                                              .substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(int.parse(
                                            ProjectColors.carouselNotSelected
                                                .substring(2),
                                            radix: 16)),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Image.asset(
                                              "lib/assets/pictures/rentals_pending.png",
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
                                            child: CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_status_pending,
                                              color: Color(int.parse(
                                                  ProjectColors.darkGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    //  Third item
                    const SizedBox(height: 5),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      "lib/assets/pictures/rental_car_placeholder.png",
                                      width: 120,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Ensures children are aligned to the start horizontally
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings
                                              .rentals_car_name_placeholder,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_location,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10),
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_location_placeholder,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CustomComponents.displayText(
                                              ProjectStrings.rentals_car_date,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10),
                                          CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_car_date_placeholder,
                                              color: Color(int.parse(
                                                  ProjectColors.lightGray
                                                      .substring(2),
                                                  radix: 16)),
                                              fontSize: 10)
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Container(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 40),
                                              CustomComponents.displayText(
                                                ProjectStrings
                                                    .rentals_see_booking_info,
                                                color: Color(int.parse(
                                                    ProjectColors.mainColorHex
                                                        .substring(2),
                                                    radix: 16)),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                              const SizedBox(width: 5),
                                              Image.asset(
                                                "lib/assets/pictures/right_arrow.png",
                                                width: 10,
                                              ),
                                            ],
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 7, bottom: 7),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomComponents.displayText(
                                      ProjectStrings
                                          .rentals_total_amount_placeholder,
                                      color: Color(int.parse(
                                          ProjectColors.mainColorHex
                                              .substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold),
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(int.parse(
                                            ProjectColors.redButtonBackground
                                                .substring(2),
                                            radix: 16)),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Image.asset(
                                              "lib/assets/pictures/rentals_denied.png",
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
                                            child: CustomComponents.displayText(
                                              ProjectStrings
                                                  .rentals_status_denied,
                                              color: Color(int.parse(
                                                  ProjectColors.redButtonMain
                                                      .substring(2),
                                                  radix: 16)),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
