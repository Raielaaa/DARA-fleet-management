import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";

import "../../../../../controller/singleton/persistent_data.dart";

class CarStatus extends StatefulWidget {
  const CarStatus({super.key});

  @override
  State<CarStatus> createState() => _CarStatusState();
}

class _CarStatusState extends State<CarStatus> {
  List<CompleteCarInfo> _completeCarInfo = [];
  List<CompleteCarInfo> _datsAvailable = [];
  List<CompleteCarInfo> _datsUnavailable = [];
  List<CompleteCarInfo> _outsourceAvailable = [];
  List<CompleteCarInfo> _outsourceUnavailable = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchCarInfo();
    });
  }

  Future<void> refresh() async {
    _datsAvailable.clear();
    _datsUnavailable.clear();
    _outsourceAvailable.clear();
    _outsourceUnavailable.clear();
    _fetchCarInfo();
  }

  Future<void> _fetchCarInfo() async {
    try {
      // Show loading dialog
      LoadingDialog().show(context: context, content: "Please wait while we retrieve complete car info.");

      // Fetch car information from Firestore
      List<CompleteCarInfo> carInfoList = await Firestore().getCompleteCars();

      // Categorize car information based on availability and ownership
      List<CompleteCarInfo> datsAvailable = [];
      List<CompleteCarInfo> outsourceAvailable = [];
      List<CompleteCarInfo> datsUnavailable = [];
      List<CompleteCarInfo> outsourceUnavailable = [];

      for (var car in carInfoList) {
        String availability = car.availability.toLowerCase();
        String owner = car.carOwner.toLowerCase();

        if (availability == "available") {
          if (owner == "dats") {
            datsAvailable.add(car);
          } else if (owner.contains("outsource")) {
            outsourceAvailable.add(car);
          }
        } else {
          if (owner == "dats") {
            datsUnavailable.add(car);
          } else if (owner.contains("outsource")) {
            outsourceUnavailable.add(car);
          }
        }
      }

      // Update state
      setState(() {
        _completeCarInfo = carInfoList;
        _datsAvailable = datsAvailable;
        _outsourceAvailable = outsourceAvailable;
        _datsUnavailable = datsUnavailable;
        _outsourceUnavailable = outsourceUnavailable;
      });
    } catch (e, stackTrace) {
      debugPrint("Error fetching car info: $e");
      debugPrint("StackTrace: $stackTrace");
    } finally {
      // Ensure the loading dialog is dismissed
      LoadingDialog().dismiss();
    }
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
              // AppBar
              Container(
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
                      ProjectStrings.cs_appbar_title,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomComponents.menuButtons(context),
                  ],
                ),
              ),

              // Main body
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    refresh();
                  },
                  child: ListView(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                    children: [Column(
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
                                      "${_datsAvailable.length}/${_datsAvailable.length + _datsUnavailable.length}",
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
                                itemCount: _datsAvailable.length,
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
                                            child: Image.network(
                                              FirebaseConstants.retrieveImage(_datsAvailable[index].pic1Url),
                                              width: 100,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            )
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
                                                      _datsAvailable[index].name,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                  CustomComponents.displayText(
                                                      _datsAvailable[index].carType,
                                                      fontSize: 10,
                                                      color: Color(int.parse(
                                                          ProjectColors
                                                              .lightGray))),
                                                  const SizedBox(height: 25),
                                                  CustomComponents.displayText(
                                                      "Total rentals: ${_datsAvailable[index].rentCount}",
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
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        PersistentData().selectedCarItem = _datsAvailable[index];
                                                        Navigator.of(context).pushNamed("selected_item");
                                                      },
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
                                      "${_datsUnavailable.length}/${_datsUnavailable.length + _datsAvailable.length}",
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
                                itemCount: _datsUnavailable.length,
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
                                            child: Image.network(
                                              FirebaseConstants.retrieveImage(_datsUnavailable[index].pic1Url),
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
                                                      _datsUnavailable[index].name,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                  CustomComponents.displayText(
                                                      _datsUnavailable[index].carType,
                                                      fontSize: 10,
                                                      color: Color(int.parse(
                                                          ProjectColors
                                                              .lightGray))),
                                                  const SizedBox(height: 25),
                                                  CustomComponents.displayText(
                                                      "Total rentals: ${_datsUnavailable[index].rentCount}",
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
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        PersistentData().selectedCarItem = _datsUnavailable[index];
                                                        Navigator.of(context).pushNamed("selected_item");
                                                      },
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
                                      "${_outsourceAvailable.length}/${_outsourceAvailable.length + _outsourceUnavailable.length}",
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
                                itemCount: _outsourceAvailable.length,
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
                                            child: Image.network(
                                              FirebaseConstants.retrieveImage(_outsourceAvailable[index].pic1Url),
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
                                                      _outsourceAvailable[index].name,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                  CustomComponents.displayText(
                                                      _outsourceAvailable[index].carType,
                                                      fontSize: 10,
                                                      color: Color(int.parse(
                                                          ProjectColors
                                                              .lightGray))),
                                                  const SizedBox(height: 25),
                                                  CustomComponents.displayText(
                                                      "Total rentals: ${_outsourceAvailable[index].rentCount}",
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
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        PersistentData().selectedCarItem = _outsourceAvailable[index];
                                                        Navigator.of(context).pushNamed("selected_item");
                                                      },
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
                                      "${_outsourceUnavailable.length}/${_outsourceUnavailable.length + _outsourceAvailable.length}",
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
                                itemCount: _outsourceUnavailable.length,
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
                                            child: Image.network(
                                              FirebaseConstants.retrieveImage(_outsourceUnavailable[index].pic1Url),
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
                                                      _outsourceUnavailable[index].name,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12),
                                                  CustomComponents.displayText(
                                                      _outsourceUnavailable[index].carType,
                                                      fontSize: 10,
                                                      color: Color(int.parse(
                                                          ProjectColors
                                                              .lightGray))),
                                                  const SizedBox(height: 25),
                                                  CustomComponents.displayText(
                                                      "Total rentals: ${_outsourceUnavailable[index].rentCount}",
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
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        PersistentData().selectedCarItem = _outsourceUnavailable[index];
                                                        Navigator.of(context).pushNamed("selected_item");
                                                      },
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
                    )]
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
