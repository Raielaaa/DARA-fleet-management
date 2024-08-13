import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

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
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("lib/assets/pictures/left_arrow.png"),
                    ),
                    CustomComponents.displayText(
                      ProjectStrings.manage_reports_appbar,
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
                                  ProjectStrings.manage_reports_date,
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
                        height: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: CustomComponents.displayText(
                                  ProjectStrings.manage_reports_admin_options,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: double.infinity,
                              height: 1,
                              color: Color(int.parse(ProjectColors.lineGray)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              child: Row(
                                children: [
                                  buildAdminOption(
                                    "lib/assets/pictures/manage_report_report.png",
                                    ProjectStrings.manage_reports_reports,
                                  ),
                                  const SizedBox(width: 15),
                                  buildAdminOption(
                                    "lib/assets/pictures/manage_report_inquiries.png",
                                    ProjectStrings.manage_reports_inquiries,
                                  ),
                                  const SizedBox(width: 15),
                                  buildAdminOption(
                                    "lib/assets/pictures/manage_report_car_status.png",
                                    ProjectStrings.manage_reports_car_status,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      // Integrated Apps
                      const SizedBox(height: 30),
                      CustomComponents.displayText(
                        ProjectStrings.manage_reports_integrated_apps,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          buildIntegratedApp(
                            "lib/assets/pictures/google_maps_icon.png",
                            ProjectStrings.manage_reports_google_maps,
                            "0xffffffff"
                          ),
                          const SizedBox(width: 15),
                          buildIntegratedApp(
                            "lib/assets/pictures/bottom_nav_bar_antrip.png",
                            ProjectStrings.manage_reports_antrip_iot,
                            ProjectColors.antripIOTColor
                          ),
                        ],
                      ),

                      // Reports Section
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.manage_reports_reports,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          CustomComponents.displayText(
                            ProjectStrings.manage_reports_see_all,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Color(int.parse(ProjectColors.mainColorHex
                                .substring(2),
                                radix: 16)),
                          )
                        ],
                      ),

                      // Main Report List
                      const SizedBox(height: 15),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              height: 90,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(int.parse(ProjectColors
                                                .reportItemBackground
                                                .substring(2),
                                                radix: 16)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: CustomComponents.displayText(
                                              "SR",
                                              color: Color(int.parse(ProjectColors
                                                  .reportPurple.substring(2),
                                                  radix: 16)),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomComponents.displayText(
                                              ProjectStrings
                                                  .manage_reports_sr_title,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            const SizedBox(height: 5),
                                            CustomComponents.displayText(
                                              ProjectStrings
                                                  .manage_reports_sr_report_number,
                                              fontSize: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      "lib/assets/pictures/trash.png",
                                      width: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50)
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

  Widget buildAdminOption(String imagePath, String label) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Color(int.parse(ProjectColors.reportMangeSelectedItem)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(int.parse(ProjectColors.reportManageItemBackground)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(imagePath, width: 30),
              ),
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
