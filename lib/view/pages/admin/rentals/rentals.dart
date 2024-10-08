import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/model/constants/firebase_constants.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _seeCompleteBookingInfo();
    });

    try {
      _fetchRentRecords();
    } catch(e) {
      debugPrint("Fetch rent records error-rentals.dart: $e}");
    }
  }

  Future<void> _fetchRentRecords() async {
    // Fetch the rent records information asynchronously
    _rentRecords = await Firestore().getRentRecordsInfo(FirebaseAuth.instance.currentUser!.uid);

    // Update the UI after data is fetched
    setState(() {
      // Set the fetched data
      _rentRecords = _rentRecords;
    });
  }

  Widget buildInfoRowSecondPanel(String title, String value, String titleColor, {double topPadding = 5}) {
    return Padding(
      padding: EdgeInsets.only(right: 15, left: 15, top: topPadding),
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


  Future<void> _seeCompleteBookingInfo() async {
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
                            ProjectStrings.dialog_car_model,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_transmission_title,
                            ProjectStrings.dialog_transmission,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_capacity_title,
                            ProjectStrings.dialog_capacity,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_fuel_title,
                            ProjectStrings.dialog_fuel,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_fuel_capacity_title,
                            ProjectStrings.dialog_fuel_capacity,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_unit_color_title,
                            ProjectStrings.dialog__unit_color,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_engine_title,
                            ProjectStrings.dialog_engine,
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
                            ProjectStrings.dialog_rent_start,
                            ProjectColors.lightGray,
                            topPadding: 15,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_rent_end_title,
                            ProjectStrings.dialog__rent_end,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_delivery_mode_title,
                            ProjectStrings.dialog_delivery_mode,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_delivery_location_title,
                            ProjectStrings.dialog_delivery_location,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_location_title,
                            ProjectStrings.dialog_location,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_reserved_title,
                            ProjectStrings.dialog_reserved,
                            ProjectColors.lightGray,
                          ),
                          buildInfoRowSecondPanel(
                            ProjectStrings.dialog_admin_notes_title,
                            ProjectStrings.dialog_admin_notes,
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
                        Container(
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "rentals_report");
                                  },
                                  child: Padding(
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
                                ),
                              ],
                            )),

                        //  approved
                        const SizedBox(width: 20),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(int.parse(
                                  ProjectColors.lightGreen.substring(2),
                                  radix: 16)),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                    "lib/assets/pictures/rentals_verified.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 25, left: 5),
                                  child: CustomComponents.displayText(
                                    ProjectStrings
                                        .dialog_approved_button,
                                    color: Color(int.parse(
                                        ProjectColors.greenButtonMain
                                            .substring(2),
                                        radix: 16)),
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

                  const SizedBox(height: 15),
                  UnconstrainedBox(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.dialog_transaction_number_title,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.lightGray)),
                            fontStyle: FontStyle.italic
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.dialog_transaction,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.lightGray)),
                            fontStyle: FontStyle.italic
                          )
                        ],
                      ),
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
    required String totalAmount,
    required String rentStatus
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

                  Column(
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
                      CustomComponents.displayText(
                        carRentLocation,
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                      const SizedBox(height: 5),
                      CustomComponents.displayText(
                          "Date: ",
                          fontSize: 10, fontWeight: FontWeight.bold),
                      CustomComponents.displayText(
                          carStartEndDate,
                          color: Colors.grey,
                          fontSize: 10),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          _seeCompleteBookingInfo();
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
                      color: rentStatus == "approved" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16)) :
                          rentStatus == "pending" ? Color(int.parse(ProjectColors.carouselNotSelected.substring(2), radix: 16)) :
                          rentStatus == "denied" ? Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)) : Colors.white
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            rentStatus == "approved" ? "lib/assets/pictures/rentals_verified.png" :
                            rentStatus == "pending" ? "lib/assets/pictures/rentals_pending.png" :
                            rentStatus == "denied" ? "lib/assets/pictures/rentals_denied.png" : "lib/assets/pictures/rentals_denied.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10, right: 25, left: 5),
                          child: CustomComponents.displayText(
                            CustomComponents.capitalizeFirstLetter(rentStatus),

                            color: rentStatus == "approved" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)) :
                              rentStatus == "pending" ? Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)) :
                              rentStatus == "denied" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)) : Colors.white,
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          CustomComponents.displayText(
            "Rent Profile",
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset(
                "lib/assets/pictures/three_vertical_dots.png"),
          ),
        ],
      ),
    );
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
                            "PH ${PersistentData().userInfo!.number}",
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Color(int.parse(
                                ProjectColors.lightGray.substring(2),
                                radix: 16)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(int.parse(
                                    ProjectColors.lightGreen.substring(2),
                                    radix: 16)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                      "lib/assets/pictures/rentals_verified.png",
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
                                      ProjectStrings
                                          .rentals_header_verified_button,
                                      color: Color(int.parse(
                                          ProjectColors.greenButtonMain
                                              .substring(2),
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
                        "lib/assets/pictures/home_top_image.png",
                        fit: BoxFit
                            .contain, // Ensure the image fits within its container
                      ),
                    ),
                  ],
                ),
              ),

              // Switch option
              const SizedBox(height: 15),
              SlideSwitcher(
                indents: 3,
                containerColor: Colors.white,
                containerBorderRadius: 7,
                slidersColors: [
                  Color(int.parse(
                      ProjectColors.mainColorHexBackground.substring(2),
                      radix: 16))
                ],
                containerHeight: 50,
                containerWight: MediaQuery.of(context).size.width - 50,
                onSelect: (index) {},
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
                  ),
                ],
              ),


              //////////////////  list items  ////////////////////////
              const SizedBox(height: 15),
              _rentRecords.isEmpty ? const Center(child: CircularProgressIndicator()) :
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0, bottom: 100),
                  itemCount: _rentRecords.length, // Replace with your actual data length
                  itemBuilder: (context, index) {
                    // Fetch data for each car item from your database here
                    final rentInfo = _rentRecords[index]; // Assume carData is a list of car objects

                    return buildCarListItem(
                      imagePath: rentInfo.rent_car_UID,
                      carName: rentInfo.carName,
                      carRentLocation: rentInfo.rentLocation,
                      carStartEndDate: "${rentInfo.startDateTime} - ${rentInfo.endDateTime}",
                      totalAmount: "PHP ${rentInfo.totalAmount} / total",
                      rentStatus: rentInfo.rentStatus.toLowerCase()
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
