import "package:dara_app/controller/accountant/accountant_controller.dart";
import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/model/renting_proccess/renting_process.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/pages/accountant/income_dialog.dart";
import "package:dara_app/view/pages/accountant/stateful_dialog.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../controller/singleton/persistent_data.dart";

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  String? _selectedMonth = "Grand Total";
  List<RentInformation> _accountantRecordsToBeDisplayed = [];
  List<RentInformation> _retrievedAccountantRecords = [];
  bool _isLoading = true;
  String __totalAmount = "0.0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _retrieveAccountantRecords();
    });
  }

  Future<void> refreshData() async {
    await _retrieveAccountantRecords();
  }

  Future<void> _retrieveAccountantRecords() async {
    try {
      LoadingDialog().show(context: context, content: "Please wait while we retrieve income records.");
      List<RentInformation> accountantRecords = await Firestore().getRentRecords();
      LoadingDialog().dismiss();

      setState(() {
        _retrievedAccountantRecords = accountantRecords;
        _accountantRecordsToBeDisplayed = _retrievedAccountantRecords;
        calculateTotalAmount();
        _isLoading = false;
      });
    } catch(e) {
      LoadingDialog().dismiss();
      debugPrint("Error@income.dart@ln63: $e");
    }
  }

  String formatNumber(dynamic number) {
    // Convert the number to a double first if it's a string
    double parsedNumber = double.tryParse(number.toString()) ?? 0.0;
    return NumberFormat("#,##0.0000", "en_US").format(parsedNumber);
  }

  void _filterRecordsByMonth() {
    if (_selectedMonth == "Grand Total") {
      // Show all records if "Grand Total" is selected
      _accountantRecordsToBeDisplayed = _retrievedAccountantRecords;
    } else {
      _accountantRecordsToBeDisplayed = _retrievedAccountantRecords.where((record) {
        // Parse the month from the rent_endDateTime string (e.g., "October 31, 2024 | 12:00 AM")
        String rentEndDateTime = record.endDateTime;
        String recordMonth = rentEndDateTime.split(" ")[0]; // Extract the month part

        // Compare the extracted month with the selected month
        return recordMonth == _selectedMonth;
      }).toList();
    }
    // Recalculate the total amount based on the filtered list
    calculateTotalAmount();
  }


  void calculateTotalAmount() {
    double _totalAmount = 0.0;

    for (var item in _accountantRecordsToBeDisplayed) {
      try {
        _totalAmount += double.parse(item.totalAmount);
      } catch(e) {
        debugPrint("Error@income.dart@ln75: $e");
      }
    }

    final formatter = NumberFormat("#,##0.0000", "en_US");
    setState(() {
      __totalAmount = formatNumber(_totalAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))))
          : Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              actionBar(),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    refreshData();
                  },
                  child: ListView(
                    padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
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
      itemCount: _accountantRecordsToBeDisplayed.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
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
                      debugPrint("Owner: ${_accountantRecordsToBeDisplayed[index].carOwner.toLowerCase()}");
                      ShowDialog().seeCompleteReportInfo(_accountantRecordsToBeDisplayed[index], context);
                    },
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _accountantRecordsToBeDisplayed[index].carOwner.toLowerCase() == "dats" ?
                              Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16)) :
                              Color(int.parse(ProjectColors.outsourceColorBackground.substring(2), radix: 16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: CustomComponents.displayText(
                              "SR",
                              color: _accountantRecordsToBeDisplayed[index].carOwner.toLowerCase() == "dats" ?
                                Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)) :
                                Color(int.parse(ProjectColors.outsourceColorMain.substring(2), radix: 16)),
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
                              "${_accountantRecordsToBeDisplayed[index].startDateTime} -",
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                            const SizedBox(height: 3),
                            CustomComponents.displayText(
                              _accountantRecordsToBeDisplayed[index].endDateTime,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                            const SizedBox(height: 10),
                            CustomComponents.displayText(
                              "PHP ${formatNumber(_accountantRecordsToBeDisplayed[index].totalAmount)}",
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
                                return StatefulDateDialog(selectedRentInformation: _accountantRecordsToBeDisplayed[index]);
                              }
                            );
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 15),
                        // GestureDetector(
                        //   onTap: () {
                        //     showConfirmDialog();
                        //   },
                        //   child: Image.asset(
                        //     "lib/assets/pictures/trash.png",
                        //     width: 20,
                        //   ),
                        // ),
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
            __totalAmount,
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
            color: Colors.transparent,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
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
        "Grand Total", 'January', 'February', 'March', 'April', 'May', 'June',
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
          _filterRecordsByMonth(); // Filter the records based on the selected month
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