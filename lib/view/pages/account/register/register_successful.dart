import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
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
    return PopScope(
      canPop: false,
      child: Material(
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
                PersistentData().isFromHomeForPhoneVerification ? ProjectStrings.register_complete_header : "Phone Verification Successful",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
              ),

              //  Text subheader
              const SizedBox(height: 5),
              CustomComponents.displayText(
                PersistentData().isFromHomeForPhoneVerification ? ProjectStrings.register_complete_subheader : "Your phone number has been successfully verified. Please click the button to return to the home page.",
                fontSize: 12,
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
                  fontSize: 12,
                  onPressed: () {
                    PersistentData _persistentData = PersistentData();

                    debugPrint("register-success: ${_persistentData.isFromHomeForPhoneVerification}");
                    _persistentData.userUId = _persistentData.uidForPhoneVerification;
                    _persistentData.isFromHomeForPhoneVerification ? Navigator.of(context).pushNamed("admin_home")
                        : Navigator.of(context).pushNamed("login_main");
                    // _persistentData.isFromHomeForPhoneVerification ? _persistentData.tabController.jumpToTab(
                    //     _persistentData.tabController.index == 4 ? 1 : 4
                    // ) : Navigator.of(context).pushNamed("login_main");
                    PersistentData().isFromHomeForPhoneVerification = false;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}