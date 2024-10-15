import "package:dara_app/view/pages/accountant/income_dialog.dart";
import "package:dara_app/view/pages/accountant/stateful_dialog.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class OutsourceManage extends StatefulWidget {
  const OutsourceManage({super.key});

  @override
  State<OutsourceManage> createState() => _OutsourceManageState();
}

class _OutsourceManageState extends State<OutsourceManage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              //  action bar
              actionBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      greetingsHeader(),
                      const SizedBox(height: 20),
                      outsourceOptions(),
                      const SizedBox(height: 30),
                      integratedApps(),
                      const SizedBox(height: 30),
                      incomeListHeader(),
                      const SizedBox(height: 15),
                      mainReportSection(),
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

  Future<void> _accessDenied() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        "lib/assets/pictures/exit.png",
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
                child: Image.asset(
                  "lib/assets/pictures/access_denied.webp",
                  width: double.infinity,
                  height: 200,
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomComponents.displayText(
                  ProjectStrings.manage_access_denied_header,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: CustomComponents.displayText(
                  ProjectStrings.manage_access_denied_content,
                  fontSize: 10,
                  textAlign: TextAlign.center
                ),
              ),
              const SizedBox(height: 60)
            ],
          ),
        );
      }
    );
  }

  //  Main report section
  Widget mainReportSection() {
    return ListView.builder(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ShowDialog().seeCompleteReportInfo(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(
                              int.parse(
                                ProjectColors.userListOutsourceHexBackground.substring(2),
                                radix: 16,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: CustomComponents.displayText(
                              "SR",
                              color: Color(
                                int.parse(
                                  ProjectColors.userListOutsourceHex.substring(2),
                                  radix: 16,
                                ),
                              ),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.manage_accountant_date_range,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            const SizedBox(height: 5),
                            CustomComponents.displayText(
                              ProjectStrings.manage_accountant_amount,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showConfirmDialog();
                          },
                          child: Image.asset(
                            "lib/assets/pictures/trash.png",
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showConfirmDialog() {
    InfoDialog().showDecoratedTwoOptionsDialog(
      context: context,
      content: ProjectStrings.income_page_confirm_delete_content,
      header: ProjectStrings.income_page_confirm_delete
    );
  }

  // Reports Section
  Widget incomeListHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomComponents.displayText(
          ProjectStrings.manage_reports_reports,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed("to_income_accountant");
          },
          child: CustomComponents.displayText(
            ProjectStrings.manage_reports_see_all,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 10,
            color: Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
          ),
        )
      ],
    );
  }

  Widget integratedApps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              "0xffffffff",
            ),
            const SizedBox(width: 15),
            GestureDetector(
              onTap: () {
                _accessDenied();
              },
              child: buildIntegratedApp(
                "lib/assets/pictures/bottom_nav_bar_antrip.png",
                ProjectStrings.manage_reports_antrip_iot,
                ProjectColors.antripIOTColor,
              ),
            ),
          ],
        ),
      ],
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

  // Accounting Options
  Widget outsourceOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.outsource_options,
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
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  income
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("accounting_outsource");
                  },
                  child: buildAdminOption(
                    "lib/assets/pictures/accountant_income.png",
                    ProjectStrings.manage_accountant_manage_options_income,
                    Colors.white,
                  ),
                ),
                //  inquiries
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("inquiries_outsource");
                  },
                  child: buildAdminOption(
                    "lib/assets/pictures/manage_report_inquiries.png",
                    ProjectStrings.outsource_report_inquiries,
                    Colors.white,
                  ),
                ),
                //  car status
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("manage_car_status");
                  },
                  child: buildAdminOption(
                    "lib/assets/pictures/manage_report_car_status.png",
                    ProjectStrings.manage_reports_car_status,
                    Colors.white,
                  ),
                ),
                //  apply
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _showInformationDialog(context);
                  },
                  child: buildAdminOption(
                    "lib/assets/pictures/apply.png",
                    ProjectStrings.outsource_report_apply,
                    Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdminOption(String imagePath, String label, Color itemBgColor) {
    return Container(
      width: 70,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: itemBgColor,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(int.parse(ProjectColors.reportManageItemBackground)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(imagePath, width: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: CustomComponents.displayText(
              label,
              fontSize: 10
            ),
          ),
        ],
      ),
    );
  }

  // Greeting, date, and user picture
  Widget greetingsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomComponents.displayText(
                ProjectStrings.outsource_hello_outsource,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              const SizedBox(height: 3),
              CustomComponents.displayText(
                ProjectStrings.manage_reports_date,
                fontSize: 10,
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
    );
  }

  Widget actionBar() {
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
            ProjectStrings.outsource_action_bar_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }

  //  information dialog metadata
  int _informationDialogCurrentIndex = 0;
  final List<Map<String, String>> guides = [
    {
      "title": ProjectStrings.outsource_apply_title_1,
      "content": ProjectStrings.outsource_apply_content_1
    },
    {
      "title": ProjectStrings.outsource_apply_title_2,
      "content": ProjectStrings.outsource_apply_content_2
    },
    {
      "title": ProjectStrings.outsource_apply_title_3,
      "content": ProjectStrings.outsource_apply_content_3
    },
    {
      "title": ProjectStrings.outsource_apply_title_4,
      "content": ProjectStrings.outsource_apply_content_4
    },
    {
      "title": ProjectStrings.outsource_apply_title_5,
      "content": ProjectStrings.outsource_apply_content_5
    },
  ];

  void _showInformationDialog(BuildContext contextParent) {
    showDialog(
      context: contextParent,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Image.asset(
                          "lib/assets/pictures/exit.png",
                          width: 30,
                        ),
                      ),
                    ),
                    //  left arrow - main image - right arrow
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_informationDialogCurrentIndex > 0) {
                                _informationDialogCurrentIndex--;
                              }
                            });
                          },
                          child: Image.asset(
                            "lib/assets/pictures/id_left_arrow.png",
                            width: 30,
                          ),
                        ),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                            child: KeyedSubtree(
                              key:
                                  ValueKey<int>(_informationDialogCurrentIndex),
                              child: Image.asset(
                                  "lib/assets/pictures/information_dialog.png"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_informationDialogCurrentIndex <
                                  guides.length - 1) {
                                _informationDialogCurrentIndex++;
                              } else {
                                Navigator.of(contextParent).pushNamed("ap_vehicle_information");
                                Navigator.of(context).pop();
                              }
                            });
                          },
                          child: Image.asset(
                              "lib/assets/pictures/id_right_arrow.png",
                              width: 30),
                        ),
                      ],
                    ),
                    //  indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(guides.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _informationDialogCurrentIndex == index
                                ? Color(int.parse(
                                    ProjectColors.mainColorHex.substring(2),
                                    radix: 16))
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    //  title
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key: ValueKey<int>(_informationDialogCurrentIndex),
                          child: CustomComponents.displayText(
                            guides[_informationDialogCurrentIndex]["title"]!,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    //  content
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                        child: KeyedSubtree(
                          key:
                              ValueKey<int>(_informationDialogCurrentIndex + 1),
                          child: CustomComponents.displayText(
                            textAlign: TextAlign.center,
                            guides[_informationDialogCurrentIndex]["content"]!,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    //  spacer
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}