import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import 'package:enhance_stepper/enhance_stepper.dart';

class VehicleInformation extends StatefulWidget {
  const VehicleInformation({super.key});

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  int _currentStep = 0;
  TextEditingController modelController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              //  action bar
              actionBar(),

              //  stepper
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
                        child: CustomComponents.displayText(
                          ProjectStrings.outsource_ap_notice_header,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: CustomComponents.displayText(
                          ProjectStrings.outsource_ap_notice_subheader,
                          fontSize: 10
                        ),
                      ),
                      applicationStepper()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget applicationStepper() {
    return EnhanceStepper(
      currentStep: _currentStep,
      type: StepperType.vertical,
      onStepTapped: (index) {
        setState(() {
          _currentStep = index;
        });
      },
      onStepContinue: () {
        if (_currentStep < 2) {
          setState(() {
            _currentStep++;
          });
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
              onPressed: details.onStepContinue,  // Proceed to the next step
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)), // Custom button color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: ProjectStrings.general_font_family,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),  // Custom border radius
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
                onPressed: details.onStepCancel,  // Go to the previous step
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,  // Custom text color
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: ProjectStrings.general_font_family
                  ),
                ),
              ),
          ],
        );
      },
      steps: <EnhanceStep>[
          EnhanceStep(
            title: const Text(
              ProjectStrings.outsource_vi_model,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: ProjectStrings.general_font_family
              ),
            ),
            content: Column(
              children: [
                _rowItems(ProjectStrings.outsource_vi_model_content, modelController)
              ]
            )
          ),
          EnhanceStep(
            title: const Text(
              ProjectStrings.outsource_vi_brand,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: ProjectStrings.general_font_family
              ),
            ),
            content: Column(
              children: [
                _rowItems(ProjectStrings.outsource_vi_model_content, brandController)
              ]
            )
          ),
          EnhanceStep(
            title: const Text(
              ProjectStrings.outsource_vi_year,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: ProjectStrings.general_font_family
              ),
            ),
            content: Column(
              children: [
                _rowItems(ProjectStrings.outsource_vi_model_content, yearController)
              ]
            )
          ),
          EnhanceStep(
            title: const Text(
              ProjectStrings.outsource_vi_plate,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: ProjectStrings.general_font_family
              ),
            ),
            content: Column(
              children: [
                _rowItems(ProjectStrings.outsource_vi_model_content, plateController)
              ]
            )
          ),
        ],
    );
  }

  Widget _rowItems(String title, TextEditingController controller) {
    return Row(
      children: [
        CustomComponents.displayText(
          title,
          color: controller.value.text.isEmpty ? Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16))
          : Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
          fontSize: 10,
          fontWeight: FontWeight.bold
        ),
        const SizedBox(width: 30),
        SizedBox(
          width: 200,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: ProjectStrings.outsource_ap_not_specified,
              hintStyle: TextStyle(
                color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                fontSize: 10,
                fontFamily: ProjectStrings.general_font_family
              )
            ),
            style: const TextStyle(
              fontFamily: ProjectStrings.general_font_family,
              fontSize: 10
            ),
          ),
        )
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
            ProjectStrings.outsource_vehicle_information,
            fontWeight: FontWeight.bold,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/three_vertical_dots.png"),
          ),
        ],
      ),
    );
  }
}