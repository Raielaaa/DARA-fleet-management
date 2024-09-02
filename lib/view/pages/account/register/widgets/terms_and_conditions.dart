import "package:dara_app/controller/account/register_controller.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/services/firebase/auth.dart";
import "package:dara_app/view/pages/account/register/register_email_pass.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:simple_loading_dialog/simple_loading_dialog.dart";

Widget makeDismissible({
  required BuildContext context,
  required Widget child
}) => GestureDetector(
  behavior: HitTestBehavior.opaque,
  onTap: () => Navigator.of(context).pop(),
  child: GestureDetector(onTap: () {}, child: child),
);

Widget termsAndCondition(BuildContext context, int code) => makeDismissible(
  context: context,
  child: DraggableScrollableSheet(
    minChildSize: 0.45,
    initialChildSize: 0.6,
    builder: (_, controller) => Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20)
        )
      ),
      child: ListView(
        controller: controller,
        children: [
          //  Horizontal divider
          UnconstrainedBox(
            child: Container(
              width: 50,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50)
              ),
            ),
          ),
    
          //  Main header
          const SizedBox(height: 30),
          UnconstrainedBox(
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_main,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
    
          //  Main sub header
          const SizedBox(height: 15),
          CustomComponents.displayText(
            ProjectStrings.terms_and_conditions_subheader_main,
            fontSize: 10,
            textAlign: TextAlign.justify
          ),
    
          //  First TaC
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_1,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    
          //  First TaC_1
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_1_content_1,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  First TaC_2
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_1_content_2,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  First TaC_3
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_hedear_1_content_3,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  First TaC_4
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_1_content_4,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  First TaC_5
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_1_content_5,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  Second TaC
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_2,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    
          //  Second TaC_1
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_2_content_1,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  Second TaC_2
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_2_content_2,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  Second TaC_3
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_2_content_3,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  Second TaC_4
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_2_content_4,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  Second TaC_5
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_2_content_5,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),
    
          //  Third TaC
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_3,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    
          //  Third TaC_1
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_3_content_1,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Fourth TaC
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_4,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    
          //  Fourth TaC_1
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_4_content_1,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Fifth TaC
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_5,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    
          //  Fifth TaC_1
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_5_content_1,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Fifth TaC_2
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_5_content_2,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
    
          //  Sixth TaC_1
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_1,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_2
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_2,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_3
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_3,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_4
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_4,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_5
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_5,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_6
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_6,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_7
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_7,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          //  Sixth TaC_8
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: CustomComponents.displayText(
              ProjectStrings.terms_and_conditions_header_6_content_8,
              fontSize: 10,
              textAlign: TextAlign.justify
            ),
          ),

          const SizedBox(height: 50),

          //  Accept and Decline button
          UnconstrainedBox(
            child: Row(
              children: [
                //  Decline button
                CustomComponents.displayElevatedButton(
                  ProjectStrings.terms_and_conditions_decline_button,
                  buttonColor: Colors.white70,
                  textColor: Colors.grey,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }
                ),

                //  Accept button
                const SizedBox(width: 40),
                CustomComponents.displayElevatedButton(
                  ProjectStrings.terms_and_conditions_accept_button,
                  onPressed: () {
                    if (code == 1) {
                      RegisterController().insertCredentialsAndUserDetailesToDB(context: context);
                    } else if (code == 2) {
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          )
        ],
      )
    ),
  ),
);
