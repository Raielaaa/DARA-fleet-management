import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class RegisterSuccessful extends StatefulWidget {
  const RegisterSuccessful({super.key});

  @override
  State<RegisterSuccessful> createState() => _RegisterSuccessfulState();
}

class _RegisterSuccessfulState extends State<RegisterSuccessful> {
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
                  Navigator.pushNamed(context, "register_verify_number");
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
              ProjectStrings.register_complete_header,
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
            ),

            //  Text subheader
            const SizedBox(height: 10),
            CustomComponents.displayText(
              ProjectStrings.register_complete_subheader,
              fontSize: 14,
              color: Colors.grey
            ),

            //  Image display
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 30, top: 60, bottom: 20),
              child: Image.asset("lib/assets/pictures/register_successful.png"),
            ),

            //  Next Button
            const SizedBox(height: 70),
            SizedBox(
              child: CustomComponents.displayElevatedButton(
                ProjectStrings.register_complete_continue_button,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}