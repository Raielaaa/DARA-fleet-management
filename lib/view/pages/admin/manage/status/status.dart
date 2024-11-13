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
import "edit_car_status.dart";

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
                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                  onRefresh: () async {
                    refresh();
                  },
                  child: ListView(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                    children: [Column(
                      children: [
                        // Available car units
                        carUnitsContainer(
                          title: 'Car Units',
                          statusText: 'Available',
                          backgroundColor: Color(int.parse(ProjectColors.greenButtonBackground)),
                          statusTextColor: Color(int.parse(ProjectColors.greenButtonMain)),
                          carData: _datsAvailable,
                          onCarSelected: (index) {
                            PersistentData().selectedCarItem = _datsAvailable[index];
                            Navigator.of(context).pushNamed("selected_item");
                          },
                          onStatusChangeSelected: (index) {
                            debugPrint("show-clicked");
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                ),
                                builder: (BuildContext context) {
                                  return EditCarStatusBottomSheet(completeCarInfo: _datsAvailable[index], parentContext: context,);
                                }
                            );
                          }
                        ),

                        // Unavailable car units
                        const SizedBox(height: 20),
                        carUnitsContainer(
                          title: 'Car Units',
                          statusText: 'Unavailable',
                          backgroundColor: Color(int.parse(ProjectColors.redButtonBackground)),
                          statusTextColor: Color(int.parse(ProjectColors.redButtonMain)),
                          carData: _datsUnavailable,
                          onCarSelected: (index) {
                            PersistentData().selectedCarItem = _datsUnavailable[index];
                            Navigator.of(context).pushNamed("selected_item");
                          },
                          onStatusChangeSelected: (index) {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                ),
                                builder: (BuildContext context) {
                                  return EditCarStatusBottomSheet(completeCarInfo: _datsUnavailable[index], parentContext: context,);
                                }
                            );
                          }
                        ),

                        // outsourced units
                        // Available car units
                        const SizedBox(height: 20),
                        carUnitsContainer(
                            title: 'Outsourced Units',
                            statusText: 'Available',
                            backgroundColor: Color(int.parse(ProjectColors.greenButtonBackground)),
                            statusTextColor: Color(int.parse(ProjectColors.greenButtonMain)),
                            carData: _outsourceAvailable,
                            onCarSelected: (index) {
                              PersistentData().selectedCarItem = _outsourceAvailable[index];
                              Navigator.of(context).pushNamed("selected_item");
                            },
                            onStatusChangeSelected: (index) {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return EditCarStatusBottomSheet(completeCarInfo: _outsourceAvailable[index], parentContext: context,);
                                  }
                              );
                            }
                        ),

                        // Unavailable car units
                        const SizedBox(height: 20),
                        carUnitsContainer(
                            title: 'Outsourced Units',
                            statusText: 'Unavailable',
                            backgroundColor: Color(int.parse(ProjectColors.redButtonBackground)),
                            statusTextColor: Color(int.parse(ProjectColors.redButtonMain)),
                            carData: _outsourceUnavailable,
                            onCarSelected: (index) {
                              PersistentData().selectedCarItem = _outsourceUnavailable[index];
                              Navigator.of(context).pushNamed("selected_item");
                            },
                            onStatusChangeSelected: (index) {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return EditCarStatusBottomSheet(completeCarInfo: _outsourceUnavailable[index], parentContext: context,);
                                  }
                              );
                            }
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

  Widget carUnitsContainer({
    required String title,
    required String statusText,
    required Color backgroundColor,
    required Color statusTextColor,
    required List<dynamic> carData,
    required ValueChanged<int> onCarSelected,
    required Function(int) onStatusChangeSelected
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: ProjectStrings.general_font_family),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: backgroundColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "${carData.length} / ${
                  carData == _datsAvailable || carData == _datsUnavailable ? "${_datsAvailable.length + _datsUnavailable.length}" : "${_outsourceAvailable.length + _outsourceUnavailable.length}"
                  }", // Display available/unavailable count as needed
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, fontFamily: ProjectStrings.general_font_family),
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFBDBDBD),
            height: 1,
          ),
          const SizedBox(height: 10),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: carData.length,
            itemBuilder: (BuildContext context, int index) {
              final carItem = carData[index];
              return GestureDetector(
                onTap: () => onCarSelected(index),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: kElevationToShadow[2],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    width: double.infinity,
                    height: 90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(7),
                              bottomLeft: Radius.circular(7)),
                          child: Image.network(
                            FirebaseConstants.retrieveImage(carItem.pic1Url),
                            width: 100,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  carItem.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: ProjectStrings.general_font_family),
                                ),
                                Text(
                                  carItem.carType,
                                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: ProjectStrings.general_font_family),
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  "Total rentals: ${carItem.rentCount}",
                                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: ProjectStrings.general_font_family),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10, right: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      onStatusChangeSelected(index);
                                    },
                                    child: const Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
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
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
