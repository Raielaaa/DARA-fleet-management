import "package:dara_app/controller/account/register_controller.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/pages/account/register/widgets/terms_and_conditions.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
  String? selectedRole;

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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 600; // Adjust breakpoint if needed

        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: Color(
              int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16),
            ),
            child: SingleChildScrollView(
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
                          width: screenWidth - 20,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
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
                              width: isSmallScreen ? 60.0 : 80.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Main body
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 11 : 19,
                    ),
                    child: Column(
                      children: [
                        // Row 1
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  PersistentData().selectedRoleOnRegister = "Outsource";
                                  Navigator.of(context).pop();
                                },
                                child: _userType(
                                  ProjectStrings.user_type_outsource_title,
                                  ProjectStrings.user_type_outsource_content,
                                  "lib/assets/pictures/user_type_outsource.jpg",
                                  isSmallScreen,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  PersistentData().selectedRoleOnRegister = "Driver";
                                  Navigator.of(context).pop();
                                },
                                child: _userType(
                                  ProjectStrings.user_type_driver_title,
                                  ProjectStrings.user_type_driver_content,
                                  "lib/assets/pictures/user_type_driver.jpeg",
                                  isSmallScreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Row 2
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  PersistentData().selectedRoleOnRegister = "Renter";
                                  Navigator.of(context).pop();
                                },
                                child: _userType(
                                  ProjectStrings.user_type_user_title,
                                  ProjectStrings.user_type_user_body,
                                  "lib/assets/pictures/user_type_user.jpg",
                                  isSmallScreen,
                                ),
                              ),
                            ),
                            const Spacer(), // Align single item to the left
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _userType(String header, String subHeader, String imagePath, bool isSmallScreen) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 + 12,
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
          const SizedBox(height: 20),
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                  ],
                  keyboardType: TextInputType.name,
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
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                  ],
                  keyboardType: TextInputType.text,
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
              GestureDetector(
                onTap: () {
                  //  Display Terms and Conditions ModalBottomSheet
                  showModalBottomSheet<void>(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return termsAndCondition(context, 2);
                      }
                  );
                },
                child: Align(
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("login_main");
                  },
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
                ),
              )
            ],
          )),
    );
  }
}
