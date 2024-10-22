import "dart:ui";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "../../../../controller/singleton/persistent_data.dart";

class AgreementOptionsDialog extends StatefulWidget {
  final BuildContext parentContext;

  const AgreementOptionsDialog({required this.parentContext, super.key});

  @override
  State<AgreementOptionsDialog> createState() => _AgreementOptionsDialogState();
}

class _AgreementOptionsDialogState extends State<AgreementOptionsDialog> {
  int? selectedOption; // Variable to track the selected checkbox
  String selectedOptionString = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)),
      backgroundColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //  Top design
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5)),
                child: Image.asset(
                  "lib/assets/pictures/header_background_curves.png",
                  width: MediaQuery.of(context).size.width - 10,
                  height: 70, // Adjust height as needed
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomComponents.displayText(
                      ProjectStrings.outsource_rental_agreement_dialog_title,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    Image.asset(
                      "lib/assets/pictures/app_logo_circle.png",
                      width: 80.0,
                    )
                  ],
                ),
              )
            ],
          ),

          //  main content
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  //  main panel numbered header
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(
                                    int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                                border: Border.all(
                                    color: Color(int.parse(ProjectColors.lineGray)),
                                    width: 1)),
                            child: Center(
                              child: CustomComponents.displayText(
                                ProjectStrings.outsource_dialog_number,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          // Use Expanded only if the parent widget has constraints
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomComponents.displayText(
                                ProjectStrings.outsource_dialog_title_1,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 5),
                              CustomComponents.displayText(
                                ProjectStrings.outsource_dialog_subtitle,
                                fontSize: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //  divider
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                  ),

                  //  checkbox items
                  const SizedBox(height: 10),
                  displayRadioOption(
                    ProjectStrings.outsource_dialog_short_term_agreement,
                    0, // Index for the first option
                  ),
                  displayRadioOption(
                    ProjectStrings.outsource_dialog_long_term_agreement,
                    1, // Index for the second option
                  ),
                  displayRadioOption(
                    ProjectStrings.outsource_dialog_willing_to_sell,
                    2, // Index for the third option
                  ),
                  displayRadioOption(
                    ProjectStrings.outsource_dialog_for_pull_out_of_unit,
                    3, // Index for the fourth option
                  ),
                  const SizedBox(height: 50),
                  proceedButton(ProjectStrings.outsource_dialog_proceed, widget.parentContext),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget proceedButton(String buttonText, BuildContext parentContext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Save the selected option if needed
          PersistentData().rentalAgreementOptions = selectedOptionString;
          Navigator.of(parentContext).pushNamed("ap_document_submission");
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            Color(int.parse(
              ProjectColors.mainColorHex.substring(2),
              radix: 16,
            )),
          ),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CustomComponents.displayText(
            buttonText,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget displayRadioOption(String textContent, int optionIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.8,
            child: Radio<int>(
              value: optionIndex,
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  selectedOptionString = textContent;
                });
              },
              activeColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            textContent,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: ProjectStrings.general_font_family,
              color: Color(0xff404040),
            ),
          ),
        ],
      ),
    );
  }
}