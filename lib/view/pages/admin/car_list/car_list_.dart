import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

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
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      CustomComponents.displayText(
                        ProjectStrings.car_list_top_deal_header,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      CustomComponents.displayText(
                        ProjectStrings.car_list_top_deal_subheader,
                        color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
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

                                  // const SizedBox(width: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(ProjectColors.greenButtonBackground)),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                                      child: CustomComponents.displayText(
                                        ProjectStrings.car_list_top_deal_available,
                                        color: Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                      ),
                                    ),
                                  )
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
                                      //  mileage icon
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
                                              fontSize: 12
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_mileage_count,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      //  mileage icon
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
                                              fontSize: 12
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_capacity_count,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      //  mileage icon
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
                                              fontSize: 12
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_fuel_count,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
//////////////////////////
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      //  mileage icon
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
                                              fontSize: 12
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_fuel_variant_count,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      //  mileage icon
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
                                              fontSize: 12
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_gear_count,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      //  mileage icon
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
                                              fontSize: 12
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_top_deal_color_count,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                                            )
                                          ],
                                        )
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
                                        fontSize: 16
                                      ),
                                      CustomComponents.displayText(
                                        ProjectStrings.car_list_top_deal_price_desc,
                                        color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                        fontSize: 10
                                      )
                                    ],
                                  ),
                              
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                      borderRadius: BorderRadius.circular(7)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 10, right: 40, left: 40),
                                      child: CustomComponents.displayText(
                                        ProjectStrings.car_list_top_deal_rent_button,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
