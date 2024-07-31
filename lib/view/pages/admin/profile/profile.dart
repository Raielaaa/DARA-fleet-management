import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(
          int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      child: Padding(
        padding: const EdgeInsets.only(top: 38),
        child: Column(
          children: [
            //  ActionBar
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
                    "User Information",
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
                        "Admin",
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
                          "Hello, Admin",
                          fontWeight: FontWeight.bold,
                        ),
                        CustomComponents.displayText(
                          "PH +63 ****** 8475",
                          fontWeight: FontWeight.w600,
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
                                      top: 10, bottom: 10, right: 25, left: 5),
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

            //  main profile section
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    //  profile image
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Image.asset(
                        "lib/assets/pictures/user_info_user.png",
                        width: 80,
                        height: 80,
                      ),
                    ),
                    //  name
                    CustomComponents.displayText(ProjectStrings.user_info_name,
                        fontWeight: FontWeight.bold, fontSize: 14),
                    //  gray line
                    const SizedBox(height: 20),
                    Container(
                      color: Color(int.parse(
                          ProjectColors.lineGray.substring(2),
                          radix: 16)),
                      height: 1,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 15),

                    //  full name
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.user_info_full_name_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_full_name,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          )
                        ],
                      ),
                    ),

                    //  registered number
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.user_info_registered_number_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_registered_number,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          )
                        ],
                      ),
                    ),

                    //  email adddress
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.user_info_email_address_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_email_address,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          )
                        ],
                      ),
                    ),

                    //  rental count
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.user_info_rental_count_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_rental_count,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          )
                        ],
                      ),
                    ),

                    //  favorite
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.user_info_favorite_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_favorite,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          )
                        ],
                      ),
                    ),

                    //  longest rental period
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings
                                  .user_info_longest_rental_period_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_longest_rental_period,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          )
                        ],
                      ),
                    ),

                    //  total amount spent
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                              ProjectStrings.user_info_total_amount_spent_title,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.lightGray.substring(2),
                                  radix: 16))),
                          CustomComponents.displayText(
                              ProjectStrings.user_info_total_amount_spent,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Color(int.parse(
                                  ProjectColors.mainColorHex.substring(2),
                                  radix: 16)))
                        ],
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),

            //  bottom panel
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //  item 1
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 20, bottom: 20, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose, // Use Flexible with FlexFit.loose
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(int.parse(
                                    ProjectColors.userInfoRed.substring(2),
                                    radix:
                                        16)), // Optional: add background color to the circle
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "lib/assets/pictures/user_info_report.png",
                                  width: 20, // Adjust the image size as needed
                                  height: 20, // Adjust the image size as needed
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the entire container
                                ),
                              ),
                            ),
                          ),
                      
                          const SizedBox(height: 7),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_report,
                            fontWeight: FontWeight.w500,
                            fontSize: 10
                          ),
                        ],
                      ),
                    ),

                    //  item 2
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose, // Use Flexible with FlexFit.loose
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(int.parse(
                                    ProjectColors.userInfoGreen.substring(2),
                                    radix:
                                        16)), // Optional: add background color to the circle
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "lib/assets/pictures/user_info_email.png",
                                  width: 20, // Adjust the image size as needed
                                  height: 20, // Adjust the image size as needed
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the entire container
                                ),
                              ),
                            ),
                          ),
                      
                          const SizedBox(height: 7),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_contact,
                            fontWeight: FontWeight.w500,
                            fontSize: 10
                          ),
                        ],
                      ),
                    ),

                    //  item 3
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose, // Use Flexible with FlexFit.loose
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(int.parse(
                                    ProjectColors.userInfoBlue.substring(2),
                                    radix:
                                        16)), // Optional: add background color to the circle
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "lib/assets/pictures/user_info_policy.png",
                                  width: 20, // Adjust the image size as needed
                                  height: 20, // Adjust the image size as needed
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the entire container
                                ),
                              ),
                            ),
                          ),
                      
                          const SizedBox(height: 7),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_policy,
                            fontWeight: FontWeight.w500,
                            fontSize: 10
                          ),
                        ],
                      ),
                    ),

                    //  item 4
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20, right: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose, // Use Flexible with FlexFit.loose
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(int.parse(
                                    ProjectColors.userInfoLightBlue.substring(2),
                                    radix:
                                        16)), // Optional: add background color to the circle
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "lib/assets/pictures/user_info_documents.png",
                                  width: 20, // Adjust the image size as needed
                                  height: 20, // Adjust the image size as needed
                                  fit: BoxFit
                                      .cover, // Ensure the image covers the entire container
                                ),
                              ),
                            ),
                          ),
                      
                          const SizedBox(height: 7),
                          CustomComponents.displayText(
                            ProjectStrings.user_info_documents,
                            fontWeight: FontWeight.w500,
                            fontSize: 10
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
