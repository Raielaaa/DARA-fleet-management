import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class CarStatus extends StatefulWidget {
  const CarStatus({super.key});

  @override
  State<CarStatus> createState() => _CarStatusState();
}

class _CarStatusState extends State<CarStatus> {
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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("lib/assets/pictures/left_arrow.png"),
                    ),
                    CustomComponents.displayText(
                      ProjectStrings.cs_appbar_title,
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

              // Main body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: Column(
                    children: [
                      // Available car units
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.cs_car_units,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Color(int.parse(
                                              ProjectColors
                                                  .greenButtonBackground
                                                  .substring(2),
                                              radix: 16)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 10,
                                              bottom: 10),
                                          child: CustomComponents.displayText(
                                            ProjectStrings.cs_available,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.greenButtonMain
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomComponents.displayText(
                                    ProjectStrings.cs_item_count,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                              height: 1,
                            ),
                            // list
                            const SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[2],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: double.infinity,
                                    height:
                                        90, // Make sure the container height is specified
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7)),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_list.jpg",
                                            width: 100,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_name,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_type,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                                const SizedBox(height: 25),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .cs_total_rentals,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          right: 10),
                                                  child: CustomComponents
                                                      .displayText(
                                                    ProjectStrings.cs_more_info,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .mainColorHex
                                                            .substring(2),
                                                        radix: 16)),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Unavailable car units
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.cs_car_units,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Color(int.parse(
                                              ProjectColors
                                                  .redButtonBackground
                                                  .substring(2),
                                              radix: 16)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 10,
                                              bottom: 10),
                                          child: CustomComponents.displayText(
                                            ProjectStrings.cs_unavailable,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.redButtonMain
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomComponents.displayText(
                                    ProjectStrings.cs_item_count,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                              height: 1,
                            ),
                            // list
                            const SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[2],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: double.infinity,
                                    height:
                                        90, // Make sure the container height is specified
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7)),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_list.jpg",
                                            width: 100,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_name,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_type,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                                const SizedBox(height: 25),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .cs_total_rentals,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          right: 10),
                                                  child: CustomComponents
                                                      .displayText(
                                                    ProjectStrings.cs_more_info,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .mainColorHex
                                                            .substring(2),
                                                        radix: 16)),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),


                      // outsourced units
                      // Available car units
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.cs_outsourced_units,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Color(int.parse(
                                              ProjectColors
                                                  .greenButtonBackground
                                                  .substring(2),
                                              radix: 16)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 10,
                                              bottom: 10),
                                          child: CustomComponents.displayText(
                                            ProjectStrings.cs_available,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.greenButtonMain
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomComponents.displayText(
                                    ProjectStrings.cs_item_count,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                              height: 1,
                            ),
                            // list
                            const SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[2],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: double.infinity,
                                    height:
                                        90, // Make sure the container height is specified
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7)),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_list.jpg",
                                            width: 100,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_name,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_type,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                                const SizedBox(height: 25),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .cs_total_rentals,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          right: 10),
                                                  child: CustomComponents
                                                      .displayText(
                                                    ProjectStrings.cs_more_info,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .mainColorHex
                                                            .substring(2),
                                                        radix: 16)),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Unavailable car units
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.cs_outsourced_units,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(width: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          color: Color(int.parse(
                                              ProjectColors
                                                  .redButtonBackground
                                                  .substring(2),
                                              radix: 16)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 10,
                                              bottom: 10),
                                          child: CustomComponents.displayText(
                                            ProjectStrings.cs_unavailable,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Color(int.parse(
                                                ProjectColors.redButtonMain
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CustomComponents.displayText(
                                    ProjectStrings.cs_item_count,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                              height: 1,
                            ),
                            // list
                            const SizedBox(height: 10),
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: kElevationToShadow[2],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: double.infinity,
                                    height:
                                        90, // Make sure the container height is specified
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7)),
                                          child: Image.asset(
                                            "lib/assets/pictures/car_list_placeholder_list.jpg",
                                            width: 100,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_name,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .car_list_vehicle_type_car_type,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                                const SizedBox(height: 25),
                                                CustomComponents.displayText(
                                                    ProjectStrings
                                                        .cs_total_rentals,
                                                    fontSize: 10,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .lightGray))),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          right: 10),
                                                  child: CustomComponents
                                                      .displayText(
                                                    ProjectStrings.cs_more_info,
                                                    color: Color(int.parse(
                                                        ProjectColors
                                                            .mainColorHex
                                                            .substring(2),
                                                        radix: 16)),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 56)
            ],
          ),
        ),
      ),
    );
  }
}
