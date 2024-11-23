import 'dart:math';

import 'package:dara_app/controller/admin_manage/application_list/application_list.dart';
import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/model/outsource/OutsourceApplication.dart';
import 'package:dara_app/view/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../model/driver/driver_application.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/components.dart';
import '../../../../shared/strings.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({super.key});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
  late List<OutsourceApplication> outsourceApplicationList;
  late List<DriverApplication> driverApplicationList;
  final ApplicationListController _applicationListController = ApplicationListController();
  List<Map<String, String>> listToBeDisplayed = [];
  List<Map<String, String>> pendingApplications = [];
  List<Map<String, String>> approvedApplications = [];
  List<Map<String, String>> declinedApplications = [];
  int _currentSelectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchDriverOutsourceApplicationInfo();
    });
  }

  Future<void> refreshPage() async {
    LoadingDialog().show(context: context, content: "Please wait while we retrieve the applications.");
    await _fetchDriverOutsourceApplicationInfo();
    LoadingDialog().dismiss();
  }

  Future<void> _fetchDriverOutsourceApplicationInfo() async {
    listToBeDisplayed.clear();
    pendingApplications.clear();
    approvedApplications.clear();
    declinedApplications.clear();

    try {
      LoadingDialog().show(context: context, content: "Please wait while we retrieve the applications.");
      List<OutsourceApplication> outsourceApplicationListTemp = await _applicationListController.getOutsourceApplicationList();
      List<DriverApplication> driverApplicationListTemp = await _applicationListController.getDriverApplicationList();
      LoadingDialog().dismiss();

      setState(() {
        outsourceApplicationList = outsourceApplicationListTemp;
        driverApplicationList = driverApplicationListTemp;
        _isLoading = false;

        // Populate all the application lists based on status
        for (var item in outsourceApplicationList) {
          debugPrint("date: ${item.userDateRegistered}");
          Map<String, String> applicationData = {
            "first_name": item.userFirstName,
            "last_name": item.userLastName,
            "email": item.userEmail,
            "number": item.userNumber,
            "status": item.applicationStatus,
            "role": item.userType,
            "id": item.userID,
            "registered_date": item.userDateRegistered
          };
          _categorizeApplication(applicationData);
        }

        for (var item in driverApplicationList) {
          debugPrint("date-driver: ${item.userDateRegistered}");
          Map<String, String> applicationData = {
            "first_name": item.userFirstName,
            "last_name": item.userLastName,
            "email": item.userEmail,
            "number": item.userNumber,
            "status": item.driverApplicationStatus,
            "role": item.userType,
            "id": item.userID,
            "registered_date": item.userDateRegistered
          };
          _categorizeApplication(applicationData);
        }

        // Display the correct list based on the current selected index
        _updateListToBeDisplayed();
      });
    } catch (e) {
      LoadingDialog().dismiss();
      debugPrint("error@_fetchDriverOutsourceApplicationInfo@application_list.dart");
    }
  }

  void _categorizeApplication(Map<String, String> applicationData) {
    String status = applicationData["status"]!.toLowerCase();
    if (status == "pending") {
      pendingApplications.add(applicationData);
    } else if (status == "approved") {
      approvedApplications.add(applicationData);
    } else if (status == "declined") {
      declinedApplications.add(applicationData);
    }
  }

  void _updateListToBeDisplayed() {
    setState(() {
      if (_currentSelectedIndex == 0) {
        listToBeDisplayed = pendingApplications;
      } else if (_currentSelectedIndex == 1) {
        listToBeDisplayed = approvedApplications;
      } else if (_currentSelectedIndex == 2) {
        listToBeDisplayed = declinedApplications;
      }
    });
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

              // title and subheader
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(ProjectStrings.application_list_header,
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomComponents.displayText(
                      ProjectStrings.application_list_subheader,
                      fontSize: 10),
                ),
              ),
              //  switch option
              const SizedBox(height: 15),
              switchOption(),
              const SizedBox(height: 10),
              _userListItems(),
              const SizedBox(height: 55)
            ],
          )
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
    required String userID,
    required String imagePath,
    required String userName,
    required String userContactNumber,
    required String userEmail,
    required String userStatus,
    required String userType,
    required String dateRegistered
  }) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      getInitials(userName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomComponents.displayText(
                          userName,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.admin_user_list_contact_no_title,
                              fontSize: 10,
                            ),
                            CustomComponents.displayText(
                              userContactNumber,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.admin_user_list_email_title,
                              fontSize: 10,
                            ),
                            CustomComponents.displayText(
                              userEmail,
                              fontSize: 10,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.application_list_date_registered_title,
                              fontSize: 10,
                            ),
                            CustomComponents.displayText(
                              dateRegistered,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      PersistentData().selectedApplicantUID = userID;

                      Navigator.of(context).pushNamed(userType.toLowerCase() == "driver" ? "manage_application_driver" : "manage_application_outsource");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          "lib/assets/pictures/see_more.png",
                          width: 20,
                        ),
                        CustomComponents.displayText(
                          ProjectStrings.application_list_more_info,
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
                        color: userStatus.toLowerCase() == "approved" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16))
                            : userStatus.toLowerCase() == "declined" || userStatus.toLowerCase() == "declined" ? Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
                            : Color(int.parse(ProjectColors.applicationListPendingBackground.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            userStatus.toLowerCase() == "approved" ? "lib/assets/pictures/rentals_verified.png"
                                : userStatus.toLowerCase() == "declined" ? "lib/assets/pictures/rentals_denied.png"
                                : "lib/assets/pictures/pending_blue.png",
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
                            CustomComponents.capitalizeFirstLetter(userStatus),
                            color: userStatus.toLowerCase() == "approved" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16))
                                : userStatus.toLowerCase() == "declined" || userStatus.toLowerCase() == "unverified" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16))
                                : Color(int.parse(ProjectColors.applicationListPending.substring(2), radix: 16)),
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
                        color: userType.toLowerCase() == "renter" ? Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                            : userType.toLowerCase() == "driver" ? Color(int.parse(ProjectColors.userListDriverHexBackground.substring(2), radix: 16))
                            : userType.toLowerCase() == "outsource" ? Color(int.parse(ProjectColors.userListOutsourceHexBackground.substring(2), radix: 16))
                            : Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
                      child: CustomComponents.displayText(
                        userType,
                        color: userType.toLowerCase() == "renter" ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                            : userType.toLowerCase() == "driver" ? Color(int.parse(ProjectColors.userListDriverHex.substring(2), radix: 16))
                            : userType.toLowerCase() == "outsource" ? Color(int.parse(ProjectColors.userListOutsourceHex.substring(2), radix: 16))
                            : Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
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

  Widget _userListItems() {
    return Expanded(
      child: _isLoading ? Padding(
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
      ) : RefreshIndicator(
        onRefresh: () async {
          refreshPage();
        },
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: listToBeDisplayed.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _designPerItem(
                imagePath: "lib/assets/pictures/user_info_user.png",
                userName: "${listToBeDisplayed[index]["first_name"]} ${listToBeDisplayed[index]["last_name"]}",
                userContactNumber: "${listToBeDisplayed[index]["number"]}",
                userEmail: "${listToBeDisplayed[index]["email"]}",
                userStatus: "${listToBeDisplayed[index]["status"]}",
                userType: "${listToBeDisplayed[index]["role"]}",
                userID: "${listToBeDisplayed[index]["id"]}",
                dateRegistered: "${listToBeDisplayed[index]["registered_date"]}"
              ),
            );
          },
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
          ProjectStrings.application_list_options_pending,
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          ProjectStrings.application_list_options_approved,
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          ProjectStrings.application_list_options_declined,
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
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
            ProjectStrings.application_list_manage_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
