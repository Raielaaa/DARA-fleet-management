import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
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
                      "Car Lists",
                      fontWeight: FontWeight.bold,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("lib/assets/pictures/three_vertical_dots.png"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    children: [
                      CustomComponents.displayText(
                        ProjectStrings.car_list_top_deal_header,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      CustomComponents.displayText(
                        ProjectStrings.car_list_top_deal_subheader,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "selected_item");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7),
                                    ),
                                    child: Image.asset(
                                      "lib/assets/pictures/car_list_featured_placeholder.jpg",
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomComponents.displayText(
                                            ProjectStrings.car_list_top_deal_car_name,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                                          ),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/star.png",
                                                height: 12,
                                              ),
                                              const SizedBox(width: 4),
                                              CustomComponents.displayText(
                                                ProjectStrings.car_list_top_deal_ratings,
                                                color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: CustomComponents.displayText(
                                            ProjectStrings.car_list_top_deal_car_desc,
                                            color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                            fontSize: 10,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(ProjectColors.greenButtonBackground)),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                                            child: CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_available,
                                              color: Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            // mileage icon
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/mileage_icon.png",
                                                width: 25,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_mileage,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_mileage_count,
                                                    fontSize: 10,
                                                    color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            // mileage icon
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/capacity_icon.png",
                                                width: 25,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_capacity,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_capacity_count,
                                                    fontSize: 10,
                                                    color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            // mileage icon
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/fuel_icon.png",
                                                width: 25,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_fuel,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_fuel_count,
                                                    fontSize: 10,
                                                    color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            // mileage icon
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/fuel_variant_icon.png",
                                                width: 25,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_fuel_variant,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_fuel_variant_count,
                                                    fontSize: 10,
                                                    color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            // mileage icon
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/gear_icon.png",
                                                width: 25,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_gear,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_gear_count,
                                                    fontSize: 10,
                                                    color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            // mileage icon
                                            children: [
                                              Image.asset(
                                                "lib/assets/pictures/color_icon.png",
                                                width: 25,
                                              ),
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_color,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                  CustomComponents.displayText(
                                                    ProjectStrings.car_list_top_deal_color_count,
                                                    fontSize: 10,
                                                    color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_price,
                                              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_price_desc,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                              fontSize: 10,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                            borderRadius: BorderRadius.circular(7),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
                                            child: CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_rent_button,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  width: 40, // Circle diameter
                                  height: 40, // Circle diameter
                                  decoration: const BoxDecoration(
                                    color: Colors.white, // Background color of the circle
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      "lib/assets/pictures/expand.png",
                                      width: 15,
                                    )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Vehicle Type
                      const SizedBox(height: 25),
                      CustomComponents.displayText(
                        ProjectStrings.car_list_vehicle_type_header,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      CustomComponents.displayText(
                        ProjectStrings.car_list_vehicle_type_subheader,
                        fontSize: 12,
                      ),

                      // Switch option
                      const SizedBox(height: 15),
                      SlideSwitcher(
                        indents: 3,
                        containerColor: Colors.white,
                        containerBorderRadius: 7,
                        slidersColors: [
                          Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                        ],
                        containerHeight: 50,
                        containerWight: MediaQuery.of(context).size.width - 50,
                        onSelect: (index) {},
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.car_list_vehicle_type_switch_sedan,
                            color: Color(int.parse(ProjectColors.mainColorHex)),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.car_list_vehicle_type_switch_suv,
                            color: Color(int.parse(ProjectColors.mainColorHex)),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),

                      //  First item
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                                  child: Image.asset(
                                    "lib/assets/pictures/car_list_placeholder_list.jpg",
                                    width: 100,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_car_name,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12
                                ),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_car_type,
                                  fontSize: 10,
                                  color: Color(int.parse(ProjectColors.lightGray))
                                ),

                                const SizedBox(height: 10),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_price,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                ),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_price_desc,
                                  fontSize: 10,
                                  color: Color(int.parse(ProjectColors.lightGray))
                                ),
                              ],
                            ),

                            const Spacer(),

                            Container(
                              height: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7, right: 7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(ProjectColors.greenButtonBackground)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                                        child: CustomComponents.displayText(
                                          ProjectStrings.car_list_top_deal_available,
                                          color: Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(7))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 30, left: 30),
                                      child: CustomComponents.displayText(
                                        ProjectStrings.car_list_vehicle_type_visit,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //  2nd item
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                                  child: Image.asset(
                                    "lib/assets/pictures/hyundai_accent_bg.jpg",
                                    width: 100,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  // ProjectStrings.car_list_vehicle_type_car_name,
                                  "Accent 2019",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12
                                ),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_car_type,
                                  fontSize: 10,
                                  color: Color(int.parse(ProjectColors.lightGray))
                                ),

                                const SizedBox(height: 10),
                                CustomComponents.displayText(
                                  // ProjectStrings.car_list_vehicle_type_price,
                                  "Hyundai",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                ),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_price_desc,
                                  fontSize: 10,
                                  color: Color(int.parse(ProjectColors.lightGray))
                                ),
                              ],
                            ),

                            const Spacer(),

                            Container(
                              height: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7, right: 7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(ProjectColors.redButtonBackground)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                                        child: CustomComponents.displayText(
                                          ProjectStrings.car_list_vehicle_type_unavailable_2,
                                          color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(7))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 30, left: 30),
                                      child: CustomComponents.displayText(
                                        ProjectStrings.car_list_vehicle_type_visit,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //  3rd item
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        width: double.infinity,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), bottomLeft: Radius.circular(7)),
                                  child: Image.asset(
                                    "lib/assets/pictures/toyota_innova_bg.jpg",
                                    width: 100,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  // ProjectStrings.car_list_vehicle_type_car_name,
                                  "Innova 2024",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12
                                ),
                                CustomComponents.displayText(
                                  // ProjectStrings.car_list_vehicle_type_car_type,
                                  "Toyota",
                                  fontSize: 10,
                                  color: Color(int.parse(ProjectColors.lightGray))
                                ),

                                const SizedBox(height: 10),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_price,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                                ),
                                CustomComponents.displayText(
                                  ProjectStrings.car_list_vehicle_type_price_desc,
                                  fontSize: 10,
                                  color: Color(int.parse(ProjectColors.lightGray))
                                ),
                              ],
                            ),

                            const Spacer(),

                            Container(
                              height: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7, right: 7),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(ProjectColors.greenButtonBackground)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                                        child: CustomComponents.displayText(
                                          ProjectStrings.car_list_top_deal_available,
                                          color: Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(7))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 30, left: 30),
                                      child: CustomComponents.displayText(
                                        ProjectStrings.car_list_vehicle_type_visit,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 70),
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
}
