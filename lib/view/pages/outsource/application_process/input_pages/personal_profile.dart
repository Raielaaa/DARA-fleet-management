import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:enhance_stepper/enhance_stepper.dart';

class PersonalProfile extends StatefulWidget {
  const PersonalProfile({super.key});

  @override
  State<PersonalProfile> createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  int _currentStep = 0;
  final List<bool> _isActiveList = [true, false, false, false]; // Step active state

  //  personal data controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController placeOfBirthController = TextEditingController();
  TextEditingController citizenshipController = TextEditingController();
  TextEditingController civilStatusController = TextEditingController();
  TextEditingController motherInfoController = TextEditingController();

  //  contact information controllers
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();

  //  residence details controllers
  TextEditingController addressController = TextEditingController();
  TextEditingController yearsStayedController = TextEditingController();
  TextEditingController homeStatusController = TextEditingController();

  //  identification controllers
  TextEditingController tinNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: SafeArea(
          child: Column(
            children: [
              actionBar(),

              // Scrollable content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 25, bottom: 15),
                                child: horizontalIcons()
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                                child: CustomComponents.displayText(
                                  ProjectStrings.outsource_ap_notice_header,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: CustomComponents.displayText(
                                  ProjectStrings.outsource_ap_notice_subheader,
                                  fontSize: 10,
                                ),
                              ),
                              applicationStepper(),
                            ],
                          ),
                        ),
                      ),
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

  Widget horizontalIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "lib/assets/pictures/oap_vehicle_selected.png",
          width: MediaQuery.of(context).size.width / 17,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_profile_selected.png",
          width: MediaQuery.of(context).size.width / 17,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.rowIconLine.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_employment_not_selected.png",
          width: MediaQuery.of(context).size.width / 20,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.rowIconLine.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_business_not_selected.png",
          width: MediaQuery.of(context).size.width / 15,
        ),
        const SizedBox(width: 5),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 13,
          color: Color(int.parse(ProjectColors.rowIconLine.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_documents_not_selected.png",
          width: MediaQuery.of(context).size.width / 20,
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget applicationStepper() {
    return Theme(
      data: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
        )
      ),
      child: EnhanceStepper(
        currentStep: _currentStep,
        type: StepperType.vertical,
        onStepTapped: (index) {
          setState(() {
            _currentStep = index;
          });
        },
        onStepContinue: () {
          if (_currentStep < _isActiveList.length - 1) {
            setState(() {
              _isActiveList[_currentStep] = true; // Mark current step as active
              _currentStep++;
              _isActiveList[_currentStep] = true; // Mark next step as active
            });
          } else {
            if (
              firstNameController.value.text.isEmpty ||
              middleNameController.value.text.isEmpty ||
              lastNameController.value.text.isEmpty ||
              birthdayController.value.text.isEmpty ||
              ageController.value.text.isEmpty ||
              placeOfBirthController.value.text.isEmpty ||
              citizenshipController.value.text.isEmpty ||
              motherInfoController.value.text.isEmpty ||
              civilStatusController.value.text.isEmpty ||
              contactNumberController.value.text.isEmpty ||
              emailAddressController.value.text.isEmpty ||
              addressController.value.text.isEmpty ||
              yearsStayedController.value.text.isEmpty ||
              homeStatusController.value.text.isEmpty ||
              tinNumberController.value.text.isEmpty
            ) {
              InfoDialog().show(
                context: context,
                content: ProjectStrings.outsource_dialog_content,
                header: ProjectStrings.outsource_dialog_title
              );
            } else {
              PersistentData _persistentData = PersistentData();
              _persistentData.ppFirstName = firstNameController.value.text;
              _persistentData.ppMiddleName = middleNameController.value.text;
              _persistentData.ppLastName = lastNameController.value.text;
              _persistentData.ppBirthday = birthdayController.value.text;
              _persistentData.ppAge = ageController.value.text;
              _persistentData.ppBirthPlace = placeOfBirthController.value.text;
              _persistentData.ppCitizenship = citizenshipController.value.text;
              _persistentData.ppCivilStatus = civilStatusController.value.text;
              _persistentData.ppMotherName = motherInfoController.value.text;
              _persistentData.ppContactNumber = contactNumberController.value.text;
              _persistentData.ppEmailAddress = emailAddressController.value.text;
              _persistentData.ppAddress = addressController.value.text;
              _persistentData.ppYearsStayed = yearsStayedController.value.text;
              _persistentData.ppHouseStatus = homeStatusController.value.text;
              _persistentData.ppTinNumber = tinNumberController.value.text;


              Navigator.of(context).pushNamed("ap_employment_information");
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue, // Proceed to the next step
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)), // Custom button color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: ProjectStrings.general_font_family,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Custom border radius
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel, // Go to the previous step
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey, // Custom text color
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: ProjectStrings.general_font_family,
                    ),
                  ),
                ),
            ],
          );
        },
        steps: <EnhanceStep>[
          createStep(
            _isActiveList[0],
            ProjectStrings.outsource_pp_personal_data,
            [
              ProjectStrings.outsource_pp_first_name,
              ProjectStrings.outsource_pp_middle_name,
              ProjectStrings.outsource_pp_last_name,
              ProjectStrings.outsource_pp_birthday,
              ProjectStrings.outsource_pp_age,
              ProjectStrings.outsource_pp_place_of_birth,
              ProjectStrings.outsource_pp_citizenship,
              ProjectStrings.outsource_pp_civil_status,
              ProjectStrings.outsource_pp_mother_info
            ],
            [
              firstNameController,
              middleNameController,
              lastNameController,
              birthdayController,
              ageController,
              placeOfBirthController,
              citizenshipController,
              civilStatusController,
              motherInfoController
            ],
          ),
          createStep(
            _isActiveList[1],
            ProjectStrings.outsource_pp_contact_information,
            [
              ProjectStrings.outsource_pp_contact_number,
              ProjectStrings.outsource_pp_email_address
            ],
            [
              contactNumberController,
              emailAddressController
            ]
          ),
          createStep(
            _isActiveList[2],
            ProjectStrings.outsource_pp_residence_details,
            [
              ProjectStrings.outsource_pp_address,
              ProjectStrings.outsource_pp_years_stayed,
              ProjectStrings.outsource_pp_house_status
            ],
            [
              addressController,
              yearsStayedController,
              homeStatusController
            ],
          ),
          createStep(
            _isActiveList[3],
            ProjectStrings.outsource_pp_identification,
            [
              ProjectStrings.outsource_pp_tin_number
            ],
            [
              tinNumberController
            ],
          ),
        ],
      ),
    );
  }

  // Method to create EnhanceStep
  EnhanceStep createStep(
    bool isActive,
    String title,
    List<String> contentText,
    List<TextEditingController> controller
  ) {
    return EnhanceStep(
      isActive: isActive,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: ProjectStrings.general_font_family,
        ),
      ),
      content: Column(
        children: List.generate(contentText.length, (index) {
          return _rowItems(contentText[index], controller[index]);
        })
      ),
    );
  }

  Widget _rowItems(String title, TextEditingController controller) {
    return Row(
      children: [
        CustomComponents.displayText(
          title,
          color: controller.value.text.isEmpty
              ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16))
              : Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(width: 30),
        Expanded(
          child: SizedBox(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: ProjectStrings.outsource_ap_not_specified,
                hintStyle: TextStyle(
                  color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                  fontSize: 10,
                  fontFamily: ProjectStrings.general_font_family,
                ),
              ),
              style: const TextStyle(
                fontFamily: ProjectStrings.general_font_family,
                fontSize: 10,
              ),
            ),
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
            ProjectStrings.outsource_pp_action_bar,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}