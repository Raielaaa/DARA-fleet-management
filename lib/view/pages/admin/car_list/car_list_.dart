import 'package:dara_app/controller/car_list/car_list_controller.dart';
import 'package:dara_app/controller/home/home_controller.dart';
import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../model/car_list/complete_car_list.dart';

class CarList extends StatefulWidget {
  const CarList({super.key});

  @override
  State<CarList> createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  final CarListController _carListController = CarListController();
  List<CompleteCarInfo> itemsToBeDisplayed = [];
  List<CompleteCarInfo> sedans = [];
  List<CompleteCarInfo> suvs = [];
  late CompleteCarInfo mostFavoriteCar;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> _refreshPage() async {
    fetchCars();
    CustomComponents.showToastMessage("Page refreshed", Colors.black54, Colors.white);
  }

  Future<void> fetchCars() async {
    List<CompleteCarInfo> cars = await _carListController.fetchCars();
    setState(() {
      // Sort and categorize cars here
      cars.sort((a, b) => b.rentCount.compareTo(a.rentCount));
      mostFavoriteCar = cars.first;
      sedans = cars.where((car) => car.carType.toLowerCase() == 'sedan').toList();
      suvs = cars.where((car) => car.carType.toLowerCase() == 'suv').toList();
      itemsToBeDisplayed = sedans; // Set initial display to sedans
    });
    debugPrint("refreshed");
  }


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
                child: RefreshIndicator(
                  onRefresh: _refreshPage,
                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                    child: itemsToBeDisplayed.isEmpty // Checking if data is loaded
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                      padding: EdgeInsets.zero,
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
                        //  most popular item
                        const SizedBox(height: 15),
                        topItem(mostFavoriteCar: mostFavoriteCar),
                  
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
                        switcher(sedans, suvs),
                        const SizedBox(height: 15),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemsToBeDisplayed.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                PersistentData().selectedCarItem = itemsToBeDisplayed[index];
                                Navigator.of(context).pushNamed("selected_item");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7)),
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              bottomLeft: Radius.circular(7),
                                            ),
                                            child: Image.network(
                                              FirebaseConstants.retrieveImage(itemsToBeDisplayed[index].pic1Url),
                                              width: 100,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomComponents.displayText(
                                              itemsToBeDisplayed[index].name,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                            CustomComponents.displayText(
                                              itemsToBeDisplayed[index].carType,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray)),
                                            ),
                                            const SizedBox(height: 10),
                                            CustomComponents.displayText(
                                              "PHP ${itemsToBeDisplayed[index].price}.00",
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                            ),
                                            CustomComponents.displayText(
                                              ProjectStrings.car_list_vehicle_type_price_desc,
                                              fontSize: 10,
                                              color: Color(int.parse(ProjectColors.lightGray)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 7, right: 7),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: itemsToBeDisplayed[index].availability == "available"
                                                      ? Color(int.parse(ProjectColors.greenButtonBackground.substring(2), radix: 16))
                                                      : Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                                                  child: CustomComponents.displayText(
                                                    CustomComponents.capitalizeFirstLetter(itemsToBeDisplayed[index].availability),
                                                    color: itemsToBeDisplayed[index].availability == "available"
                                                        ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16))
                                                        : Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(7)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 7, bottom: 7, right: 30, left: 30),
                                                child: CustomComponents.displayText(
                                                  ProjectStrings.car_list_vehicle_type_visit,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
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
                          },
                        ),
                        const SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              PersistentData().openDrawer(1);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
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
    );
  }

  Widget topItem({
    required CompleteCarInfo mostFavoriteCar
  }) {
    return GestureDetector(
      onTap: () {
        PersistentData().selectedCarItem = mostFavoriteCar;
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
                  child: Image.network(
                    FirebaseConstants.retrieveImage(mostFavoriteCar.pic1Url),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomComponents.displayText(
                          mostFavoriteCar.name,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: mostFavoriteCar.availability == "available" ? Color(int.parse(ProjectColors.greenButtonBackground)) : Color(int.parse(ProjectColors.redButtonBackground)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 7, bottom: 7, right: 20, left: 20),
                          child: CustomComponents.displayText(
                            CustomComponents.capitalizeFirstLetter(mostFavoriteCar.availability),
                            color: mostFavoriteCar.availability == "available" ? Color(int.parse(ProjectColors.greenButtonMain)) : Color(int.parse(ProjectColors.redButtonMain)),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 15, left: 15, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child:
                      Flexible(
                        child: CustomComponents.displayText(
                          mostFavoriteCar.shortDescription,
                          fontSize: 10,
                        ),
                      ),
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
                                  mostFavoriteCar.mileage,
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
                                  mostFavoriteCar.capacity,
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
                                  mostFavoriteCar.fuel,
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
                                  mostFavoriteCar.fuelVariant,
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
                                  mostFavoriteCar.transmission,
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
                                  mostFavoriteCar.color,
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
                            "PHP ${mostFavoriteCar.price}.00",
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
    );
  }

  // The Widget that switches between sedans and SUVs
  Widget switcher(List<CompleteCarInfo> sedans, List<CompleteCarInfo> suvs) {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [
        Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
      ],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      onSelect: (index) {
        setState(() {
          itemsToBeDisplayed = index == 0 ? sedans : suvs;
        });
      },
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
        )
      ],
    );
  }
}
