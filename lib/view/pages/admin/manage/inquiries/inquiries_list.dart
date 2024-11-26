import "dart:math";

import "package:dara_app/view/pages/admin/manage/inquiries/view_inquiry.dart";
import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:intl/intl.dart";
import "package:slide_switcher/slide_switcher.dart";

import "../../../../../controller/singleton/persistent_data.dart";
import "../../../../../model/constants/firebase_constants.dart";
import "../../../../../model/renting_proccess/renting_process.dart";
import "../../../../../services/firebase/firestore.dart";
import "../../../../../services/firebase/storage.dart";
import "../../../../shared/colors.dart";
import "../../../../shared/components.dart";
import "../../../../shared/loading.dart";
import "../../../../shared/strings.dart";

class ViewInquiries extends StatefulWidget {
  const ViewInquiries({super.key});

  @override
  State<ViewInquiries> createState() => _ViewInquiriesState();
}

class _ViewInquiriesState extends State<ViewInquiries> {
  final TextEditingController _searchController = TextEditingController();
  List<RentInformation> ongoingInquiry = [];
  List<RentInformation> pastDuesInquiry = [];
  List<RentInformation> listToBeDisplayed = [];
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) => _retrieveRentRecords());
  }

  void _performSearch(String query) {
    query = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        listToBeDisplayed = _selectedIndex == 0 ? ongoingInquiry : pastDuesInquiry;
      } else {
        listToBeDisplayed = listToBeDisplayed.where((inquiry) =>
        inquiry.carName.toLowerCase().contains(query) ||
            inquiry.startDateTime.toLowerCase().contains(query) ||
            inquiry.endDateTime.toLowerCase().contains(query) ||
            inquiry.renterEmail.toLowerCase().contains(query) ||
            inquiry.pickupOrDelivery.toLowerCase().contains(query) ||
            inquiry.totalAmount.toLowerCase().contains(query) ||
            inquiry.rentLocation.toLowerCase().contains(query) ||
            (inquiry.reservationFee != "0" ? "reserved" : "unreserved").contains(query)
        ).toList();
      }
    });
  }

  Future<void> _retrieveRentRecords() async {
    LoadingDialog().show(context: context, content: "Retrieving rent inquiries. Please wait a moment.");
    try {
      final pendingRecords = await _fetchPendingRecords();

      if (!mounted) return;

      for (var item in pendingRecords) {
        if (isDateInPast(item.startDateTime)) {
          setState(() {
            pastDuesInquiry.add(item);
          });
        } else {
          setState(() {
            ongoingInquiry.add(item);
          });
        }
      }

      setState(() {
        listToBeDisplayed = ongoingInquiry;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) LoadingDialog().show(context: context, content: "Something went wrong: $e");
      debugPrint("Error@inquiries.dart: $e");
    } finally {
      LoadingDialog().dismiss();
    }
  }

  Future<List<RentInformation>> _fetchPendingRecords() async {
    final records = await Firestore().getRentRecords();
    return records.where((item) => item.rentStatus.toLowerCase() == "pending").toList();
  }

  // Future<List<Map<String, dynamic>>> _fetchUserData(List<RentInformation> records) async {
  //   ongoingInquiry.clear();
  //   pastDuesInquiry.clear();
  //
  //   return Future.wait(records.map((record) async {
  //     final userInfo = await Firestore().getUserInfo(record.renterUID);
  //     final userFiles = await Storage().getUserFilesForInquiry(
  //       FirebaseConstants.rentDocumentsUpload, record.renterUID,
  //     );
  //
  //     if (isDateInPast(record.startDateTime)) {
  //       pastDuesInquiry.add(record);
  //     } else {
  //       ongoingInquiry.add(record);
  //     }
  //
  //     return {
  //       'rentInformation': record,
  //       'userInfo': userInfo,
  //       'submittedFiles': userFiles,
  //     };
  //   }));
  // }

  bool isDateInPast(String dateStr) {
    final parsedDate = DateFormat("MMMM d, yyyy | hh:mm a").parse(dateStr);
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
              switcher(),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _searchAndFilterBar(),
              ),
              const SizedBox(height: 15),
              _inquiryListItems(),
              const SizedBox(height: 70)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    ongoingInquiry.clear();
    pastDuesInquiry.clear();
    listToBeDisplayed.clear();

    await _retrieveRentRecords();
  }

  Widget _inquiryListItems() {
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

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _designPerItem(
                  carName: currentItem.carName,
                  rentDateRange: "${currentItem.startDateTime} - ${currentItem.endDateTime}",
                  rentLocation: currentItem.rentLocation,
                  deliveryOrPickup: CustomComponents.capitalizeFirstLetter(currentItem.pickupOrDelivery),
                  status: CustomComponents.capitalizeFirstLetter(currentItem.paymentStatus),
                  completeRentInfo: currentItem,
                  rentAmount: "PHP ${currentItem.totalAmount}"
              ),
            );
          },
        ),
      ),
    );
  }

  String getInitials(String input) {
    // Split the string into words
    List<String> words = input.split(' ');

    // Filter out numeric words
    List<String> filteredWords = words.where((word) => !RegExp(r'^\d+$').hasMatch(word)).toList();

    // Ensure there are at least two non-numeric words
    if (filteredWords.length < 2) return '';

    // Get the first letter of the first two non-numeric words
    String firstInitial = filteredWords[0][0];
    String secondInitial = filteredWords[1][0];

    // Combine them and return
    return firstInitial + secondInitial;
  }

  Widget _designPerItem({
    required String carName,
    required String rentDateRange,
    required String rentLocation,
    required String deliveryOrPickup,
    required String status,
    required RentInformation completeRentInfo,
    required String rentAmount
  }) {
    // List of random colors
    final colors = [
      const Color(0xff0564ff),
      const Color(0xff00be15),
      const Color(0xfffe7701),
      const Color(0xffffb103),
      const Color(0xffe93c2e),
    ];

    // Select a random color
    final randomColor = colors[Random().nextInt(colors.length)];

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
                      color: randomColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      getInitials(completeRentInfo.carName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                            Row(
                              children: [
                                CustomComponents.displayText(
                                  "Rent amount: ",
                                  fontSize: 10,
                                ),
                                CustomComponents.displayText(
                                    rentAmount,
                                    fontSize: 10
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  "Rent location: ",
                                  fontSize: 10,
                                ),
                                Expanded(
                                  child: CustomComponents.displayText(
                                    rentLocation,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                        color: completeRentInfo.reservationFee == "0" ? Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16)) : Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            completeRentInfo.reservationFee == "0" ? "lib/assets/pictures/rentals_denied.png" : "lib/assets/pictures/rentals_verified.png",
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
                            completeRentInfo.reservationFee == "0" ? "Unreserved" : "Reserved",
                            color: completeRentInfo.reservationFee == "0" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)) : Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // See more
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewInquiry(rentInfo: completeRentInfo))
                      );
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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
                onChanged: (value) => _performSearch(value),
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  hintText: "Search by car name, date, delivery mode, rent amount, rent location, reserved or not",
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

  Widget switcher() {
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
          _selectedIndex = index;
          listToBeDisplayed = index == 0 ? ongoingInquiry : pastDuesInquiry;
        });
      },
      children: [
        CustomComponents.displayText(
          "Current Dues",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Past Dues",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )
      ],
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
              PersistentData().openDrawer(0);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("lib/assets/pictures/menu.png"),
            ),
          ),
          CustomComponents.displayText(
            ProjectStrings.ri_appbar,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
