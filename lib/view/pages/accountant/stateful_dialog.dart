import "package:dara_app/controller/accountant/accountant_controller.dart";
import "package:dara_app/view/pages/admin/rent_process/booking_details.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:day_night_time_picker/lib/constants.dart";
import "package:day_night_time_picker/lib/daynight_timepicker.dart";
import "package:day_night_time_picker/lib/state/time.dart";
import "package:flutter/material.dart";
import "package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart";
import "package:intl/intl.dart";

import "../../../model/renting_proccess/renting_process.dart";

class StatefulDateDialog extends StatefulWidget {
  final RentInformation selectedRentInformation;

  // Constructor with required parameter
  const StatefulDateDialog({
    Key? key,
    required this.selectedRentInformation,
  }) : super(key: key);

  @override
  _StatefulDateDialogState createState() => _StatefulDateDialogState();
}

class _StatefulDateDialogState extends State<StatefulDateDialog> {
  DateTime? _startDate;
  DateTime? _endDate;

  String _startTime = "";
  String _endTime = "";
  String? _selectedCategory = "Owned";
  final TextEditingController _amountController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showRoundedDatePicker(
      context: context,
      height: 400,
      theme: ThemeData(
        primaryColor: Color(
            int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(
              int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface:
              Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
          ),
        ),
      ),
      initialDate: DateTime.now(),
      borderRadius: 16,
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    Time _time = Time(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: (newTime) {
          setState(() {
            final now = DateTime.now();
            final pickedTime = DateTime(now.year, now.month, now.day, newTime.hour, newTime.minute);

            setState(() {
              if (isStartTime) {
                _startTime = DateFormat("hh:mm a").format(pickedTime);
              } else {
                _endTime = DateFormat("hh:mm a").format(pickedTime);
              }
            });
          });
        },
        sunrise: const TimeOfDay(hour: 6, minute: 0), // optional
        sunset: const TimeOfDay(hour: 18, minute: 0), // optional
        minuteInterval: TimePickerInterval.FIVE, // optional
        iosStylePicker: true, // Enable iOS-style picker
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  "lib/assets/pictures/exit.png",
                  width: 20
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.income_page_edit_header,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.income_page_edit_subheader,
                fontSize: 10
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateTimePickerColumn(
                  _startDate,
                  "Start Date",
                  context,
                  true,
                ),
                _buildDateTimePickerColumn(
                  _endDate,
                  "End Date",
                  context,
                  false,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimePickerColumn(
                  _startTime,
                  "Start Time",
                  context,
                  true,
                ),
                _buildTimePickerColumn(
                  _endTime,
                  "End Time",
                  context,
                  false,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomComponents.displayText(
                    ProjectStrings.income_page_edit_amount,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    height: 35,
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)), // Background color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                          borderSide: BorderSide(
                            color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)), // Stroke line color
                            width: 1, // Stroke line width
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                          borderSide: BorderSide(
                            color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)), // Stroke line color
                            width: 1, // Stroke line width
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5), // Rounded corners
                          borderSide: BorderSide(
                            color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)), // Stroke line color
                            width: 1, // Stroke line width
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: ProjectStrings.general_font_family, // Replace with actual font family if needed
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 50),
            SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(int.parse(
                            ProjectColors.confirmActionCancelBackground
                                .substring(2),
                            radix: 16))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 40, left: 40),
                      child: CustomComponents.displayText(
                          ProjectStrings.income_page_edit_cancel,
                          color: Color(int.parse(
                              ProjectColors.confirmActionCancelMain
                                  .substring(2),
                              radix: 16)),
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    InfoDialog().showWithCancelProceedButton(
                      context: context,
                      content: "Are you sure you wish to proceed? This action cannot be undone.",
                      header: "Confirmation Required",
                      actionCode: 1,
                      onProceed: () async {
                        InfoDialog().dismiss();
                        LoadingDialog().show(context: context, content: "Updating records. Please wait while the process completes.");
                        await AccountantController().updateRentRecords(
                          selectedRentInformation: widget.selectedRentInformation,
                          newStartDate: _startDate != null ? DateFormat("MMMM dd, yyyy").format(_startDate!) : null,
                          newEndDate: _endDate != null ? DateFormat("MMMM dd, yyyy").format(_endDate!) : null,
                          newStartTime: _startTime.isEmpty ? null : _startTime,
                          newEndTime: _endTime.isEmpty ? null : _endTime,
                          newAmount: _amountController.value.text.isNotEmpty ? _amountController.value.text : null
                        );
                        LoadingDialog().dismiss();
                      }
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(int.parse(
                            ProjectColors.redButtonBackground.substring(2),
                            radix: 16))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 40, left: 40),
                      child: CustomComponents.displayText(
                          ProjectStrings.income_page_edit_save_changes,
                          color: Color(int.parse(
                              ProjectColors.redButtonMain.substring(2),
                              radix: 16)),
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePickerColumn(
    DateTime? date,
    String headerName,
    BuildContext context,
    bool isStartDate,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomComponents.displayText(
          headerName,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () =>
              _selectDate(context, isStartDate), // Show date picker on tap
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 70,
            height: 35,
            decoration: BoxDecoration(
              color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                  child: Icon(
                    Icons.calendar_month,
                    color: Color(int.parse(ProjectColors.darkGray.substring(2),
                        radix: 16)),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                CustomComponents.displayText(
                  date != null ? DateFormat('MMMM dd, yyyy').format(date) : 'Not Selected',
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerColumn(
      String _endOrStartTime,
      String headerName,
      BuildContext context,
      bool isStartTime,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomComponents.displayText(
          headerName,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () =>
              _selectTime(context, isStartTime), // Show date picker on tap
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 70,
            height: 35,
            decoration: BoxDecoration(
                color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                  child: Icon(
                    Icons.calendar_month,
                    color: Color(int.parse(ProjectColors.darkGray.substring(2),
                        radix: 16)),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                CustomComponents.displayText(
                  _endOrStartTime.isEmpty ? "Not Selected" : _endOrStartTime,
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget dropdownButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 70,
      height: 35,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15.0), // Adjusted padding
        ),
        style: const TextStyle(
          fontSize: 10,
          fontFamily: ProjectStrings.general_font_family, // Replace with actual font family if needed
          color: Color(0xff404040),
          fontWeight: FontWeight.bold,
        ),
        hint: const Text("Select Month"),
        value: _selectedCategory,
        isExpanded: true,
        items: <String>[
          "Owned", "Outsource"
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
            _selectedCategory = value;
          });
        },
      ),
    );
  }
}
