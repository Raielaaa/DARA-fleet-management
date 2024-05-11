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
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //  Back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Image.asset("lib/assets/pictures/app_logo_name.png"),
            ),
      
            //  Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Image.asset("lib/assets/pictures/account_intro.png"),
            ),
      
            //  Text header
            Align(
              alignment: Alignment.centerLeft,
              child: CustomComponents.displayText(
                ProjectStrings.account_opening_header,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
              )
            ),
      
            //  Text subheader
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                  ProjectStrings.account_opening_body,
                  color: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16)),
                  fontSize: 14
                )
              ),
            ),
      
            //  Login button
            const SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.account_sign_in_button_text,
                onPressed: () {
                  Navigator.pushNamed(context, "login_main");
                },
              ),
            ),
      
            //   Register button
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.account_register_button_text,
                textColor: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
                buttonColor: Color(int.parse(ProjectColors.mainColorBackground)),
                onPressed: () {
                  Navigator.pushNamed(context, "register_main");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}