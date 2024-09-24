import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';

class SortFilterDrawer extends StatefulWidget {
  const SortFilterDrawer({super.key});

  @override
  State<SortFilterDrawer> createState() => _SortFilterDrawerState();
}

class _SortFilterDrawerState extends State<SortFilterDrawer> {
  String? _selectedCategory = ProjectStrings.admin_user_nav_drawer_alphabetical;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: Drawer(
        backgroundColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, top: 35, bottom: 35),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              CustomComponents.displayText(
                  ProjectStrings.admin_user_nav_drawer_sort_and_filter,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
              const SizedBox(height: 15),
              _clearOrSave(),
              const SizedBox(height: 30),
              CustomComponents.displayText(
                  ProjectStrings.admin_user_nav_drawer_sort_by,
                  fontSize: 10,
                  fontWeight: FontWeight.bold
                ),
              const SizedBox(height: 10),
              _dropdownButton(),
              const SizedBox(height: 30),
              CustomComponents.displayText(
                ProjectStrings.admin_user_nav_drawer_filter_by,
                fontSize: 10,
                fontWeight: FontWeight.bold
              ),
              const SizedBox(height: 10),
              _userType(),
              const SizedBox(height: 10),
              _verifiedStatus(),
              const SizedBox(height: 10),
              _dateJoined()
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateJoined() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.admin_user_nav_drawer_from,
                fontSize: 10
              ),
            ),
            const SizedBox(height: 10),
            _buildDatePickerColumn(
              _startDate,
              context,
              true
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.admin_user_nav_drawer_to,
                fontSize: 10
              ),
            ),
            const SizedBox(height: 10),
            _buildDatePickerColumn(
              _startDate,
              context,
              true
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerColumn(
    DateTime? date,
    BuildContext context,
    bool isStartDate,
  ) {
    return GestureDetector(
          onTap: () =>
              _selectDate(context, isStartDate), // Show date picker on tap
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Color(
                    int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
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
        );
  }

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

  Widget _verifiedStatus() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.admin_user_nav_drawer_verified_status,
                fontSize: 10
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  verified
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(int.parse(ProjectColors.lightGreen.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Image.asset(
                            "lib/assets/pictures/rentals_verified.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 20,
                            left: 5,
                          ),
                          child: CustomComponents.displayText(
                            ProjectStrings.admin_user_nav_drawer_verified,
                            color: Color(int.parse(ProjectColors.greenButtonMain.substring(2), radix: 16)),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                ),
                const SizedBox(width: 10),
                //  unverified
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Image.asset(
                            "lib/assets/pictures/rentals_denied.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 20,
                            left: 5,
                          ),
                          child: CustomComponents.displayText(
                            ProjectStrings.admin_user_nav_drawer_unverified,
                            color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _userType() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.admin_user_nav_drawer_user_type,
                fontSize: 10
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _rectangularItems(
                  name: ProjectStrings.admin_user_nav_drawer_renter,
                  horizontalPadding: 15,
                  verticalPadding: 10,
                  backgroundColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                  textColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                ),
                const SizedBox(width: 10),
                _rectangularItems(
                  name: ProjectStrings.admin_user_nav_drawer_outsource,
                  horizontalPadding: 15,
                  verticalPadding: 10,
                  backgroundColor: Color(int.parse(ProjectColors.outsourceColorBackground.substring(2), radix: 16)),
                  textColor: Color(int.parse(ProjectColors.outsourceColorMain.substring(2), radix: 16))
                ),
                const SizedBox(width: 10),
                _rectangularItems(
                  name: ProjectStrings.admin_user_nav_drawer_driver,
                  horizontalPadding: 15,
                  verticalPadding: 10,
                  backgroundColor: Color(int.parse(ProjectColors.userListDriverHexBackground.substring(2), radix: 16)),
                  textColor: Color(int.parse(ProjectColors.userListDriverHex.substring(2), radix: 16))
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _dropdownButton() {
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
        fontSize: 10,
        fontFamily: ProjectStrings.general_font_family, // Replace with actual font family if needed
        color: Color(0xff404040),
      ),
      hint: const Text('Select Month'),
      value: _selectedCategory,
      isExpanded: true,
      items: <String>[
        ProjectStrings.admin_user_nav_drawer_alphabetical,
        ProjectStrings.admin_user_nav_drawer_date_created
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
    );
  }

  Widget _clearOrSave() {
    return Row(children: [
      _rectangularItems(
          name: ProjectStrings.admin_user_nav_drawer_clear_all,
          horizontalPadding: 35,
          verticalPadding: 15,
          backgroundColor: Colors.white,
          textColor: const Color(0xff404040)),
      const SizedBox(width: 20),
      _rectangularItems(
          name: ProjectStrings.admin_user_nav_drawer_apply,
          horizontalPadding: 35,
          verticalPadding: 15,
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          textColor: Color(
              int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)))
    ]);
  }

  Widget _rectangularItems(
      {required String name,
      required double horizontalPadding,
      required double verticalPadding,
      required Color backgroundColor,
      required Color textColor}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: backgroundColor),
      child: Padding(
        padding: EdgeInsets.only(
            left: horizontalPadding,
            right: horizontalPadding,
            top: verticalPadding,
            bottom: verticalPadding),
        child: CustomComponents.displayText(name,
            fontWeight: FontWeight.bold, fontSize: 10, color: textColor),
      ),
    );
  }
}
