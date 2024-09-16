import "package:dara_app/controller/account/register_controller.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import "package:intl/intl.dart";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  DateTime? _selectedDate; // State for storing selected date

  // user type dialog
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUserOptionsDialog();
    });
  }

  Future<void> _showUserOptionsDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top design
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      child: Image.asset(
                        "lib/assets/pictures/header_background_curves.png",
                        width: MediaQuery.of(context).size.width - 10,
                        height: 70, // Adjust height as needed
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 15, left: 15, top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomComponents.displayText(
                            ProjectStrings.user_type_dialog_title,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          Image.asset(
                            "lib/assets/pictures/app_logo_circle.png",
                            width: 80.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //  main body
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _userType(
                        ProjectStrings.user_type_outsource_title,
                        ProjectStrings.user_type_outsource_content,
                        "lib/assets/pictures/user_type_outsource.jpg"),
                    const SizedBox(width: 10),
                    _userType(
                        ProjectStrings.user_type_driver_title,
                        ProjectStrings.user_type_driver_content,
                        "lib/assets/pictures/user_type_driver.jpeg"),
                  ],
                ),
                const SizedBox(height: 10),
                _userType(
                    ProjectStrings.user_type_user_title,
                    ProjectStrings.user_type_user_body,
                    "lib/assets/pictures/user_type_user.jpg"),

                const SizedBox(height: 30)
              ],
            ),
          );
        });
  }

  Widget _userType(String header, String subHeader, String imagePath) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: Image.asset(
              imagePath,
              height: 60,
              width: double.infinity, // Expand image to full width
              fit: BoxFit.cover, // Cover the entire width of the container
            ),
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                header,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                subHeader,
                fontSize: 8,
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showRoundedDatePicker(
          context: context,
          height: 400,
          theme: ThemeData(
            primaryColor: Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
            colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: Color(int.parse(
                    ProjectColors.mainColorHex.substring(2),
                    radix: 16)),
                onPrimary: Colors.white,
                secondary: Colors.white,
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.red,
                background: Colors.white,
                onBackground: Colors.white,
                surface: Colors.white,
                onSurface: Color(int.parse(ProjectColors.blackBody.substring(2),
                    radix: 16))),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(int.parse(
                    ProjectColors.mainColorHex.substring(2),
                    radix: 16))),
              ),
            ),
          ),
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 100),
          lastDate: DateTime.now(),
          borderRadius: 16,
        )) ??
        DateTime.now();

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text =
            DateFormat("MMMM dd, yyyy").format(_selectedDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          padding: const EdgeInsets.all(25),
          color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
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
                  constraints:
                      const BoxConstraints(), // override default min size of 48px
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
                fontSize: 22,
                color: Color(
                    int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
              ),

              //  Text subheader
              const SizedBox(height: 5),
              CustomComponents.displayText(
                  ProjectStrings.account_register_1_subheader,
                  fontSize: 12
                  ),

              //  First name
              const SizedBox(height: 40),
              CustomComponents.displayText(
                  ProjectStrings.account_register_1_firstname,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(ProjectColors.blackHeader.substring(2),
                      radix: 16))),
              const SizedBox(height: 10),
              CustomComponents.displayTextField(
                  ProjectStrings.account_register_1_firstname_hint,
                  labelColor: Color(int.parse(
                      ProjectColors.lightGray.substring(2),
                      radix: 16)),
                  isFocused: true,
                  controller: _firstNameController),

              //  Last name
              CustomComponents.displayText(
                  ProjectStrings.account_register_1_lastname,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(ProjectColors.darkGray.substring(2),
                      radix: 16))),
              const SizedBox(height: 10),
              CustomComponents.displayTextField(
                  ProjectStrings.account_register_1_lastname_hint,
                  controller: _lastNameController,
                  labelColor: Color(int.parse(
                      ProjectColors.lightGray.substring(2),
                      radix: 16))),

              //  Birthday
              CustomComponents.displayText(
                  ProjectStrings.account_register_1_birthday,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse(ProjectColors.darkGray.substring(2),
                      radix: 16))),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context), // Show date picker on tap
                child: AbsorbPointer(
                  child: CustomComponents.displayTextField(
                      ProjectStrings.account_register_1_birthday_hint,
                      controller: _birthdayController),
                ),
              ),

              //  Condition
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: ProjectStrings.account_register_1_condition_1,
                      style: TextStyle(
                          fontSize: 10,
                          color: Color(0xff08080a),
                          fontFamily: ProjectStrings.general_font_family),
                      children: <TextSpan>[
                        TextSpan(
                            text: ProjectStrings.account_register_1_condition_2,
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff3FA2BE),
                                fontFamily:
                                    ProjectStrings.general_font_family)),
                        TextSpan(
                            text: ProjectStrings.account_register_1_condition_3,
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff08080a),
                                fontFamily:
                                    ProjectStrings.general_font_family)),
                        TextSpan(
                            text: ProjectStrings.account_register_1_condition_4,
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xff3FA2BE),
                                fontFamily: ProjectStrings.general_font_family))
                      ]),
                ),
              ),

              //  Button - next
              const SizedBox(height: 120),
              SizedBox(
                width: double.infinity,
                child: CustomComponents.displayElevatedButton(
                  ProjectStrings.general_next_button,
                  fontSize: 12,
                  onPressed: () {
                    //  Validates inputted entries
                    RegisterController().validateInputs(
                        context: context,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        birthday: _birthdayController.text);
                  },
                ),
              ),

              //  TextView - Already have an account
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: RichText(
                    text: const TextSpan(
                        text: ProjectStrings
                            .account_register_ep_have_an_account_1,
                        style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff08080a),
                            fontFamily: ProjectStrings.general_font_family),
                        children: <TextSpan>[
                      TextSpan(
                          text: ProjectStrings
                              .account_register_ep_have_an_account_2,
                          style: TextStyle(
                              fontFamily: ProjectStrings.general_font_family,
                              color: Color(0xff3FA2BE),
                              fontWeight: FontWeight.w600,
                              fontSize: 10))
                    ])),
              )
            ],
          )),
    );
  }
}
