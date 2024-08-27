import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _seeUploadDocumentsDialog();
    });
  }

  Future<void> _seeUploadDocumentsDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Color(int.parse(
            ProjectColors.mainColorBackground.substring(2),
            radix: 16,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    padding:
                        const EdgeInsets.only(right: 15, left: 15, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomComponents.displayText(
                          ProjectStrings.dialog_title_1,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        Image.asset(
                          "lib/assets/pictures/app_logo_circle.png",
                          width: 80.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Main content
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    // Main panel numbered header
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
                                  radix: 16,
                                )),
                                border: Border.all(
                                  color:
                                      Color(int.parse(ProjectColors.lineGray)),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: CustomComponents.displayText(
                                  "1",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            // Use Expanded only if the parent widget has constraints
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  ProjectStrings.user_info_header_title,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(height: 2),
                                CustomComponents.displayText(
                                  ProjectStrings.user_info_header,
                                  color: Color(int.parse(
                                    ProjectColors.lightGray.substring(2),
                                    radix: 16,
                                  )),
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
                        radix: 16,
                      )),
                    ),

                    //  government valid id 1
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: DashedBorder.fromBorderSide(
                                  dashLength: 4,
                                  side: BorderSide(
                                      color: Color(int.parse(
                                          ProjectColors
                                              .userInfoDialogBrokenLinesColor
                                              .substring(2),
                                          radix: 16)),
                                      width: 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 30, bottom: 10),
                                  child: Image.asset(
                                    "lib/assets/pictures/user_info_upload.png",
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_upload_file,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_government1,
                                          color: Color(int.parse(
                                            ProjectColors.lightGray
                                                .substring(2),
                                            radix: 16,
                                          )),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                      const SizedBox(height: 5),
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                            Color(int.parse(
                                                ProjectColors
                                                    .userInfoDialogBrokenLinesColor
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                          shape: MaterialStatePropertyAll<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          padding: MaterialStatePropertyAll<
                                                  EdgeInsets>(
                                              EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                  top: 8,
                                                  bottom:
                                                      8)), // Remove default padding
                                          minimumSize: MaterialStatePropertyAll<
                                                  Size>(
                                              Size(0,
                                                  0)), // Ensures no minimum size
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrinks the tap target size
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: CustomComponents.displayText(
                                            ProjectStrings
                                                .user_info_choose_a_file,
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]
                            )
                          ),
                      )
                    ),

                    //  government valid id 2
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: DashedBorder.fromBorderSide(
                                  dashLength: 4,
                                  side: BorderSide(
                                      color: Color(int.parse(
                                          ProjectColors
                                              .userInfoDialogBrokenLinesColor
                                              .substring(2),
                                          radix: 16)),
                                      width: 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 30, bottom: 10),
                                  child: Image.asset(
                                    "lib/assets/pictures/user_info_upload.png",
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_upload_file,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_government2,
                                          color: Color(int.parse(
                                            ProjectColors.lightGray
                                                .substring(2),
                                            radix: 16,
                                          )),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                      const SizedBox(height: 5),
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                            Color(int.parse(
                                                ProjectColors
                                                    .userInfoDialogBrokenLinesColor
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                          shape: MaterialStatePropertyAll<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          padding: MaterialStatePropertyAll<
                                                  EdgeInsets>(
                                              EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                  top: 8,
                                                  bottom:
                                                      8)), // Remove default padding
                                          minimumSize: MaterialStatePropertyAll<
                                                  Size>(
                                              Size(0,
                                                  0)), // Ensures no minimum size
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrinks the tap target size
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: CustomComponents.displayText(
                                            ProjectStrings
                                                .user_info_choose_a_file,
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ])),
                        )),

                    //  driver's license
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: DashedBorder.fromBorderSide(
                                  dashLength: 4,
                                  side: BorderSide(
                                      color: Color(int.parse(
                                          ProjectColors
                                              .userInfoDialogBrokenLinesColor
                                              .substring(2),
                                          radix: 16)),
                                      width: 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 30, bottom: 10),
                                  child: Image.asset(
                                    "lib/assets/pictures/user_info_upload.png",
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_upload_file,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      CustomComponents.displayText(
                                          ProjectStrings
                                              .user_info_driver_license,
                                          color: Color(int.parse(
                                            ProjectColors.lightGray
                                                .substring(2),
                                            radix: 16,
                                          )),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                      const SizedBox(height: 5),
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                            Color(int.parse(
                                                ProjectColors
                                                    .userInfoDialogBrokenLinesColor
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                          shape: MaterialStatePropertyAll<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          padding: MaterialStatePropertyAll<
                                                  EdgeInsets>(
                                              EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                  top: 8,
                                                  bottom:
                                                      8)), // Remove default padding
                                          minimumSize: MaterialStatePropertyAll<
                                                  Size>(
                                              Size(0,
                                                  0)), // Ensures no minimum size
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrinks the tap target size
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: CustomComponents.displayText(
                                            ProjectStrings
                                                .user_info_choose_a_file,
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ])),
                        )),

                    //  proof of billing
                    Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: DashedBorder.fromBorderSide(
                                  dashLength: 4,
                                  side: BorderSide(
                                      color: Color(int.parse(
                                          ProjectColors
                                              .userInfoDialogBrokenLinesColor
                                              .substring(2),
                                          radix: 16)),
                                      width: 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 30, bottom: 10),
                                  child: Image.asset(
                                    "lib/assets/pictures/user_info_upload.png",
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_upload_file,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      CustomComponents.displayText(
                                          ProjectStrings
                                              .user_info_proof_of_billing,
                                          color: Color(int.parse(
                                            ProjectColors.lightGray
                                                .substring(2),
                                            radix: 16,
                                          )),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                      const SizedBox(height: 5),
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                            Color(int.parse(
                                                ProjectColors
                                                    .userInfoDialogBrokenLinesColor
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                          shape: MaterialStatePropertyAll<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          padding: MaterialStatePropertyAll<
                                                  EdgeInsets>(
                                              EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                  top: 8,
                                                  bottom:
                                                      8)), // Remove default padding
                                          minimumSize: MaterialStatePropertyAll<
                                                  Size>(
                                              Size(0,
                                                  0)), // Ensures no minimum size
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrinks the tap target size
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: CustomComponents.displayText(
                                            ProjectStrings
                                                .user_info_choose_a_file,
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ])),
                        )),

                    //  ltms portal
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: DashedBorder.fromBorderSide(
                                  dashLength: 4,
                                  side: BorderSide(
                                      color: Color(int.parse(
                                          ProjectColors
                                              .userInfoDialogBrokenLinesColor
                                              .substring(2),
                                          radix: 16)),
                                      width: 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, top: 10, right: 30, bottom: 10),
                                  child: Image.asset(
                                    "lib/assets/pictures/user_info_upload.png",
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_upload_file,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      CustomComponents.displayText(
                                          ProjectStrings.user_info_ltms_portal,
                                          color: Color(int.parse(
                                            ProjectColors.lightGray
                                                .substring(2),
                                            radix: 16,
                                          )),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                      const SizedBox(height: 5),
                                      TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                            Color(int.parse(
                                                ProjectColors
                                                    .userInfoDialogBrokenLinesColor
                                                    .substring(2),
                                                radix: 16)),
                                          ),
                                          shape: MaterialStatePropertyAll<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                          padding: MaterialStatePropertyAll<
                                                  EdgeInsets>(
                                              EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                  top: 8,
                                                  bottom:
                                                      8)), // Remove default padding
                                          minimumSize: MaterialStatePropertyAll<
                                                  Size>(
                                              Size(0,
                                                  0)), // Ensures no minimum size
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrinks the tap target size
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: CustomComponents.displayText(
                                            ProjectStrings
                                                .user_info_choose_a_file,
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ])),
                        )),
                    //  save documents button
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(int.parse(
                                    ProjectColors.userInfoDialogBrokenLinesColor
                                        .substring(2),
                                    radix: 16))),
                            shape: MaterialStatePropertyAll<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: CustomComponents.displayText(
                              ProjectStrings.user_info_save_documents,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 30,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    color: Colors.white),
              )
            ],
          ),
        );
      },
    );
  }

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
                      padding: const EdgeInsets.only(
                          left: 40, top: 20, bottom: 20, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit
                                .loose, // Use Flexible with FlexFit.loose
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
                              fontSize: 10),
                        ],
                      ),
                    ),

                    //  item 2
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 20, bottom: 20, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit
                                .loose, // Use Flexible with FlexFit.loose
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
                              fontSize: 10),
                        ],
                      ),
                    ),

                    //  item 3
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 20, bottom: 20, right: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit
                                .loose, // Use Flexible with FlexFit.loose
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
                              fontSize: 10),
                        ],
                      ),
                    ),

                    //  item 4
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 20, bottom: 20, right: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit
                                .loose, // Use Flexible with FlexFit.loose
                            child: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(int.parse(
                                    ProjectColors.userInfoLightBlue
                                        .substring(2),
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
                              fontSize: 10),
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
