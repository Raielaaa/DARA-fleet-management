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
                      padding:
                          const EdgeInsets.only(left: 25, right: 25),
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
