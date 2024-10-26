import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/account/register_model.dart";
import "../../../../../model/renting_proccess/renting_process.dart";
import "../../../../../services/firebase/firestore.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/loading.dart";
import "../../../../shared/strings.dart";

class RentLogs extends StatefulWidget {
  const RentLogs({super.key});

  @override
  State<RentLogs> createState() => _RentLogsState();
}

class _RentLogsState extends State<RentLogs> {
  int _currentSelectedIndex = 0;
  List<RentInformation> approvedRents = [];
  List<RentInformation> deniedRents = [];
  List<RentInformation> historyRents = [];
  List<RentInformation> allRents = [];
  List<RentInformation> listToBeDisplayed = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  // This map will hold user info for quick access
  Map<String, RegisterModel> userInfoCache = {};

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _retrieveRentRecords();
    });

    // Listen for changes in the search controller
    _searchController.addListener(() {
      _searchUserList(_searchController.text);
    });
  }

  Future<void> _refreshPage() async {
    await _retrieveRentRecords();
  }

  void _searchUserList(String query) {
    final filteredList = allRents.where((rent) {
      final carName = rent.carName.toLowerCase();
      final deliveryMode = rent.pickupOrDelivery.toLowerCase();
      final startDate = rent.startDateTime.toLowerCase();
      final endDate = rent.endDateTime.toLowerCase();
      final remainingDays = calculateDateDifference(rent.startDateTime, rent.endDateTime).toLowerCase();
      final searchQuery = query.toLowerCase();

      return carName.contains(searchQuery) ||
          deliveryMode.contains(searchQuery) ||
          startDate.contains(searchQuery) ||
          endDate.contains(searchQuery) ||
          remainingDays.contains(searchQuery);
    }).toList();

    setState(() {
      listToBeDisplayed = filteredList;
    });
  }

  Future<void> _retrieveRentRecords() async {
    try {
      LoadingDialog().show(
        context: context,
        content: "Retrieving rent inquiries. Please wait a moment.",
      );
      approvedRents.clear();
      deniedRents.clear();
      historyRents.clear();
      allRents.clear();

      allRents = await Firestore().getRentRecords();
      await _retrieveUserInfo(allRents); // Fetch user info after getting rent records

      for (var item in allRents) {
        if (item.rentStatus.toLowerCase() == "approved" || item.rentStatus.toLowerCase() == "denied") {
          if (isDateInPast(item.endDateTime)) {
            setState(() {
              historyRents.add(item);
              _isLoading = false;
            });
          } else if (item.rentStatus.toLowerCase() == "approved") {
            setState(() {
              approvedRents.add(item);
              _isLoading = false;
            });
          } else if (item.rentStatus.toLowerCase() == "denied") {
            setState(() {
              deniedRents.add(item);
              _isLoading = false;
            });
          }
        }
      }
      _updateListToBeDisplayed();
      LoadingDialog().dismiss();
    } catch (e) {
      if (mounted) {
        LoadingDialog().dismiss();
        InfoDialog().show(
          context: context,
          content: "Something went wrong: $e",
          header: "Warning",
        );
      }
      debugPrint("Error@inquiries.dart@ln45: $e");
    }
  }

  Future<void> _retrieveUserInfo(List<RentInformation> rentRecords) async {
    for (var rent in rentRecords) {
      if (!userInfoCache.containsKey(rent.renterUID)) {
        RegisterModel? userInfo = await Firestore().getUserInfo(rent.renterUID);
        userInfoCache[rent.renterUID] = userInfo!;
      }
    }
  }

  void _updateListToBeDisplayed() {
    setState(() {
      if (_currentSelectedIndex == 0) {
        listToBeDisplayed = approvedRents;
      } else if (_currentSelectedIndex == 1) {
        listToBeDisplayed = historyRents;
      } else if (_currentSelectedIndex == 2) {
        listToBeDisplayed = deniedRents;
      }
    });
  }

  bool isDateInPast(String dateStr) {
    DateFormat format = DateFormat("MMMM d, yyyy | hh:mm a");
    DateTime parsedDate = format.parse(dateStr);
    return parsedDate.isBefore(DateTime.now());
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
                  child: CustomComponents.displayText("Review Rental History",
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      "Track all approved and declined rental requests", fontSize: 10),
                ),
              ),
              const SizedBox(height: 15),
              switchOption(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _searchAndFilterBar(),
              ),
              const SizedBox(height: 15),
              _userListItems(),
              const SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }

  Widget _userListItems() {
    return Expanded(
      child: _isLoading
          ? Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
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
        ),
      )
          : RefreshIndicator(
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        onRefresh: () async {
          await _refreshPage();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: listToBeDisplayed.length,
          itemBuilder: (context, index) {
            RentInformation currentItem = listToBeDisplayed[index];
            RegisterModel currentUser = userInfoCache[currentItem.renterUID]!; // Use the cached user info

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _designPerItem(
                carName: currentItem.carName,
                rentDateRange: "${currentItem.startDateTime} - ${currentItem.endDateTime}",
                renterName: "${currentUser.firstName} ${currentUser.lastName}",
                remainingDays: "${calculateDateDifference(currentItem.startDateTime, currentItem.endDateTime)}",
                deliveryOrPickup: CustomComponents.capitalizeFirstLetter(currentItem.pickupOrDelivery),
                status: "Unpaid",
              ),
            );
          },
        ),
      ),
    );
  }

  String calculateDateDifference(String startDateTime, String endDateTime) {
    DateFormat format = DateFormat("MMMM dd, yyyy | hh:mm a");
    DateTime startDate = format.parse(startDateTime);
    DateTime endDate = format.parse(endDateTime);
    DateTime currentDateTime = DateTime.now();

    if (startDate.isAfter(currentDateTime)) {
      return "Not yet started";
    } else {
      Duration difference = endDate.difference(currentDateTime);
      int days = difference.inDays;
      int hours = difference.inHours.remainder(24);
      int minutes = difference.inMinutes.remainder(60);
      return "$days days, $hours hours remaining";
    }
  }

  Widget _designPerItem({
    required String carName,
    required String rentDateRange,
    required String renterName,
    required String remainingDays,
    required String deliveryOrPickup,
    required String status
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Constrain Column height
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      "lib/assets/pictures/user_info_user.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2 + 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomComponents.displayText(
                            carName,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 10),
                          CustomComponents.displayText(
                              rentDateRange,
                              fontSize: 10,
                              color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                              fontWeight: FontWeight.bold
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomComponents.displayText(
                                "Remaining days: ",
                                fontSize: 10,
                              ),
                              Expanded(
                                child: CustomComponents.displayText(
                                  remainingDays,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomComponents.displayText(
                                "Delivery mode: ",
                                fontSize: 10,
                              ),
                              CustomComponents.displayText(
                                deliveryOrPickup,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // PersistentData().selectedUser = selectedUserInformation;
                      // Navigator.of(context).pushNamed("manage_user_list_info");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "lib/assets/pictures/see_more.png",
                          width: 22,
                        ),
                        CustomComponents.displayText(
                          "",
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // status
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: status.toLowerCase() == "paid" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16)) : Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            status.toLowerCase() == "paid" ? "lib/assets/pictures/rentals_verified.png" : "lib/assets/pictures/rentals_denied.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 25,
                            left: 5,
                          ),
                          child: CustomComponents.displayText(
                            CustomComponents.capitalizeFirstLetter(status),
                            color: status.toLowerCase() == "paid" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)) : Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // User type
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
                      child: CustomComponents.displayText(
                        "See more",
                        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
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
  }

  Widget switchOption() {
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
        _currentSelectedIndex = index;
        _updateListToBeDisplayed();
      },
      children: [
        CustomComponents.displayText(
          "Approved",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "History",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Denied",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
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
                  hintText: "Search by car name, date, remaining days, or delivery mode",
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
            "Rent Logs",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}











