// ignore_for_file: unused_element

import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class RegisterPhoneNumber extends StatefulWidget {
  const RegisterPhoneNumber({super.key});

  @override
  State<RegisterPhoneNumber> createState() => _RegisterPhoneNumberState();
}

class _RegisterPhoneNumberState extends State<RegisterPhoneNumber> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Calls showDialog method right after screen display
      showDialog();
    });
  }
  //  Shows dialog if the previous registration process is successful
  void showDialog() {
    CustomComponents.showAlertDialog(
      context: context,
      title: "Registration Successful",
      content: "Your account has been successfully registered. Thank you for joining us!",
      numberOfOptions: 1,
      onPressedPositive: () {
        Navigator.of(context).pop();
        CustomComponents.showAlertDialog(
          context: context,
          title: ProjectStrings.register_dialog_title,
          content: ProjectStrings.register_dialog_content,
          onPressedPositive: () {
            Navigator.of(context).pop();
          },
          onPressedNegative: () {
            Navigator.of(context).pop();
          }
        );
      },
    );
  }

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
                  // Navigator.pushNamed(context, "register_email_pass");
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

            //  Image display
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Image.asset("lib/assets/pictures/phone_1.png"),
            ),

            //  Text - Enter phone number
            const SizedBox(height: 30),
            CustomComponents.displayText(
              ProjectStrings.register_phone_number_enter_number,
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),

            //  Text - phone number textfield
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(7)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    //  Text - 63
                    CustomComponents.displayText(
                      ProjectStrings.register_phone_number_63,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey
                    ),

                    //  Vertical divider
                    const SizedBox(width: 15),
                    Container(
                      height: 15,
                      width: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 15),

                    //  Textfield - phone number input
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: ProjectStrings.general_font_family,
                            color: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16))
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration.collapsed(
                            hintText: ProjectStrings.register_phone_number_label_hint,
                            hintStyle: const TextStyle(
                              fontFamily: ProjectStrings.general_font_family,
                              fontSize: 14,
                              color: Colors.grey
                            )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            //  Display notify to user
            const SizedBox(height: 20),
            CustomComponents.displayText(
              ProjectStrings.register_phone_number_send_verification,
              textAlign: TextAlign.center,
              color: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16))
            ),
            const SizedBox(height: 20),

            //  Next Button
            const SizedBox(height: 50),
            SizedBox(
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.general_next_button,
                onPressed: () {
                  Navigator.pushNamed(context, "register_verify_number");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}