import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime? _selectedDate; // State for storing selected date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showRoundedDatePicker(
      context: context,
      height: 400,
      theme: ThemeData(
        primaryColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16))
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
          ),
        ),
      ),
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      borderRadius: 16,
    )) ?? DateTime.now();

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: ListView(
          children: [
            Container(
              //  Back button
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "account_opening_page");
                },
                icon: const Icon(Icons.arrow_back),
                iconSize: 25.0, // desired size
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(), // override default min size of 48px
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            //  Text header
            const SizedBox(height: 30),
            CustomComponents.displayText(
              ProjectStrings.account_register_1_header,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
            ),

            //  Text subheader
            const SizedBox(height: 10),
            CustomComponents.displayText(
              ProjectStrings.account_register_1_subheader,
              fontSize: 18,
              color: Colors.grey
            ),

            //  First name
            const SizedBox(height: 40),
            CustomComponents.displayText(
              ProjectStrings.account_register_1_firstname,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_1_firstname_hint,
              isFocused: true
            ),

            //  Last name
            CustomComponents.displayText(
              ProjectStrings.account_register_1_lastname,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(ProjectStrings.account_register_1_lastname_hint),

            //  Birthday
            CustomComponents.displayText(
              ProjectStrings.account_register_1_birthday,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDate(context), // Show date picker on tap
              child: AbsorbPointer(
                child: CustomComponents.displayTextField(
                  _selectedDate != null ? _selectedDate.toString() : ProjectStrings.account_register_1_birthday_hint,
                ),
              ),
            ),

            //  Condition
            const SizedBox(height: 20),
            CustomComponents.displayText(
              ProjectStrings.account_register_1_condition,
              textAlign: TextAlign.justify,
              color: Colors.grey,
              fontSize: 14
            ),

            //  Button
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: CustomComponents.displayElevatedButton(
                "Next",
                onPressed: () {},
              ),
            ),
          ],
        )
      ),
    );
  }
}