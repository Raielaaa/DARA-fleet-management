import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class UnitPreview extends StatefulWidget {
  const UnitPreview({super.key});

  @override
  State<UnitPreview> createState() => _UnitPreviewState();
}

class _UnitPreviewState extends State<UnitPreview> {
  //  information dialog metadata
  CompleteCarInfo selectedCarItem = PersistentData().selectedCarItem!;

  int _informationDialogCurrentIndex = 0;
  final List<Map<String, String>> guides = [
    {
      "title": ProjectStrings.id_title_1,
      "content": ProjectStrings.id_content_1
    },
    {
      "title": ProjectStrings.id_title_2,
      "content": ProjectStrings.id_content_2
    },
    {
      "title": ProjectStrings.id_title_3,
      "content": ProjectStrings.id_content_3
    },
    {
      "title": ProjectStrings.id_title_4,
      "content": ProjectStrings.id_content_4
    },
    {
      "title": ProjectStrings.id_title_5,
      "content": ProjectStrings.id_content_5
    },
    {
      "title": ProjectStrings.id_title_6,
      "content": ProjectStrings.id_content_6
    },
    {
      "title": ProjectStrings.id_title_7,
      "content": ProjectStrings.id_content_7
    },
  ];

  void _showInformationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Image.asset(
                          "lib/assets/pictures/exit.png",
                          width: 30,
                        ),
                      ),
                    ),
                    //  left arrow - main image - right arrow
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_informationDialogCurrentIndex > 0) {
                                _informationDialogCurrentIndex--;
                              }
                            });
                          },
                          child: Image.asset(
                            "lib/assets/pictures/id_left_arrow.png",
                            width: 30,
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            child: KeyedSubtree(
                              key:
                                  ValueKey<int>(_informationDialogCurrentIndex),
                              child: Image.asset(
                                  "lib/assets/pictures/information_dialog.png"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_informationDialogCurrentIndex <
                                  guides.length - 1) {
                                _informationDialogCurrentIndex++;
                              } else {
                                Navigator.of(parentContext).pushNamed("rp_booking_details");
                                Navigator.of(context).pop();
                              }
                            });
                          },
                          child: Image.asset(
                              "lib/assets/pictures/id_right_arrow.png",
                              width: 30),
                        ),
                      ],
                    ),
                    //  indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(guides.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _informationDialogCurrentIndex == index
                                ? Color(int.parse(
                                    ProjectColors.mainColorHex.substring(2),
                                    radix: 16))
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    //  title
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(_informationDialogCurrentIndex),
                          child: CustomComponents.displayText(
                            guides[_informationDialogCurrentIndex]["title"]!,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    //  content
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key:
                              ValueKey<int>(_informationDialogCurrentIndex + 1),
                          child: CustomComponents.displayText(
                            textAlign: TextAlign.center,
                            guides[_informationDialogCurrentIndex]["content"]!,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    //  spacer
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showSelectedImageDialog(String imageUrl) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Color(int.parse(
                ProjectColors.mainColorBackground.substring(2),
                radix: 16)),
            child:
                Image.network(FirebaseConstants.retrieveImage(imageUrl)),
          );
        });
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
              appBar(),

              //  top image
              Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: Image.network(
                        FirebaseConstants.retrieveImage(selectedCarItem.pic1Url),
                        fit: BoxFit.cover,
                      )),

                  //  expand button
                  GestureDetector(
                    onTap: () {
                      _showSelectedImageDialog(selectedCarItem.pic1Url);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, right: 15),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(int.parse(
                                  ProjectColors.mainColorBackground
                                      .substring(2),
                                  radix: 16)),
                              borderRadius: BorderRadius.circular(100)),
                          width: 40,
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              "lib/assets/pictures/expand.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //  multiple image preview
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 228,
                        height: 48,
                        decoration: BoxDecoration(
                            color: Color(int.parse(
                                ProjectColors.mainColorBackground.substring(2),
                                radix: 16)),
                            borderRadius: BorderRadius.circular(7)),
                        child: Row(
                          children: [
                            //  first image preview
                            GestureDetector(
                              onTap: () {
                                _showSelectedImageDialog(selectedCarItem.pic1Url);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, top: 3, bottom: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      FirebaseConstants.retrieveImage(selectedCarItem.pic1Url),
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                            ),

                            //  second image preview
                            GestureDetector(
                              onTap: () {
                                _showSelectedImageDialog(selectedCarItem.pic2Url);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, top: 3, bottom: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      FirebaseConstants.retrieveImage(selectedCarItem.pic2Url),
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                            ),

                            //  third image preview
                            GestureDetector(
                              onTap: () {
                                _showSelectedImageDialog(selectedCarItem.pic3Url);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, top: 3, bottom: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      FirebaseConstants.retrieveImage(selectedCarItem.pic3Url),
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                            ),

                            //  fourth image preview
                            GestureDetector(
                              onTap: () {
                                _showSelectedImageDialog(selectedCarItem.pic4Url);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, top: 3, bottom: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      FirebaseConstants.retrieveImage(selectedCarItem.pic4Url),
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                            ),

                            //  fifth image preview
                            GestureDetector(
                              onTap: () {
                                _showSelectedImageDialog(selectedCarItem.pic5Url);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3, top: 3, bottom: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(
                                      FirebaseConstants.retrieveImage(selectedCarItem.pic5Url),
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),

              //  car information panel
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2 + 70,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(7),
                                bottomRight: Radius.circular(7))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: CustomComponents.displayText(
                                      selectedCarItem.name,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        color: selectedCarItem.availability.toLowerCase() == "available" ? Color(int.parse(
                                            ProjectColors
                                                .greenButtonBackground
                                                .substring(2),
                                            radix: 16)) : Color(int.parse(
                                            ProjectColors
                                                .redButtonBackground
                                                .substring(2),
                                            radix: 16)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            right: 25,
                                            left: 25),
                                        child: CustomComponents.displayText(
                                          CustomComponents.capitalizeFirstLetter(selectedCarItem.availability),
                                          color: selectedCarItem.availability.toLowerCase() == "available" ? Color(int.parse(
                                              ProjectColors
                                                  .greenButtonMain
                                                  .substring(2),
                                              radix: 16)) : Color(int.parse(
                                              ProjectColors
                                                  .redButtonMain
                                                  .substring(2),
                                              radix: 16)),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                    selectedCarItem.shortDescription,
                                    fontSize: 10
                                ),
                              ),
                              Expanded(
                                // main info
                                child: DefaultTabController(
                                    length: 2,
                                    child: Scaffold(
                                      backgroundColor: Colors.white,
                                      appBar: PreferredSize(
                                        preferredSize: const Size.fromHeight(29),
                                        child: AppBar(
                                          backgroundColor: Colors.white,
                                          automaticallyImplyLeading: false,
                                          toolbarHeight: 0,
                                          bottom: const TabBar(
                                            indicatorSize:
                                            TabBarIndicatorSize.tab,
                                            indicatorColor: Color(0xff3FA2BE),
                                            tabs: [
                                              //  first tab
                                              Padding(
                                                padding:
                                                EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  ProjectStrings.si_features,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                      color: Color(0xff3FA2BE)),
                                                ),
                                              ),
                                              //  second tab
                                              Padding(
                                                padding:
                                                EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  ProjectStrings.si_about,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                      color: Color(0xff3FA2BE)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      body: TabBarView(children: [
                                        //  first tab item
                                        buildResponsiveUI(context),
                                        //  second tab item
                                        Container(
                                            child: Column(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15, top: 15),
                                                child: CustomComponents.displayText(
                                                    selectedCarItem.shortDescription,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Expanded(
                                                  child: CustomComponents.displayText(
                                                      selectedCarItem.longDescription,
                                                      textAlign: TextAlign.justify,
                                                      fontSize: 10
                                                  ),
                                                ),
                                              )
                                            ]))
                                      ]),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    //  renting process button
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15, right: 15, top: 20),
                      child: CustomComponents.displayElevatedButton(
                          ProjectStrings.si_proceed_tp_renting_process,
                          onPressed: () {
                            if (selectedCarItem.availability != "available") {
                              InfoDialog().show(context: context, content: "The selected car unit is currently unavailable. Please check back later. Thank you for your understanding.", header: "Warning");
                            } else if (PersistentData().userInfo?.status.toLowerCase() != "verified" || PersistentData().userInfo!.number.toString().isEmpty) {
                              InfoDialog().show(
                                  context: context,
                                  content: "Your account is currently unverified. To proceed with renting a car, please complete the verification process or, if you have already submitted your documents, kindly wait until your account is verified.",
                                  header: "Account Verification Required"
                              );
                            }
                            else {
                              _showInformationDialog(context);
                            }
                          }),
                    ),

                    const SizedBox(height: 100)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResponsiveUI(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnSpacing = screenWidth * 0.1; // 8% of the screen width for spacing

    return Column(
      children: [
        const SizedBox(height: 30),
        // First Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_color.png",
              ProjectStrings.si_color_title,
              selectedCarItem.color,
            ),
            SizedBox(width: columnSpacing),
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_transmission.png",
              ProjectStrings.si_transmission_title,
              selectedCarItem.transmission,
            ),
            SizedBox(width: columnSpacing),
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_fuel.png",
              ProjectStrings.si_fuel_title,
              selectedCarItem.fuelVariant,
            ),
          ],
        ),

        const SizedBox(height: 30),
        // Second Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_horsepower.png",
              ProjectStrings.si_horsepower_title,
              selectedCarItem.horsePower,
            ),
            SizedBox(width: columnSpacing),
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_seats.png",
              ProjectStrings.si_seats_title,
              "${selectedCarItem.capacity} seats",
            ),
            SizedBox(width: columnSpacing),
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_engine.png",
              ProjectStrings.si_engine_title,
              selectedCarItem.engine,
            ),
          ],
        ),

        const SizedBox(height: 30),
        // Third Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_fuel_capacity.png",
              "Fuel Capacity",
              selectedCarItem.fuel,
            ),
            SizedBox(width: columnSpacing),
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_mileage.png",
              "Mileage",
              selectedCarItem.mileage,
            ),
            SizedBox(width: columnSpacing),
            buildFeatureColumn(
              context,
              "lib/assets/pictures/si_rent_count.png",
              "Rent Count",
              selectedCarItem.rentCount,
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

// Helper function to build each feature column
  Widget buildFeatureColumn(BuildContext context, String imagePath, String title, String value) {
    final iconSize = MediaQuery.of(context).size.width * 0.08; // Icon size relative to screen width

    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: iconSize,
          ),
          const SizedBox(height: 10),
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          CustomComponents.displayText(
            value,
            textAlign: TextAlign.center,
            fontSize: 10,
          ),
        ],
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
            "Unit Preview",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
