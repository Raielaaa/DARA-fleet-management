// ignore_for_file: unused_element

import "package:dara_app/controller/account/register_controller.dart";
import "package:dara_app/controller/providers/register_provider.dart";
import "package:dara_app/view/pages/account/register/widgets/terms_and_conditions.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class RegisterEmailPass extends StatefulWidget {
  const RegisterEmailPass({super.key});

  @override
  State<RegisterEmailPass> createState() => _RegisterEmailPassState();
}

class _RegisterEmailPassState extends State<RegisterEmailPass> {
  bool _isPasswordVisible = false;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();

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
              color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
            ),

            //  Text subheader
            const SizedBox(height: 10),
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_subheader,
              fontSize: 14,
              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
            ),

            //  Email
            const SizedBox(height: 40),
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_email,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_ep_email_hint,
              isFocused: true,
              controller: _controllerEmail,
              labelColor: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
            ),

            //  Password
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_password,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_ep_email_hint,
              isIconPresent: true,
              isFocused: !context.watch<RegisterProvider>().isPasswordMatch,
              isTextHidden: !_isPasswordVisible,
              labelColor: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
              controller: _controllerPassword,
              iconPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              inputBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(
                  // color: Color(0xff3FA2BE)
                  color: context.watch<RegisterProvider>().isPasswordMatch ? const Color(0xff3FA2BE) : Colors.red
                )
              ),
            ),

            //  Confirm password
            CustomComponents.displayText(
              ProjectStrings.account_register_ep_confirm_password,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(int.parse(ProjectColors.darkGray.substring(2), radix: 16))
            ),
            const SizedBox(height: 10),
            CustomComponents.displayTextField(
              ProjectStrings.account_register_ep_confirm_password_hint,
              isIconPresent: true,
              isTextHidden: !_isPasswordVisible,
              controller: _controllerConfirmPassword,
              labelColor: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
              iconPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              inputBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(
                  // color: Color(0xff3FA2BE)
                  color: context.watch<RegisterProvider>().isPasswordMatch ? const Color(0xff3FA2BE) : Colors.red
                )
              ),
            ),

            //  Button
            const SizedBox(height: 120),
            SizedBox(
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.general_next_button,
                onPressed: () {
                  //  Checks if all fields have entries
                  RegisterController().validateCredentialsInputted(
                    context: context,
                    emailController: _controllerEmail,
                    passwordController: _controllerPassword,
                    confirmPasswordController: _controllerConfirmPassword
                  );
                },
              ),
            ),

            //  TextView - Already have an account
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                  text: ProjectStrings.account_register_ep_have_an_account_1,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff08080a),
                    fontFamily: ProjectStrings.general_font_family
                  ),
                  children: <TextSpan> [
                    TextSpan(
                      text: ProjectStrings.account_register_ep_have_an_account_2,
                      style: TextStyle(
                        color: Color(0xff3FA2BE),
                        fontFamily: ProjectStrings.general_font_family,
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                      )
                    )
                  ]
                )
              ),
            )
          ],
        )
      ),
    );
  }
}