import "package:dara_app/controller/account/register_controller.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter_otp_text_field/flutter_otp_text_field.dart";

import "../../../shared/info_dialog.dart";

class RegisterVerifyNumber extends StatefulWidget {
  const RegisterVerifyNumber({super.key});

  @override
  State<RegisterVerifyNumber> createState() => _RegisterVerifyNumberState();
}

class _RegisterVerifyNumberState extends State<RegisterVerifyNumber> {
  final RegisterController _registerController = RegisterController();
  String _otpCode = "";

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
                  Navigator.pushNamed(context, "register_phone_number");
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
              ProjectStrings.register_verify_number_header,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
            ),

            //  Text subheader
            const SizedBox(height: 5),
            CustomComponents.displayText(
              ProjectStrings.register_verify_subheader,
              fontSize: 10,
            ),

            //  Image display
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
              child: Image.asset("lib/assets/pictures/phone_2.png"),
            ),

            //  Text - enter OTP
            const SizedBox(height: 50.0),
            OtpTextField(
              textStyle: const TextStyle(
                fontFamily: ProjectStrings.general_font_family,
                fontWeight: FontWeight.bold
              ),
              focusedBorderColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              cursorColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
              mainAxisAlignment: MainAxisAlignment.center,
              numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.04),
              filled: true,
              onSubmit: (code) {
                setState(() {
                  _otpCode = code;
                });
              }
            ),

            //  Text - didn't receive code
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                  text: ProjectStrings.register_verify_resent_otp_1,
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff08080a),
                    fontFamily: ProjectStrings.general_font_family
                  ),
                  children: <TextSpan> [
                    TextSpan(
                      text: ProjectStrings.register_verify_resent_otp_2,
                      style: TextStyle(
                        color: Color(0xff3FA2BE),
                        fontFamily: ProjectStrings.general_font_family,
                        fontWeight: FontWeight.w600,
                        fontSize: 10
                      )
                    )
                  ]
                )
              ),
            ),

            //  Next Button
            const SizedBox(height: 70),
            SizedBox(
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.register_verify_button,
                fontSize: 12,
                onPressed: () async {
                  try {
                    LoadingDialog().show(
                      context: context,
                      content: "Please wait while we process your OTP",
                    );
                    await _registerController.verifyOtp(PersistentData().verificationId.toString(), _otpCode, context);
                    debugPrint("Verification ID: ${PersistentData().verificationId.toString()}......OTP: $_otpCode");
                    // Navigator.pushNamed(context, "register_successful");
                    // LoadingDialog().dismiss();
                  } catch(e) {
                    LoadingDialog().dismiss();
                    InfoDialog().show(
                      context: context,
                      content: "Error: ${e.toString()}",
                      header: "Warning",
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}