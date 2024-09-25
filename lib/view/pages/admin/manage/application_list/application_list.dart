import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../shared/colors.dart';
import '../../../../shared/components.dart';
import '../../../../shared/strings.dart';

class ApplicationList extends StatefulWidget {
  const ApplicationList({super.key});

  @override
  State<ApplicationList> createState() => _ApplicationListState();
}

class _ApplicationListState extends State<ApplicationList> {
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
              const SizedBox(height: 15),
              _userListItems(),
              const SizedBox(height: 55)
            ],
          )
        ),
      ),
    );
  }

  Widget _designPerItem({
    required String imagePath,
    required String userName,
    required String userContactNumber,
    required String userEmail,
    required String userStatus,
    required String userType,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
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
                              userEmail,
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
                      Navigator.of(context).pushNamed(userType == "Driver" ? "manage_application_driver" : "manage_application_outsource");
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
                        color: userStatus == "Verified" ? Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16))
                            : userStatus == "Unverified" || userStatus == "Declined" ? Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
                            : Color(int.parse(ProjectColors.applicationListPendingBackground.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            userStatus == "Verified" ? "lib/assets/pictures/rentals_verified.png"
                                : userStatus == "Unverified" ? "lib/assets/pictures/rentals_denied.png"
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
                            userStatus,
                            color: userStatus == "Verified" ? Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16))
                                : userStatus == "Declined" || userStatus == "Unverified" ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16))
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
                        color: userType == "Renter" ? Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                            : userType == "Driver" ? Color(int.parse(ProjectColors.userListDriverHexBackground.substring(2), radix: 16))
                            : userType == "Outsource" ? Color(int.parse(ProjectColors.userListOutsourceHexBackground.substring(2), radix: 16))
                            : Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
                      child: CustomComponents.displayText(
                        userType,
                        color: userType == "Renter" ? Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                            : userType == "Driver" ? Color(int.parse(ProjectColors.userListDriverHex.substring(2), radix: 16))
                            : userType == "Outsource" ? Color(int.parse(ProjectColors.userListOutsourceHex.substring(2), radix: 16))
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

  List<List<String>> items = [
    [
      ProjectStrings.admin_user_list_name_1,
      ProjectStrings.admin_user_list_contact_no,
      ProjectStrings.admin_user_list_email_1,
      ProjectStrings.admin_user_list_verified,
      ProjectStrings.admin_user_list_outsource
    ],
    [
      ProjectStrings.admin_user_list_name_2,
      ProjectStrings.admin_user_list_contact_no,
      ProjectStrings.admin_user_list_email_2,
      "Pending",
      ProjectStrings.admin_user_list_driver
    ],
    [
      ProjectStrings.admin_user_list_name_3,
      ProjectStrings.admin_user_list_contact_no,
      ProjectStrings.admin_user_list_email_3,
      ProjectStrings.admin_user_list_verified,
      ProjectStrings.admin_user_list_outsource
    ],
    [
      ProjectStrings.admin_user_list_name_4,
      ProjectStrings.admin_user_list_contact_no,
      ProjectStrings.admin_user_list_email_4,
      ProjectStrings.admin_user_list_verified,
      ProjectStrings.admin_user_list_driver
    ],
    [
      ProjectStrings.admin_user_list_name_3,
      ProjectStrings.admin_user_list_contact_no,
      ProjectStrings.admin_user_list_email_3,
      "Pending",
      ProjectStrings.admin_user_list_outsource
    ],
  ];

  Widget _userListItems() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _designPerItem(
                imagePath: "lib/assets/pictures/user_info_user.png",
                userName: items[index][0],
                userContactNumber:items[index][1],
                userEmail: items[index][2],
                userStatus: items[index][3],
                userType: items[index][4]
            ),
          );
        },
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
      onSelect: (index) {},
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          CustomComponents.displayText(
            ProjectStrings.application_list_manage_title,
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
}
