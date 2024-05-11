import "package:dara_app/view/pages/account/register/widgets/terms_and_conditions.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class RegisterEmailPass extends StatefulWidget {
  const RegisterEmailPass({super.key});

  @override
  State<RegisterEmailPass> createState() => _RegisterEmailPassState();
}

class _RegisterEmailPassState extends State<RegisterEmailPass> {
  bool _isPasswordVisible = false;

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
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_ep_email_hint,
              isIconPresent: true,
              isTextHidden: !_isPasswordVisible,
              iconPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }
            ),

            //  Confirm password
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_confirm_password,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_ep_confirm_password_hint,
              isIconPresent: true,
              isTextHidden: !_isPasswordVisible,
              iconPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }
            ),

            //  Button
            const SizedBox(height: 50),
            SizedBox(
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.general_next_button,
                onPressed: () {
                  //  Display ModalBottomSheet
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return termsAndCondition(context);
                    }
                  );
                },
              ),
            ),

            //  TextView - Already have an account
            const SizedBox(height: 10),
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_have_an_account,
              color: Colors.grey,
              fontSize: 12,
              textAlign: TextAlign.center
            )
          ],
        )
      ),
    );
  }
}