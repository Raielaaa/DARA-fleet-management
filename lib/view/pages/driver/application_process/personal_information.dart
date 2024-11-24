import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/pages/outsource/application_process/agreement_options_dialog.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:enhance_stepper/enhance_stepper.dart';

class DriverPersonalInformation extends StatefulWidget {
  const DriverPersonalInformation({super.key});

  @override
  State<DriverPersonalInformation> createState() => _DriverPersonalInformationState();
}

class _DriverPersonalInformationState extends State<DriverPersonalInformation> {
  int _currentStep = 0;
  final List<bool> _isActiveList = [true, false, false, false]; // Step active state

  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController completeAddressController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController civilStatusController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController fatherBirthPlaceController = TextEditingController();
  TextEditingController motherController = TextEditingController();
  TextEditingController motherBirthPlaceController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

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
          "lib/assets/pictures/dap_emergency_contact_not_selected.png",
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
          "lib/assets/pictures/dap_book_not_selected.png",
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
            birthdayController.value.text.isEmpty ||
                civilStatusController.value.text.isEmpty ||
                completeAddressController.value.text.isEmpty ||
                emailAddressController.value.text.isEmpty ||
                firstNameController.value.text.isEmpty ||
                middleNameController.value.text.isEmpty ||
                lastNameController.value.text.isEmpty ||
                mobileNumberController.value.text.isEmpty ||
                fatherNameController.value.text.isEmpty ||
                fatherBirthPlaceController.value.text.isEmpty ||
                motherController.value.text.isEmpty ||
                motherBirthPlaceController.value.text.isEmpty ||
                religionController.value.text.isEmpty ||
                heightController.value.text.isEmpty ||
                weightController.value.text.isEmpty
            ) {
              InfoDialog().show(
                  context: context,
                  content: ProjectStrings.outsource_dialog_content,
                  header: ProjectStrings.outsource_dialog_title
              );
            } else {
              PersistentData _persistentData = PersistentData();
              _persistentData.dpiFirstName = firstNameController.value.text;
              _persistentData.dpiMiddleName = middleNameController.value.text;
              _persistentData.dpiLastName = lastNameController.value.text;
              _persistentData.dpiBirthday = birthdayController.value.text;
              _persistentData.dpiCivilStatus = civilStatusController.value.text;
              _persistentData.dpiReligion = religionController.value.text;
              _persistentData.dpiCompleteAddress = completeAddressController.value.text;
              _persistentData.dpiMobileNumber = mobileNumberController.value.text;
              _persistentData.dpiEmailAddress = emailAddressController.value.text;
              _persistentData.dpiFatherName = fatherNameController.value.text;
              _persistentData.dpiFatherBirthPlace = fatherBirthPlaceController.value.text;
              _persistentData.dpiMotherName = motherController.value.text;
              _persistentData.dpiMotherBirthplace = motherBirthPlaceController.value.text;
              _persistentData.dpiHeight = heightController.value.text;
              _persistentData.dpiWeight = weightController.value.text;

              Navigator.of(context).pushNamed("driver_ap_emergency_contact");
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
            ProjectStrings.driver_pi_personal_details,
            [
              ProjectStrings.driver_pi_first_name,
              ProjectStrings.driver_pi_middle_name,
              ProjectStrings.driver_pi_last_name,
              ProjectStrings.driver_pi_birthday,
              ProjectStrings.driver_pi_civil_status,
              ProjectStrings.driver_pi_religion
            ],
            [
              firstNameController,
              middleNameController,
              lastNameController,
              birthdayController,
              civilStatusController,
              religionController
            ],
          ),
          createStep(
              _isActiveList[1],
              ProjectStrings.driver_pi_contact_information,
              [
                ProjectStrings.driver_pi_complete_address,
                ProjectStrings.driver_pi_mobile_number,
                ProjectStrings.driver_pi_email_address
              ],
              [
                completeAddressController,
                mobileNumberController,
                emailAddressController
              ]
          ),
          createStep(
            _isActiveList[2],
            ProjectStrings.driver_pi_parental_information,
            [
              ProjectStrings.driver_pi_father_name,
              ProjectStrings.driver_pi_father_birth_place,
              ProjectStrings.driver_pi_mother_name,
              ProjectStrings.driver_pi_mother_birth_place
            ],
            [
              fatherNameController,
              fatherBirthPlaceController,
              motherController,
              motherBirthPlaceController
            ],
          ),
          createStep(
            _isActiveList[3],
            ProjectStrings.driver_pi_physical_attributes,
            [
              ProjectStrings.driver_pi_height,
              ProjectStrings.driver_pi_weight
            ],
            [
              heightController,
              weightController
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
            ProjectStrings.driver_pi_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}