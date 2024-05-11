import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

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
              color: Colors.grey
            ),

            //  Image display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset("lib/assets/pictures/phone_2.png"),
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

            //  Text - didn't receive code
            const SizedBox(height: 20),
            CustomComponents.displayText(
              ProjectStrings.register_verify_resent_otp,
              textAlign: TextAlign.center,
              color: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16))
            ),
            const SizedBox(height: 20),

            //  Next Button
            const SizedBox(height: 50),
            SizedBox(
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.register_verify_button,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}