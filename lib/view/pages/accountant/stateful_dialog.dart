import "package:dara_app/view/pages/admin/rent_process/booking_details.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart";
import "package:intl/intl.dart";

class StatefulDateDialog extends StatefulWidget {
  @override
  _StatefulDateDialogState createState() => _StatefulDateDialogState();
}

class _StatefulDateDialogState extends State<StatefulDateDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedCategory = "Owned";

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
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      backgroundColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                "lib/assets/pictures/exit.png",
                width: 20
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomComponents.displayText(
                      ProjectStrings.income_page_edit_select_category,
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                    ),
                    const SizedBox(height: 7),
                    dropdownButton()
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomComponents.displayText(
                      ProjectStrings.income_page_edit_amount,
                      fontSize: 10,
                      fontWeight: FontWeight.bold
                    ),
                    const SizedBox(height: 7),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 70,
                      height: 35,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Background color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5), // Rounded corners
                            borderSide: const BorderSide(
                              color: Color(0xff404040), // Stroke line color
                              width: 1, // Stroke line width
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5), // Rounded corners
                            borderSide: const BorderSide(
                              color: Color(0xff404040), // Stroke line color
                              width: 1, // Stroke line width
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5), // Rounded corners
                            borderSide: const BorderSide(
                              color: Color(0xff404040), // Stroke line color
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
                )
              ],
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
                Container(
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Color(
                    int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                width: 1,
              ),
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

  Widget dropdownButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 70,
      height: 35,
      child: DropdownButtonFormField<String>(
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
