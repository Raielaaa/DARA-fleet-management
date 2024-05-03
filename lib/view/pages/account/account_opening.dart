// ignore_for_file: non_constant_identifier_names

import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:dara_app/view/shared/components.dart";
import "package:flutter/widgets.dart";

class AccountOpening extends StatelessWidget {
  const AccountOpening({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Image.asset("lib/assets/pictures/app_logo_name.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Image.asset("lib/assets/pictures/account_intro.png"),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomComponents.displayText(
              ProjectStrings.account_opening_header,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: const Color.fromARGB(210, 0, 0, 0)
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.account_opening_body,
                color: const Color.fromARGB(200, 0, 0, 0)
              )
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                ),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7)
                  )
                )
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomComponents.displayText(
                  ProjectStrings.account_sign_in_button_text,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                  Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16))
                ),
                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  )
                )
              ),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomComponents.displayText(
                  ProjectStrings.account_register_button_text,
                  color: const Color.fromARGB(200, 0, 0, 0),
                  fontWeight: FontWeight.bold
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}