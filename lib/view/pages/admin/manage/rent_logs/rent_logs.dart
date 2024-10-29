import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../../controller/rentals/rent_log.dart";
import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/account/register_model.dart";
import "../../../../../model/car_list/complete_car_list.dart";
import "../../../../../model/renting_proccess/renting_process.dart";
import "../../../../../services/firebase/firestore.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/info_dialog.dart";
import "../../../../shared/loading.dart";
import "../../../../shared/strings.dart";
import "edit_rental_info.dart";

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

  Future<void> _seeCompleteBookingInfo(
      RentInformation rentInformation,
      CompleteCarInfo carInformation,
      RegisterModel renterInformation
  ) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SingleChildScrollView( // Added to make content scrollable
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top design
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: Image.asset(
                            "lib/assets/pictures/header_background_curves.png",
                            width: MediaQuery.of(context).size.width - 10,
                            height: 70, // Adjust height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.dialog_title_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              Image.asset(
                                "lib/assets/pictures/app_logo_circle.png",
                                width: 80.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Section 1
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(int.parse(
                                            ProjectColors.mainColorBackground
                                                .substring(2),
                                            radix: 16)),
                                        border: Border.all(
                                            color: Color(int.parse(ProjectColors.lineGray)),
                                            width: 1)),
                                    child: Center(
                                        child: CustomComponents.displayText(
                                            "1",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.dialog_car_info_title,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomComponents.displayText(
                                        ProjectStrings.dialog_car_info,
                                        color: Color(int.parse(
                                            ProjectColors.lightGray.substring(2),
                                            radix: 16)),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(int.parse(
                                ProjectColors.lineGray.substring(2),
                                radix: 16)),
                          ),
                          // Car model and other information
                          buildInfoRow(
                            ProjectStrings.dialog_car_model_title,
                            carInformation.name,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_transmission_title,
                            carInformation.transmission,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_capacity_title,
                            carInformation.capacity,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_fuel_title,
                            carInformation.fuelVariant,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_fuel_capacity_title,
                            carInformation.fuel,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_unit_color_title,
                            carInformation.color,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_engine_title,
                            carInformation.engine,
                            ProjectColors.lightGray,
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Section 2
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(int.parse(
                                            ProjectColors.mainColorBackground
                                                .substring(2),
                                            radix: 16)),
                                        border: Border.all(
                                            color: Color(int.parse(ProjectColors.lineGray)),
                                            width: 1)),
                                    child: Center(
                                        child: CustomComponents.displayText(
                                            "2",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.dialog_title_2,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomComponents.displayText(
                                        ProjectStrings.dialog_title_2_subheader,
                                        color: Color(int.parse(
                                            ProjectColors.lightGray.substring(2),
                                            radix: 16)),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(int.parse(
                                ProjectColors.lineGray.substring(2),
                                radix: 16)),
                          ),
                          // Rent start date and other details
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_rent_start_title,
                            rentInformation.startDateTime,
                            ProjectColors.lightGray,
                            topPadding: 15,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_rent_end_title,
                            rentInformation.endDateTime,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Pickup or Delivery:",
                            rentInformation.pickupOrDelivery,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Delivery Location:",
                            rentInformation.deliveryLocation,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_location_title,
                            rentInformation.rentLocation,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_reserved_title,
                            rentInformation.reservationFee.contains("500") ? "Yes" : "No",
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_admin_notes_title,
                            rentInformation.adminNotes,
                            ProjectColors.lightGray,
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    //  Section 3
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(int.parse(
                                            ProjectColors.mainColorBackground
                                                .substring(2),
                                            radix: 16)),
                                        border: Border.all(
                                            color: Color(int.parse(ProjectColors.lineGray)),
                                            width: 1)),
                                    child: Center(
                                        child: CustomComponents.displayText(
                                            "3",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomComponents.displayText(
                                        "Renter Information",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomComponents.displayText(
                                        "Provides Complete Renter Details",
                                        color: Color(int.parse(
                                            ProjectColors.lightGray.substring(2),
                                            radix: 16)),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(int.parse(
                                ProjectColors.lineGray.substring(2),
                                radix: 16)),
                          ),
                          // Rent start date and other details
                          buildInfoRowSecondPanel(
                            "Full Name:",
                            "${renterInformation.firstName} ${renterInformation.lastName}",
                            ProjectColors.lightGray,
                            topPadding: 15,
                          ),
                          buildInfoRowSecondPanel(
                            "Contact Number:",
                            renterInformation.number,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Email:",
                            renterInformation.email,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Total Spent:",
                            rentInformation.totalAmount,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Birthday:",
                            renterInformation.birthday,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Role:",
                            renterInformation.role,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            "Date Created:",
                            renterInformation.dateCreated,
                            ProjectColors.lightGray,
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Widget buildInfoRowSecondPanel(String title, String value, String titleColor, {double topPadding = 5}) {
    return Padding(
      padding: EdgeInsets.only(right: 15, left: 15, top: topPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title text
          Expanded(
            flex: 1,
            child: CustomComponents.displayText(
              title,
              fontWeight: FontWeight.w500,
              fontSize: 10,
              color: Color(int.parse(titleColor.substring(2), radix: 16)),
            ),
          ),
          // Value text, allowing flexibility and wrapping if needed
          Expanded(
            flex: 3,
            child: CustomComponents.displayText(
              value,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              textAlign: TextAlign.end, // Align the text to the right
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(String title, String value, String titleColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: Color(int.parse(titleColor.substring(2), radix: 16)),
          ),
          CustomComponents.displayText(
            value,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ],
      ),
    );
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
        if (item.rentStatus.toLowerCase() == "approved" || item.rentStatus.toLowerCase() == "denied" || item.rentStatus.toLowerCase() == "declined") {
          if (item.postApproveStatus.toLowerCase() == "completed") {
            setState(() {
              historyRents.add(item);
              _isLoading = false;
            });
          } else if (item.postApproveStatus.toLowerCase() == "ongoing") {
            setState(() {
              approvedRents.add(item);
              _isLoading = false;
            });
          } else if (item.postApproveStatus.toLowerCase() == "cancelled") {
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
                status: CustomComponents.capitalizeFirstLetter(currentItem.paymentStatus),
                completeRentInfo: currentItem,
                postApproveStatus: currentItem.postApproveStatus
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
    required String status,
    required RentInformation completeRentInfo,
    required String postApproveStatus
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
                          completeRentInfo.rentStatus.toLowerCase() ==  "approved" ? Row(
                            children: [
                              CustomComponents.displayText(
                                "Rent status: ",
                                fontSize: 10,
                              ),
                              CustomComponents.displayText(
                                  CustomComponents.capitalizeFirstLetter(postApproveStatus),
                                  fontSize: 10,
                                  color: postApproveStatus.toLowerCase() == "completed" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)) :
                                  postApproveStatus.toLowerCase() == "cancelled" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)) : const Color(0xff404040)
                              ),
                            ],
                          ) : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        builder: (BuildContext context) {
                          return EditRentalInfoBottomSheet(completeRentInfo: completeRentInfo, parentContext: context,);
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Icon(
                          Icons.edit_note,
                          size: 25,
                          color: Color(int.parse("0xff7a7b7e")),
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
                  GestureDetector(
                    onTap: () async {
                      LoadingDialog().show(context: context, content: "Please wait while retrieve your rent information");
                      final List<RentInformation> retrievedRentingData = await RentLog().getSelectedRentRecords(startDate: completeRentInfo.startDateTime, endDate: completeRentInfo.endDateTime, location: completeRentInfo.rentLocation);
                      final CompleteCarInfo selectedCarCompleteInfo = await RentLog().getSelectedCarCompleteInfo(carName: carName);
                      final RegisterModel? userInfo = await Firestore().getUserInfo(completeRentInfo.renterUID);
                      LoadingDialog().dismiss();

                      _seeCompleteBookingInfo(retrievedRentingData[0], selectedCarCompleteInfo, userInfo!);
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future showEditBottomSheet(BuildContext parentContext, RentInformation completeRentInfo) {
  //   // Reset the selected indices to ensure the correct state is reflected every time the bottom sheet is shown
  //   _currentSelectedIndexPaymentStatus = completeRentInfo.paymentStatus == "paid" ? 0 : 1;
  //   _currentSelectedIndexRentStatus = completeRentInfo.postApproveStatus == "ongoing" ? 0 : completeRentInfo.postApproveStatus == "completed" ? 1 : 2;
  //
  //   selectedItemForEditPaymentStatus = completeRentInfo.paymentStatus;
  //   selectedItemForEditRentStatus = completeRentInfo.postApproveStatus;
  //
  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
  //     ),
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.55,
  //         widthFactor: 1,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
  //           child: ListView(
  //             children: [
  //               UnconstrainedBox(
  //                 child: Container(
  //                   width: 50,
  //                   height: 7,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey,
  //                     borderRadius: BorderRadius.circular(50),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 30),
  //               CustomComponents.displayText("Edit Rental Information", fontWeight: FontWeight.bold),
  //               const SizedBox(height: 5),
  //               CustomComponents.displayText("Update payment status and rental progress", fontSize: 10),
  //               const SizedBox(height: 30),
  //               CustomComponents.displayText("Payment Status", fontWeight: FontWeight.bold, fontSize: 10),
  //               const SizedBox(height: 10),
  //               switchOptionPaymentStatus(completeRentInfo), // Call without parameters now
  //               const SizedBox(height: 15),
  //               CustomComponents.displayText("Rent Status", fontWeight: FontWeight.bold, fontSize: 10),
  //               const SizedBox(height: 10),
  //               switchOptionRentStatus(completeRentInfo), // Call without parameters now
  //               const SizedBox(height: 50),
  //               saveCancelButtons(completeRentInfo, parentContext),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // int? _currentSelectedIndexPaymentStatus;
  // int? _currentSelectedIndexRentStatus;
  // String selectedItemForEditPaymentStatus = "";
  // String selectedItemForEditRentStatus = "";
  //
  // // Payment Status Switcher
  // // Payment Status Switcher
  // Widget switchOptionPaymentStatus(RentInformation completeRentInfo) {
  //   // Set the initial index based on the completeRentInfo
  //   _currentSelectedIndexPaymentStatus = completeRentInfo.paymentStatus == "paid" ? 0 : 1;
  //
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _currentSelectedIndexPaymentStatus = 0;
  //             selectedItemForEditPaymentStatus = "paid";
  //             debugPrint("Payment Status updated to: $selectedItemForEditPaymentStatus");
  //           });
  //         },
  //         child: Container(
  //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //           decoration: BoxDecoration(
  //             color: _currentSelectedIndexPaymentStatus == 0 ? Color(int.parse(ProjectColors.mainColorHex)) : Colors.white,
  //             borderRadius: BorderRadius.circular(7),
  //             border: Border.all(color: Color(int.parse(ProjectColors.mainColorHex)), width: 2),
  //           ),
  //           child: CustomComponents.displayText(
  //             "Paid",
  //             color: _currentSelectedIndexPaymentStatus == 0 ? Colors.white : Color(int.parse(ProjectColors.mainColorHex)),
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             _currentSelectedIndexPaymentStatus = 1;
  //             selectedItemForEditPaymentStatus = "unpaid";
  //             debugPrint("Payment Status updated to: $selectedItemForEditPaymentStatus");
  //           });
  //         },
  //         child: Container(
  //           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //           decoration: BoxDecoration(
  //             color: _currentSelectedIndexPaymentStatus == 1 ? Color(int.parse(ProjectColors.mainColorHex)) : Colors.white,
  //             borderRadius: BorderRadius.circular(7),
  //             border: Border.all(color: Color(int.parse(ProjectColors.mainColorHex)), width: 2),
  //           ),
  //           child: CustomComponents.displayText(
  //             "Unpaid",
  //             color: _currentSelectedIndexPaymentStatus == 1 ? Colors.white : Color(int.parse(ProjectColors.mainColorHex)),
  //             fontSize: 12,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  //
  //
  // // Rent Status Switcher
  // Widget switchOptionRentStatus(RentInformation completeRentInfo) {
  //   if (_currentSelectedIndexRentStatus == null) {
  //     _currentSelectedIndexRentStatus = completeRentInfo.postApproveStatus == "ongoing" ? 0
  //         : completeRentInfo.postApproveStatus == "completed" ? 1 : 2;
  //     selectedItemForEditRentStatus = completeRentInfo.postApproveStatus;
  //   }
  //
  //   return SlideSwitcher(
  //     indents: 3,
  //     containerColor: Colors.white,
  //     containerBorderRadius: 7,
  //     slidersColors: [
  //       Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16)),
  //     ],
  //     containerHeight: 50,
  //     containerWight: MediaQuery.of(context).size.width - 50,
  //     initialIndex: _currentSelectedIndexRentStatus ?? 0,
  //     onSelect: (index) {
  //       setState(() {
  //         _currentSelectedIndexRentStatus = index;
  //         selectedItemForEditRentStatus = (index == 0) ? "ongoing" : (index == 1) ? "completed" : "cancelled";
  //       });
  //     },
  //     children: [
  //       CustomComponents.displayText(
  //         "Ongoing",
  //         color: Color(int.parse(ProjectColors.mainColorHex)),
  //         fontSize: 12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       CustomComponents.displayText(
  //         "Completed",
  //         color: Color(int.parse(ProjectColors.mainColorHex)),
  //         fontSize: 12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //       CustomComponents.displayText(
  //         "Cancelled",
  //         color: Color(int.parse(ProjectColors.mainColorHex)),
  //         fontSize: 12,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ],
  //   );
  // }
  //
  //
  // // Save and Cancel Button
  // Widget saveCancelButtons(RentInformation completeRentInfo, BuildContext parentContext) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       GestureDetector(
  //         onTap: () {
  //           InfoDialog().showDecoratedTwoOptionsDialog(
  //             context: parentContext,
  //             content: ProjectStrings.edit_user_info_dialog_content,
  //             header: ProjectStrings.edit_user_info_dialog_header,
  //             confirmAction: () async {
  //               await Firestore().updateRentStatusRentLogs(
  //                 carUID: completeRentInfo.rent_car_UID,
  //                 estimatedDrivingDistance: completeRentInfo.estimatedDrivingDistance,
  //                 startDateTime: completeRentInfo.startDateTime,
  //                 endDateTime: completeRentInfo.endDateTime,
  //                 newPaymentStatus: selectedItemForEditPaymentStatus,
  //                 newPostApproveStatus: selectedItemForEditRentStatus
  //               );
  //               Navigator.of(parentContext).pop();
  //             },
  //           );
  //         },
  //         child: Container(
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(5),
  //               color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
  //             child: CustomComponents.displayText(
  //                 "Save",
  //                 color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 12
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
          "Ongoing",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Completed",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Cancelled",
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











