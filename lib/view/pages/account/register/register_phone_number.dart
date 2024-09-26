// ignore_for_file: unused_element

import "package:cloud_firestore/cloud_firestore.dart";
import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/services/firebase/phone_auth_service.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:fluttertoast/fluttertoast.dart';

import "../../../../controller/account/register_controller.dart";

class RegisterPhoneNumber extends StatefulWidget {
  const RegisterPhoneNumber({super.key});

  @override
  State<RegisterPhoneNumber> createState() => _RegisterPhoneNumberState();
}

class _RegisterPhoneNumberState extends State<RegisterPhoneNumber> {
  final TextEditingController _inputtedPhoneNumberController = TextEditingController();
  final RegisterController _registerController = RegisterController();
  String _verificationId = "";

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
            Navigator.of(context).pushNamed("login_main");
          }
        );
      },
    );
  }

  Future<void> _sendOtp(String phoneNumber) async {
    try {
      _registerController.sendOtp(
          phoneNumber,
              (String verificationId) {
            setState(() {
              _verificationId = verificationId;

              // Dismiss the loading dialog once the process is complete
              LoadingDialog().dismiss();

              // Navigate to the next page
              PersistentData().verificationId = _verificationId;
              Navigator.pushNamed(context, "register_verify_number");
            });
          },
          context,
              (FirebaseException e) {
            String errorMessage = 'Verification Failed: ${e.message ?? e.toString()}';
            InfoDialog().show(context: context, content: errorMessage, header: "Warning");
          }
      );
    } catch (e) {
      InfoDialog().show(context: context, content: "Unexpected Error: $e", header: "Error");
    }
  }


  int exitAppCounter = 0;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (source) async {
        if (exitAppCounter == 2) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          CustomComponents.showToastMessage("Press again to exit the application.", Colors.red, Colors.white);
          // Increment the counter
          exitAppCounter++;
          // Reset counter after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            exitAppCounter = 0;
          });
        }
      },
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
                fontSize: 22,
                color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
              ),

              //  Text subheader
              const SizedBox(height: 5),
              CustomComponents.displayText(
                ProjectStrings.account_register_ep_subheader,
                fontSize: 10,
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
                fontSize: 10
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
                        fontSize: 10,
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
                            controller: _inputtedPhoneNumberController,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: ProjectStrings.general_font_family,
                              color: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16))
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration.collapsed(
                              hintText: ProjectStrings.register_phone_number_label_hint,
                              hintStyle: const TextStyle(
                                fontFamily: ProjectStrings.general_font_family,
                                fontSize: 10,
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
                fontSize: 10,
                color: Color(int.parse(ProjectColors.blackBody.substring(2), radix: 16))
              ),
              const SizedBox(height: 20),

              //  Next Button
              const SizedBox(height: 50),
              SizedBox(
                child: CustomComponents.displayElevatedButton(
                  ProjectStrings.general_next_button,
                  fontSize: 12,
                  onPressed: () async {
                    try {
                      LoadingDialog().show(
                        context: context,
                        content: "Please wait while we process your OTP",
                      );

                      // Await the OTP sending process
                      await _sendOtp("+63${_inputtedPhoneNumberController.value.text}");
                    } catch (e) {
                      LoadingDialog().dismiss();
                      InfoDialog().show(
                        context: context,
                        content: "Error sending OTP: ${e.toString()}",
                        header: "Warning",
                      );
                    }
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