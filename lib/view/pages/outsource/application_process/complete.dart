import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class ProcessComplete extends StatefulWidget {
  const ProcessComplete({super.key});

  @override
  State<ProcessComplete> createState() => _ProcessCompleteState();
}

class _ProcessCompleteState extends State<ProcessComplete> {
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
          Navigator.of(context).pushNamed("home_main");
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
    return Scaffold(
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
                        ProjectStrings.outsource_ds_success_page_header,
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                    const SizedBox(height: 10),
                    CustomComponents.displayText(
                        ProjectStrings.outsource_ds_success_page_subheader,
                        fontSize: 10,
                        textAlign: TextAlign.center
                    ),
                    _proceedButton()
                  ]
              ),
            )
        ),
      ),
    );
  }
}