import "package:dara_app/view/pages/accountant/income_dialog.dart";
import "package:dara_app/view/pages/accountant/stateful_dialog.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  String? _selectedMonth = "January";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              actionBar(),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
                  child: Column(
                    children: [
                      //  greetings header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.income_page_header,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.income_page_subheader,
                          fontSize: 10,
                          textAlign: TextAlign.start,
                        ),
                      ),

                      const SizedBox(height: 20),
                      dropdownButton(),
                      const SizedBox(height: 20),
                      totalAmount(),
                      const SizedBox(height: 30),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.income_page_breakdown,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 3),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomComponents.displayText(
                          ProjectStrings.income_page_breakdown_subheader,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 30),
                      itemsLegend(),
                      const SizedBox(height: 20),
                      mainReportSection(),
                      const SizedBox(height: 50)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulDateDialog();
                              }
                            );
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

  Widget itemsLegend() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color(int.parse(ProjectColors.outsourceColorMain.substring(2), radix: 16)),
            borderRadius: BorderRadius.circular(5)
          ),
        ),
        const SizedBox(width: 10),
        CustomComponents.displayText(
          ProjectStrings.income_page_outsource,
          fontSize: 10
        ),

        const SizedBox(width: 30),

        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
            borderRadius: BorderRadius.circular(5)
          ),
        ),
        const SizedBox(width: 10),
        CustomComponents.displayText(
          ProjectStrings.income_page_owned,
          fontSize: 10
        ),
      ],
    );
  }

  Widget totalAmount() {
    return Container(
      padding: const EdgeInsets.all(25),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomComponents.displayText(
            ProjectStrings.income_page_php,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
          const SizedBox(height: 5),
          CustomComponents.displayText(
            ProjectStrings.income_page_amount,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22
          )
        ],
      ),
    );
  }

  Widget dropdownButton() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xff404040),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xff404040),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xff404040),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0), // Adjusted padding
      ),
      style: const TextStyle(
        fontSize: 12,
        fontFamily: ProjectStrings.general_font_family, // Replace with actual font family if needed
        color: Color(0xff404040),
        fontWeight: FontWeight.bold,
      ),
      hint: const Text('Select Month'),
      value: _selectedMonth,
      isExpanded: true,
      items: <String>[
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ].map(
        (String month) {
          return DropdownMenuItem<String>(
            value: month,
            child: Text(month),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          _selectedMonth = value;
        });
      },
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
            ProjectStrings.income_page_appbar_title,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/three_vertical_dots.png"),
          ),
        ],
      ),
    );
  }
}