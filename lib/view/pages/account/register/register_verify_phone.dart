import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter_otp_text_field/flutter_otp_text_field.dart";

class RegisterVerifyNumber extends StatefulWidget {
  const RegisterVerifyNumber({super.key});

  @override
  State<RegisterVerifyNumber> createState() => _RegisterVerifyNumberState();
}

class _RegisterVerifyNumberState extends State<RegisterVerifyNumber> {
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
              fontSize: 32,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
            ),

            //  Text subheader
            const SizedBox(height: 10),
            CustomComponents.displayText(
              ProjectStrings.register_verify_subheader,
              fontSize: 14,
              color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
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
              onSubmit: (code) {}
              // onSubmit: (code) => print("OTP is => $code")
            ),

            //  Text - didn't receive code
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: const TextSpan(
                  text: ProjectStrings.register_verify_resent_otp_1,
                  style: TextStyle(
                    fontSize: 14,
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
                        fontSize: 14
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
                onPressed: () {
                  Navigator.pushNamed(context, "register_successful");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}