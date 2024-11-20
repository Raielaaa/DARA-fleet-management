import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "../../../../../controller/singleton/persistent_data.dart";

class ManageReports extends StatefulWidget {
  const ManageReports({super.key});

  @override
  State<ManageReports> createState() => _ManageReportsState();
}

class _ManageReportsState extends State<ManageReports> {

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
                      "Management Dashboard",
                      fontWeight: FontWeight.bold,
                    ),
                    CustomComponents.menuButtons(context),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting, date, and user picture
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomComponents.displayText(
                                  ProjectStrings.manage_reports_greetings,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                const SizedBox(height: 3),
                                CustomComponents.displayText(
                                  PersistentData().getCurrentFormattedDate(),
                                  fontSize: 12,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "lib/assets/pictures/user_info_user.png",
                              width: 42,
                              height: 42,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Admin Options
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                  ProjectStrings.manage_reports_admin_options,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.03,
                                ),
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Color(int.parse(ProjectColors.lineGray)),
                            ),
                            const SizedBox(height: 20),

                            settingsListItem(
                              context: context,
                              color: const Color(0xff0564ff),
                              icon: Icons.apps,
                              text: "Applications",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_application_list");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xff00be15),
                              icon: Icons.question_answer,
                              text: "Rent inquiries",
                              onTap: () {
                                // Navigator.of(context).pushNamed("manage_inquiries");
                                Navigator.of(context).pushNamed("manage_view_inquiries");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xfffe7701),
                              icon: Icons.directions_car,
                              text: "Car status",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_car_status");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xffffb103),
                              icon: Icons.people,
                              text: "User list",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_user_list");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xff00be11),
                              icon: Icons.history,
                              text: "Rent logs",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_rent_logs");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xff0564ff),
                              icon: Icons.car_repair,
                              text: "Car units",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_car_list");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xffff7500),
                              icon: Icons.camera_alt,
                              text: "Banner",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_banner");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xff06bc19),
                              icon: Icons.backup,
                              text: "Backup and restore",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_backup_restore");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xff0564ff),
                              icon: Icons.location_on,
                              text: "Garage location",
                              onTap: () async {
                                await Navigator.of(context).pushNamed("map_screen_for_garage");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xffffb103),
                              icon: Icons.account_circle,
                              text: "My account",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_my_account");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xffe93c2e),
                              icon: Icons.description,
                              text: "Reports",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_report_main");
                              },
                            ),
                            const SizedBox(height: 20),
                            settingsListItem(
                              context: context,
                              color: const Color(0xff06bc19),
                              icon: Icons.integration_instructions,
                              text: "Integrated Apps",
                              onTap: () {
                                Navigator.of(context).pushNamed("manage_integrated_apps");
                              },
                            ),

                            const SizedBox(height: 30)
                          ],
                        ),
                      ),

                      // // Integrated Apps
                      // const SizedBox(height: 30),
                      // CustomComponents.displayText(
                      //   ProjectStrings.manage_reports_integrated_apps,
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: 12,
                      // ),
                      // const SizedBox(height: 15),
                      // Row(
                      //   children: [
                      //     buildIntegratedApp(
                      //       "lib/assets/pictures/google_maps_icon.png",
                      //       ProjectStrings.manage_reports_google_maps,
                      //       "0xffffffff"
                      //     ),
                      //     const SizedBox(width: 15),
                      //     buildIntegratedApp(
                      //       "lib/assets/pictures/bottom_nav_bar_antrip.png",
                      //       ProjectStrings.manage_reports_antrip_iot,
                      //       ProjectColors.antripIOTColor
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 80)
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget settingsListItem({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Material(
        color: Colors.transparent, // Make the Material background transparent
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.blue.withOpacity(0.2), // Splash effect color
          highlightColor: Colors.blue.withOpacity(0.1), // Highlight effect color
          borderRadius: BorderRadius.circular(8), // Optional: adds rounded corners to the highlight effect
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        width: 32,
                        height: 32,
                      ),
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20), // Spacing between icon and text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      CustomComponents.displayText(
                        text,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 10), // Space between text and bottom border
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        height: 1,
                        color: Colors.grey.shade300, // Subtle divider line
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xffd6d6d6),
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget buildIntegratedApp(String imagePath, String label, String bgColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 90,
          decoration: BoxDecoration(
            color: Color(int.parse(ProjectColors.reportMangeSelectedItem
                .substring(2),
                radix: 16)),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Color(int.parse(bgColor)),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Image.asset(
            imagePath,
            width: 30,
          ),
        ),
        Positioned(
          bottom: 10,
          child: CustomComponents.displayText(
            label,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
