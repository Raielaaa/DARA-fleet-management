import "package:dara_app/controller/rentals/rent_log.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../model/renting_proccess/renting_process.dart";
import "../../../../services/firebase/firestore.dart";

class Rentals extends StatefulWidget {
  const Rentals({super.key});

  @override
  State<Rentals> createState() => _Rentals();
}

class _Rentals extends State<Rentals> {
  List<RentInformation> _rentRecords = [];
  List<RentInformation> itemsToBeDisplayed = [];
  List<RentInformation> _rentRecordsHistory = [];
  List<RentInformation> _rentRecordsOnGoing = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    debugPrint("Init state: checker-1");
    _rentRecords.clear();
    _rentRecordsHistory.clear();
    _rentRecordsOnGoing.clear();
    _isLoading = true; // Reset the loading state
    debugPrint("Init state: checker-2");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint("Init state: checker-2.5: $_isLoading");
      await _fetchRentRecords();
      debugPrint("Init state: checker-3");
      debugPrint("Init state: checker-4: $_isLoading");
    });
  }
  Future<void> _fetchRentRecords() async {
    // Fetch the rent records information asynchronously
    LoadingDialog().show(context: context, content: "Please wait while we retrieve your rent information");
    _rentRecords = await Firestore().getRentRecordsInfo(FirebaseAuth.instance.currentUser!.uid);
    LoadingDialog().dismiss();

    for (RentInformation listItem in _rentRecords) {
      if (RentLog().calculateDateDifference(listItem.endDateTime, RentLog().getCurrentFormattedDateTime()) > 0) {
        _rentRecordsHistory.add(listItem);
      } else {
        _rentRecordsOnGoing.add(listItem);
      }
    }
    // Update the UI after data is fetched
    setState(() {
      // Set the fetched data
      _rentRecordsOnGoing = _rentRecordsOnGoing;
      _rentRecordsHistory = _rentRecordsHistory;
      itemsToBeDisplayed = _rentRecordsOnGoing;
      _rentRecords = _rentRecords;
      _isLoading = false;
    });
    _isLoading = false;
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


  Future<void> _seeCompleteBookingInfo(RentInformation rentInformation, CompleteCarInfo carInformation, BuildContext parentContext) async {
    // LoadingDialog().show(context: context, content: "Please wait while we retrieve your rent information.");

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
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  top design
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
                        padding:
                            const EdgeInsets.only(right: 15, left: 15, top: 12),
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
                  Container(
                      color: Colors.white,
                      height: 250,
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
                                              color: Color(int.parse(
                                                  ProjectColors.lineGray)),
                                              width: 1)),
                                      child: Center(
                                          child: CustomComponents.displayText(
                                              "1",
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ),
                                const SizedBox(
                                    width:
                                        20.0), // Optional: Add spacing between the Text and the Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            ProjectColors.lightGray
                                                .substring(2),
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
                          //  car model
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
                      )),
                  const SizedBox(height: 20),
                  Container(
                      color: Colors.white,
                      height: 250,
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
                                              color: Color(int.parse(
                                                  ProjectColors.lineGray)),
                                              width: 1)),
                                      child: Center(
                                          child: CustomComponents.displayText(
                                              "2",
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ),
                                const SizedBox(
                                    width:
                                        20.0), // Optional: Add spacing between the Text and the Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            ProjectColors.lightGray
                                                .substring(2),
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
                          //  rent start date
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
                      )),
                  const SizedBox(height: 20),
                  UnconstrainedBox(
                    child: Row(
                      children: [
                        //  report
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(parentContext, "to_report");
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(int.parse(
                                    ProjectColors.redButtonBackground
                                        .substring(2),
                                    radix: 16)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      "lib/assets/pictures/rentals_denied.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10, right: 25, left: 5),
                                    child: CustomComponents.displayText(
                                      ProjectStrings.dialog_report_button,
                                      color: Color(int.parse(
                                          ProjectColors.redButtonMain
                                              .substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )),
                        ),

                        //  approved
                        const SizedBox(width: 20),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: rentInformation.rentStatus.toLowerCase() == "approved" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16)) :
                                     rentInformation.rentStatus.toLowerCase() == "pending" ? Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)) :
                                     rentInformation.rentStatus.toLowerCase() == "denied" ? Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)) : Colors.white
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                    rentInformation.rentStatus.toLowerCase() == "approved" ? "lib/assets/pictures/rentals_verified.png" :
                                    rentInformation.rentStatus.toLowerCase() == "pending" ? "lib/assets/pictures/rentals_pending.png" :
                                    rentInformation.rentStatus.toLowerCase() == "denied" ? "lib/assets/pictures/rentals_denied.png" : "lib/assets/pictures/rentals_denied.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 25, left: 5),
                                  child: CustomComponents.displayText(
                                    CustomComponents.capitalizeFirstLetter(rentInformation.rentStatus),
                                    color: rentInformation.rentStatus.toLowerCase() == "approved" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)) :
                                    rentInformation.rentStatus.toLowerCase() == "pending" ? Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)) :
                                    rentInformation.rentStatus.toLowerCase() == "denied" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)) : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            )
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCarListItem({
    required String imagePath,
    required String carName,
    required String carRentLocation,
    required String carStartEndDate,
    required String startDate,
    required String endDate,
    required String totalAmount,
    required String rentStatus,
    required BuildContext parentContext
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Builder(
                      builder: (context) {
                        // Try to retrieve the image using different file extensions
                        String? imageUrl;

                        imageUrl = FirebaseConstants.retrieveImage("car_images/${imagePath}_main_pic.png");
                        if (imageUrl == null) {
                          imageUrl = FirebaseConstants.retrieveImage("car_images/${imagePath}_main_pic.jpg");
                        }
                        if (imageUrl == null) {
                          imageUrl = FirebaseConstants.retrieveImage("car_images/${imagePath}_main_pic.jpeg");
                        }

                        // Use the retrieved image URL or provide a default image if none are found
                        return Image.network(
                          imageUrl, // Provide a default image path if no images were found
                          width: 100,
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomComponents.displayText(
                            carName,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 10),
                        CustomComponents.displayText(
                            "Location: ",
                            fontSize: 10, fontWeight: FontWeight.bold),
                        Text(
                          carRentLocation,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily: ProjectStrings.general_font_family,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        CustomComponents.displayText(
                            "Date: ",
                            fontSize: 10, fontWeight: FontWeight.bold),
                        Text(
                          carStartEndDate,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontFamily: ProjectStrings.general_font_family,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () async {
                            LoadingDialog().show(context: context, content: "Please wait while retrieve your rent information");
                            final List<RentInformation> retrievedRentingData = await RentLog().getSelectedRentRecords(startDate: startDate, endDate: endDate, location: carRentLocation);
                            final CompleteCarInfo selectedCarCompleteInfo = await RentLog().getSelectedCarCompleteInfo(carName: carName);
                            LoadingDialog().dismiss();

                            _seeCompleteBookingInfo(retrievedRentingData[0], selectedCarCompleteInfo, parentContext);
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 40),
                                  CustomComponents.displayText(
                                    ProjectStrings.rentals_see_booking_info,
                                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                  const SizedBox(width: 5),
                                  Image.asset("lib/assets/pictures/right_arrow.png", width: 10),
                                ],
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomComponents.displayText(
                    totalAmount,
                    color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: rentStatus.toLowerCase() == "approved" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16)) :
                          rentStatus.toLowerCase() == "pending" ? Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)) :
                          rentStatus.toLowerCase() == "denied" ? Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)) : Colors.white
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            rentStatus.toLowerCase() == "approved" ? "lib/assets/pictures/rentals_verified.png" :
                            rentStatus.toLowerCase() == "pending" ? "lib/assets/pictures/rentals_pending.png" :
                            rentStatus.toLowerCase() == "denied" ? "lib/assets/pictures/rentals_denied.png" : "lib/assets/pictures/rentals_denied.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 25, left: 5),
                          child: CustomComponents.displayText(
                            CustomComponents.capitalizeFirstLetter(rentStatus),

                            color: rentStatus.toLowerCase() == "approved" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)) :
                              rentStatus.toLowerCase() == "pending" ? Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)) :
                              rentStatus.toLowerCase() == "denied" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)) : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _actionBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              PersistentData().openDrawer(2);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
          ),
          CustomComponents.displayText(
            "Rent Profile",
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    _rentRecords.clear();
    _rentRecordsHistory.clear();
    _rentRecordsOnGoing.clear();
    _fetchRentRecords();
    CustomComponents.showToastMessage("Page refreshed", Colors.black54, Colors.white);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      body: _isLoading ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              //  ActionBar
              _actionBar(),

              //  Header
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "lib/assets/pictures/app_logo_circle.png",
                      width: 120.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(int.parse(
                            ProjectColors.mainColorHex.substring(2),
                            radix: 16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 30, left: 30),
                        child: CustomComponents.displayText(
                          PersistentData().userType,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomComponents.displayText(
                            "Hello, ${PersistentData().userInfo!.role}",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomComponents.displayText(
                            "PH ${PersistentData().userInfo!.number.isNotEmpty ? PersistentData().userInfo?.number : "- click here to verify"}",
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                          ),
                          const SizedBox(height: 10),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: PersistentData().userInfo!.number.isNotEmpty ? Color(int.parse(
                                    ProjectColors.lightGreen.substring(2),
                                    radix: 16)) : Color(int.parse(
                                    ProjectColors.redButtonBackground.substring(2),
                                    radix: 16)
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      PersistentData().userInfo!.number.isNotEmpty ? "lib/assets/pictures/rentals_verified.png" : "lib/assets/pictures/rentals_denied.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 25,
                                        left: 5),
                                    child: CustomComponents.displayText(
                                      PersistentData().userInfo?.number.isNotEmpty == true ? ProjectStrings
                                          .rentals_header_verified_button : "Unverified",
                                      color: PersistentData().userInfo!.number.isNotEmpty ? Color(int.parse(
                                          ProjectColors.greenButtonMain.substring(2),
                                          radix: 16)) : Color(int.parse(
                                          ProjectColors.redButtonMain.substring(2),
                                          radix: 16)),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        "lib/assets/pictures/home_top_image_2.png",
                        fit: BoxFit
                            .contain, // Ensure the image fits within its container
                      ),
                    ),
                  ],
                ),
              ),

              // Switch option
              const SizedBox(height: 0),
              switcher(_rentRecordsOnGoing, _rentRecordsHistory),


              //////////////////  list items  ////////////////////////
              const SizedBox(height: 5),
              itemsToBeDisplayed.isEmpty ? Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
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
                            fontSize: 10
                          ),
                          const SizedBox(height: 10)
                        ],
                      ),
                    ),
                  ),
                ),
              ) :
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 0, bottom: 100),
                    itemCount: itemsToBeDisplayed.length, // Replace with your actual data length
                    itemBuilder: (context, index) {
                      // Fetch data for each car item from your database here
                      final rentInfo = itemsToBeDisplayed[index]; // Assume carData is a list of car objects

                      return buildCarListItem(
                        imagePath: rentInfo.rent_car_UID,
                        carName: rentInfo.carName,
                        carRentLocation: rentInfo.rentLocation,
                        carStartEndDate: "${rentInfo.startDateTime} - ${rentInfo.endDateTime}",
                        startDate: rentInfo.startDateTime,
                        endDate: rentInfo.endDateTime,
                        totalAmount: "PHP ${rentInfo.totalAmount} / total",
                        rentStatus: rentInfo.rentStatus.toLowerCase(),
                        parentContext: parentContext
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget switcher(List<RentInformation> ongoing, List<RentInformation> history) {
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
          itemsToBeDisplayed = index == 0 ? ongoing : history;
        });
      },
      children: [
        CustomComponents.displayText(
          ProjectStrings.rentals_options_ongoing,
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          ProjectStrings.rentals_options_history,
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }
}
