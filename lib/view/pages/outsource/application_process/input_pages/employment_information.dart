import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:enhance_stepper/enhance_stepper.dart';

class EmploymentInformation extends StatefulWidget {
  const EmploymentInformation({super.key});

  @override
  State<EmploymentInformation> createState() => _EmploymentInformationState();
}

class _EmploymentInformationState extends State<EmploymentInformation> {
  int _currentStep = 0;
  final List<bool> _isActiveList = [true, false, false]; // Step active state

  //  company details controllers
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  //  contact information controllers
  TextEditingController telephoneNumberController = TextEditingController();

  //  job details controllers
  TextEditingController positionController = TextEditingController();
  TextEditingController lengthOfStayController = TextEditingController();
  TextEditingController monthlySalaryController = TextEditingController();

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
          color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        ),
        const SizedBox(width: 5),
        Image.asset(
          "lib/assets/pictures/oap_employment_selected.png",
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
              companyNameController.value.text.isEmpty ||
              addressController.value.text.isEmpty ||
              telephoneNumberController.value.text.isEmpty ||
              positionController.value.text.isEmpty ||
              lengthOfStayController.value.text.isEmpty ||
              monthlySalaryController.value.text.isEmpty
            ) {
              InfoDialog().show(
                context: context,
                content: ProjectStrings.outsource_dialog_content,
                header: ProjectStrings.outsource_dialog_title
              );
            } else {
              PersistentData _persistentData = PersistentData();
              _persistentData.eiCompanyName = companyNameController.value.text;
              _persistentData.eiAddress = addressController.value.text;
              _persistentData.eiTelephoneNumber = telephoneNumberController.value.text;
              _persistentData.eiPosition = positionController.value.text;
              _persistentData.eiLengthOfStay = lengthOfStayController.value.text;
              _persistentData.eiMonthlySalary = monthlySalaryController.value.text;

              Navigator.of(context).pushNamed("ap_business_information");
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
            ProjectStrings.outsource_ei_company_details,
            [
              ProjectStrings.outsource_ei_company_name,
              ProjectStrings.outsource_ei_address
            ],
            [
              companyNameController,
              addressController
            ],
          ),
          createStep(
            _isActiveList[1],
            ProjectStrings.outsource_ei_contact_information,
            [
              ProjectStrings.outsource_ei_tel_no,
            ],
            [
              telephoneNumberController
            ]
          ),
          createStep(
            _isActiveList[2],
            ProjectStrings.outsource_ei_job_details,
            [
              ProjectStrings.outsource_ei_position,
              ProjectStrings.outsource_ei_length_of_stay,
              ProjectStrings.outsource_ei_monthly_salary
            ],
            [
              positionController,
              lengthOfStayController,
              monthlySalaryController
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
            ProjectStrings.outsource_ei_appbar_title,
            fontWeight: FontWeight.bold,
          ),
          CustomComponents.menuButtons(context),
        ],
      ),
    );
  }
}