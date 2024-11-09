import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class VerifyBooking extends StatefulWidget {
  const VerifyBooking({super.key});

  @override
  State<VerifyBooking> createState() => _VerifyBookingState();
}

class _VerifyBookingState extends State<VerifyBooking> {
  Widget _proceedButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
        onPressed: () {
          // PersistentData().tabController.jumpToTab(3);
          Navigator.of(context).pushNamed("car_list");
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: CustomComponents.displayText(
                ProjectStrings.vb_button,
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25, left: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/pictures/verify_documents.png",
                    // width: MediaQuery.of(context).size.width - 200
                  ),
                  const SizedBox(height: 40),
                  CustomComponents.displayText(
                    ProjectStrings.vb_title,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                  const SizedBox(height: 10),
                  CustomComponents.displayText(
                    ProjectStrings.vb_content,
                    fontSize: 10,
                    textAlign: TextAlign.center
                  ),
                  _proceedButton()
                ]
              ),
            )
          ),
        ),
      ),
    );
  }
}