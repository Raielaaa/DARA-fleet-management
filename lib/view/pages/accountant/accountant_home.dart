import "package:dara_app/view/pages/accountant/income_dialog.dart";
import "package:dara_app/view/pages/accountant/stateful_dialog.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

import "../../../controller/singleton/persistent_data.dart";
import "../../../controller/utils/intent_utils.dart";

class AccountantOption extends StatefulWidget {
  const AccountantOption({super.key});

  @override
  State<AccountantOption> createState() => _AccountantOptionState();
}

class _AccountantOptionState extends State<AccountantOption> {
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
                      accountingOptions(),
                      const SizedBox(height: 30),
                      integratedApps(),
                      const SizedBox(height: 30),
                      // incomeListHeader(),
                      // const SizedBox(height: 15),
                      // mainReportSection(),
                      // const SizedBox(height: 50)
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerRight,
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
                      // ShowDialog().seeCompleteReportInfo(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(
                              int.parse(
                                ProjectColors.reportMainColorBackground.substring(2),
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
                                  ProjectColors.mainColorHex.substring(2),
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
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return StatefulDateDialog();
                            //   }
                            // );
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
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
            GestureDetector(
              onTap: () async {
                await IntentUtils.launchGoogleMaps();
              },
              child: buildIntegratedApp(
                "lib/assets/pictures/google_maps_icon.png",
                ProjectStrings.manage_reports_google_maps,
                "0xffffffff",
              ),
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
  Widget accountingOptions() {
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
                ProjectStrings.manage_accountant_options,
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
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("to_income_accountant");
                  },
                  child: buildAdminOption(
                    "lib/assets/pictures/accountant_income.png",
                    ProjectStrings.manage_accountant_manage_options_income,
                    Colors.white,
                  ),
                ),
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
                ProjectStrings.manage_accountant_greetings,
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
            ProjectStrings.income_page_appbar_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}
