import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class UnitPreview extends StatefulWidget {
  const UnitPreview({super.key});

  @override
  State<UnitPreview> createState() => _UnitPreviewState();
}

class _UnitPreviewState extends State<UnitPreview> {
  //  information dialog metadata
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

  void _showInformationDialog() {
    showDialog(
      context: context,
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
                                Navigator.of(context).pushNamed("rp_booking_details");
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

  Future<void> _showSelectedImageDialog() async {
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
                Image.asset("lib/assets/pictures/unit_preview_main_image.jpg"),
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
                      "Unit Preview",
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

              //  top image
              Stack(
                children: [
                  SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: Image.asset(
                        "lib/assets/pictures/unit_preview_main_image.jpg",
                        fit: BoxFit.fitHeight,
                      )),

                  //  expand button
                  GestureDetector(
                    onTap: () {
                      _showSelectedImageDialog();
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
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 3, top: 3, bottom: 3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.asset(
                                    "lib/assets/pictures/unit_preview_main_image.jpg",
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),

                            //  second image preview
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 3, top: 3, bottom: 3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.asset(
                                    "lib/assets/pictures/unit_preview_main_image.jpg",
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),

                            //  third image preview
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 3, top: 3, bottom: 3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.asset(
                                    "lib/assets/pictures/unit_preview_main_image.jpg",
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),

                            //  fourth image preview
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 3, top: 3, bottom: 3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.asset(
                                    "lib/assets/pictures/unit_preview_main_image.jpg",
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),

                            //  fifth image preview
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 3, top: 3, bottom: 3),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image.asset(
                                    "lib/assets/pictures/unit_preview_main_image.jpg",
                                    width: 42,
                                    height: 42,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )),
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
                      height: 420,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(int.parse(
                                              ProjectColors
                                                  .reportMainColorBackground
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
                                            ProjectStrings.report_car_rent,
                                            color: Color(int.parse(
                                                ProjectColors.mainColorHex
                                                    .substring(2),
                                                radix: 16)),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(int.parse(
                                              ProjectColors
                                                  .greenButtonBackground
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
                                            ProjectStrings.si_available,
                                            color: Color(int.parse(
                                                ProjectColors.greenButtonMain
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          "lib/assets/pictures/star.png",
                                          width: 20),
                                      const SizedBox(width: 10),
                                      CustomComponents.displayText(
                                          ProjectStrings.report_reviews,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomComponents.displayText(
                                ProjectStrings.si_unit_name,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            CustomComponents.displayText(
                                ProjectStrings.si_unit_description,
                                fontSize: 10),
                            Expanded(
                              // This is the main change
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
                                      Column(
                                        children: [
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //  color
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/pictures/si_color.png",
                                                      width: 30),
                                                  const SizedBox(height: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_color_title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings.si_color,
                                                      fontSize: 10),
                                                ],
                                              ),
                                              //  transmission
                                              const SizedBox(width: 60),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/pictures/si_transmission.png",
                                                      width: 30),
                                                  const SizedBox(height: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_transmission_title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_transmission,
                                                      fontSize: 10),
                                                ],
                                              ),
                                              const SizedBox(width: 60),
                                              //  fuel
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/pictures/si_fuel.png",
                                                      width: 30),
                                                  const SizedBox(height: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_fuel_title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings.si_fuel,
                                                      fontSize: 10),
                                                ],
                                              ),
                                            ],
                                          ),

                                          //  second row
                                          const SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //  color
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/pictures/si_horsepower.png",
                                                      width: 30),
                                                  const SizedBox(height: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_horsepower_title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_horsepower,
                                                      fontSize: 10),
                                                ],
                                              ),
                                              //  transmission
                                              const SizedBox(width: 60),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/pictures/si_seats.png",
                                                      width: 30),
                                                  const SizedBox(height: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_seats_title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings.si_seats,
                                                      fontSize: 10),
                                                ],
                                              ),
                                              const SizedBox(width: 60),
                                              //  engine
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/pictures/si_engine.png",
                                                      width: 30),
                                                  const SizedBox(height: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings
                                                          .si_engine_title,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10),
                                                  CustomComponents.displayText(
                                                      ProjectStrings.si_engine,
                                                      fontSize: 10),
                                                ],
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20)
                                        ],
                                      ),
                                      //  second tab item
                                      Container(
                                          child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15, top: 15),
                                          child: CustomComponents.displayText(
                                              ProjectStrings.si_about_title,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: CustomComponents.displayText(
                                              ProjectStrings.si_about_body,
                                              textAlign: TextAlign.justify,
                                              fontSize: 10),
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
                      _showInformationDialog();
                    }),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
