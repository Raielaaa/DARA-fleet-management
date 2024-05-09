import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginMain();
}

class _LoginMain extends State<LoginMain> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(25),
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
        child: ListView(
          children: [
            Container(
              //  Back button
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "register_name_birthday");
                },
                icon: const Icon(Icons.arrow_back),
                iconSize: 25.0, // desired size
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(), // override default min size of 48px
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            //  Text header
            const SizedBox(height: 30),
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_header,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
            ),

            //  Text subheader
            const SizedBox(height: 10),
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_subheader,
              fontSize: 14,
              color: Colors.grey
            ),

            //  Email
            const SizedBox(height: 40),
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_email,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_ep_email_hint,
              isFocused: true
            ),

            //  Password
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_password,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(ProjectStrings.account_register_ep_email_hint),

            //  Text - Forgot password
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: CustomComponents.displayText(
                ProjectStrings.account_login_main_forgot_password,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
              ),
            ),

            //  Button
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.general_next_button,
                onPressed: () {},
              ),
            ),

            //  Row - "Or" TextView
            const SizedBox(height: 20),
            Row(
              children: [
                //  First line
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  )
                ),

                //  Text - "Or"
                const SizedBox(width: 10),
                CustomComponents.displayText(
                  ProjectStrings.account_login_main_or,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
                const SizedBox(width: 10),

                //  Second line
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  )
                )
              ],
            ),

            //  Google sign-in button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomComponents.displayText(
                      ProjectStrings.account_login_main_login_google,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ]
              ),
            ),
          ],
        )
      ),
    );
  }
}