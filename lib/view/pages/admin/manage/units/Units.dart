import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:flutter/material.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../../controller/car_list/car_list_controller.dart";
import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/car_list/complete_car_list.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/strings.dart";

class ManageCarList extends StatefulWidget {
  const ManageCarList({super.key});

  @override
  State<ManageCarList> createState() => _ManageCarListState();
}

class _ManageCarListState extends State<ManageCarList> {
  final CarListController _carListController = CarListController();
  TextEditingController _searchController = TextEditingController();
  List<CompleteCarInfo> itemsToBeDisplayed = [];
  List<CompleteCarInfo> sedans = [];
  List<CompleteCarInfo> suvs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(FirebaseConstants.carInfoCollection).get();
    List<CompleteCarInfo> cars = querySnapshot.docs
        .map((doc) => CompleteCarInfo.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();

    setState(() {
      // Sort and categorize cars here
      cars.sort((a, b) => b.rentCount.compareTo(a.rentCount));
      sedans = cars.where((car) => car.carType.toLowerCase() == 'sedan').toList();
      suvs = cars.where((car) => car.carType.toLowerCase() == 'suv').toList();
      itemsToBeDisplayed = sedans; // Set initial display to sedans
      _isLoading = false;
    });
  }

  Future<void> _refreshPage() async {
    await fetchCars();
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                    "Car Inventory",
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                    "Manage and monitor all available units",
                    fontSize: 10
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_circle_outline_outlined,
                          size: 17,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        CustomComponents.displayText(
                            "Add new unit",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              switcher(sedans, suvs),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _searchAndFilterBar(),
              ),
              const SizedBox(height: 15),
              Expanded(child: carList()),
              const SizedBox(height: 60)
            ],
          ),
        ),
      ),
    );
  }

  Widget carList() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: _isLoading
          ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      "lib/assets/pictures/data_not_found.jpg",
                      width: MediaQuery.of(context).size.width - 200,
                    ),
                    const SizedBox(height: 20),
                    CustomComponents.displayText(
                        "No records found at the moment. Please try again later.",
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ),
          ) : RefreshIndicator(
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        onRefresh: () async {
          _refreshPage();
        },
            child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: itemsToBeDisplayed.length,
                    itemBuilder: (BuildContext context, int index) {
            CompleteCarInfo currentItem = itemsToBeDisplayed[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Column(
                  children: [
                    //  list item header
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomComponents.displayText(
                                  currentItem.name,
                                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CustomComponents.displayText(
                                      currentItem.carType.toLowerCase() == "sedan" ? "Sedan - ${
                                          currentItem.carOwner.toLowerCase() == "dats" ? "Owner Unit" : "Outsource Unit"
                                      }" : "SUV - ${
                                          currentItem.carOwner.toLowerCase() == "dats" ? "Owner Unit" : "Outsource Unit"
                                      }",
                                      fontSize: 10
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomComponents.displayText(
                                  "PHP ${currentItem.price}",
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold
                              ),
                              CustomComponents.displayText(
                                  " / 24 hrs",
                                  fontSize: 10
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 5),
                    //  main content
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.network(
                            FirebaseConstants.retrieveImage(currentItem.mainPicUrl),
                            width: 100,
                          )
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            specificationsItem(
                              firstItemImage: "lib/assets/pictures/color_icon.png",
                              firstItemTitle: currentItem.color,
                              firstItemSubtitle: "Color",
                              secondItemImage: "lib/assets/pictures/fuel_icon.png",
                              secondItemTitle: currentItem.fuel,
                              secondItemSubtitle: "Fuel"
                            ),
                            const SizedBox(height: 10),
                            specificationsItem(
                                firstItemImage: "lib/assets/pictures/capacity_icon.png",
                                firstItemTitle: "${currentItem.capacity} seats",
                                firstItemSubtitle: "Capacity",
                                secondItemImage: "lib/assets/pictures/gear_icon.png",
                                secondItemTitle: currentItem.transmission,
                                secondItemSubtitle: "Gear"
                            ),
                            const SizedBox(height: 10),
                            specificationsItem(
                                firstItemImage: "lib/assets/pictures/fuel_variant_icon.png",
                                firstItemTitle: currentItem.fuelVariant,
                                firstItemSubtitle: "Fuel Variant",
                                secondItemImage: "lib/assets/pictures/mileage_icon.png",
                                secondItemTitle: currentItem.mileage,
                                secondItemSubtitle: "Mileage"
                            ),
                          ],
                        )
                      ]
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: GestureDetector(
                          onTap: () {
                            PersistentData().selectedCarUnitForManageUnit = currentItem;
                            Navigator.of(context).pushNamed("manage_view_more");
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16)),
                              borderRadius: BorderRadius.circular(7)
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 20),
                                child: CustomComponents.displayText(
                                  "View More",
                                  fontWeight: FontWeight.bold,
                                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                  fontSize: 10
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7)
                  ],
                ),
              ),
            );
                    }
                  ),
          ),
    );
  }

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

  Widget specificationsItem({
    required String firstItemImage,
    required String firstItemTitle,
    required String firstItemSubtitle,
    required String secondItemImage,
    required String secondItemTitle,
    required String secondItemSubtitle
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
                firstItemImage,
              width: 20,
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    firstItemTitle,
                    fontWeight: FontWeight.bold,
                    fontSize: 10
                ),
                CustomComponents.displayText(
                    firstItemSubtitle,
                    fontSize: 10
                ),
              ],
            )
          ],
        ),
        const SizedBox(width: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
                secondItemImage,
              width: 20,
            ),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomComponents.displayText(
                    secondItemTitle,
                    fontWeight: FontWeight.bold,
                    fontSize: 10
                ),
                CustomComponents.displayText(
                    secondItemSubtitle,
                    fontSize: 10
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _searchAndFilterBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.white,
          width: 0.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.search,
              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              size: 25,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 170,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: "Search by car specifications",
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    fontFamily: ProjectStrings.general_font_family,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: ProjectStrings.general_font_family,
                ),
              ),
            ),
            const SizedBox(width: 20, height: 20),
          ],
        ),
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
            "Manage Units",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
