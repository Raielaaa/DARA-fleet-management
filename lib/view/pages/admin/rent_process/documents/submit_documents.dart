import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:mobkit_dashed_border/mobkit_dashed_border.dart";

class SubmitDocuments extends StatefulWidget {
  const SubmitDocuments({super.key});

  @override
  State<SubmitDocuments> createState() => _SubmitDocumentsState();
}

class _SubmitDocumentsState extends State<SubmitDocuments> {
  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          Center(
            child: CustomComponents.displayText(
              ProjectStrings.sd_appbar_title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _submitDocuments(String documentName) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: DashedBorder.fromBorderSide(
            dashLength: 4,
            side: BorderSide(
              color: Color(int.parse(
                ProjectColors.userInfoDialogBrokenLinesColor.substring(2),
                radix: 16,
              )),
              width: 1,
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  right: 30,
                  bottom: 10,
                ),
                child: Image.asset(
                  "lib/assets/pictures/user_info_upload.png",
                  height: 60,
                ),
              ),
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomComponents.displayText(
                      ProjectStrings.user_info_upload_file,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomComponents.displayText(
                      documentName,
                      color: Color(int.parse(
                        ProjectColors.lightGray.substring(2),
                        radix: 16,
                      )),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Color(int.parse(
                            ProjectColors.userInfoDialogBrokenLinesColor
                                .substring(2),
                            radix: 16,
                          )),
                        ),
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        padding: MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.only(
                              left: 18, right: 18, top: 8, bottom: 8),
                        ),
                        minimumSize: MaterialStatePropertyAll<Size>(Size(0, 0)),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: CustomComponents.displayText(
                          ProjectStrings.user_info_choose_a_file,
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _proceedButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 80, left: 15, right: 15),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
            shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)))),
        onPressed: () {
          Navigator.of(context).pushNamed("rp_verify_booking");
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15),
            child: CustomComponents.displayText(
                ProjectStrings.ps_proceed_button,
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
            color: Color(int.parse(
                ProjectColors.mainColorBackground.substring(2),
                radix: 16)),
            child: Padding(
                padding: const EdgeInsets.only(top: 38),
                child: Column(children: [
                  _buildAppBar(),
                  //  main content
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        children: [
                          _submitDocuments(
                              ProjectStrings.user_info_government1),
                          _submitDocuments(
                              ProjectStrings.user_info_government2),
                          _submitDocuments(
                              ProjectStrings.user_info_driver_license),
                          _submitDocuments(
                              ProjectStrings.user_info_proof_of_billing),
                          _submitDocuments(
                              ProjectStrings.user_info_ltms_portal),
                          _proceedButton(),
                          const SizedBox(height: 25)
                        ],
                      ),
                    ),
                  )
                ]))));
  }
}
