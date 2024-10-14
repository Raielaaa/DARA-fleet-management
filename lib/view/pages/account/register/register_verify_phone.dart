import "dart:async";

import "package:cloud_firestore/cloud_firestore.dart";
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
  String _verificationId = "";
  int _countdown = 30;
  Timer? _timer;

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override void initState() {
    // TODO: implement initState
    super.initState();
    startCountdown();
    PersistentData().isOtpVerified = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                PersistentData().isFromHomeForPhoneVerification ? ProjectStrings.register_verify_number_header : "Enter OTP",
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(int.parse(ProjectColors.blackHeader.substring(2), radix: 16)),
              ),

              //  Text subheader
              const SizedBox(height: 5),
              CustomComponents.displayText(
                PersistentData().isFromHomeForPhoneVerification ? ProjectStrings.register_verify_subheader : "Enter the OTP sent to your phone to verify your number",
                fontSize: 12,
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

              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  try {
                    if (_countdown <= 0) {
                      PersistentData().isOtpVerified = true;
                      LoadingDialog().show(
                        context: context,
                        content: "Please wait while we process your OTP",
                      );
                      debugPrint("register-verify-phone: ${PersistentData().inputtedCellphoneNumber}");
                      debugPrint("force-resend-token-ui: ${PersistentData().forceResendingToken}");
                      _registerController.sendOtp(
                          PersistentData().inputtedCellphoneNumber.toString(),
                              (String verificationId) {
                            setState(() {
                              _verificationId = verificationId;

                              // Dismiss the loading dialog once the process is complete
                              LoadingDialog().dismiss();
                              debugPrint("code resent with verification id: $_verificationId");

                              // Navigate to the next page
                              PersistentData().verificationId = _verificationId;
                              Navigator.pushNamed(context, "register_verify_number");
                            });
                          },
                          context,
                              (FirebaseException e) {
                            PersistentData().isOtpVerified = false;
                            debugPrint("code resent exception: $e");
                            String errorMessage = 'Verification Failed: ${e.message ?? e.toString()}';
                            InfoDialog().show(context: context, content: errorMessage, header: "Warning");
                          }
                      );
                    }
                  } catch(e) {
                    LoadingDialog().dismiss();
                    InfoDialog().show(
                      context: context,
                      content: "Error sending OTP: ${e.toString()}",
                      header: "Warning",
                    );
                  }
                },
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: ProjectStrings.register_verify_resent_otp_1,
                      style: TextStyle(
                        fontSize: 10,
                        color: _countdown == 0 ? const Color(0xff08080a) : Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                        fontFamily: ProjectStrings.general_font_family
                      ),
                      children: <TextSpan> [
                        TextSpan(
                          text: ProjectStrings.register_verify_resent_otp_2,
                          style: TextStyle(
                            color: _countdown == 0 ? const Color(0xff3FA2BE) : Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                            fontFamily: ProjectStrings.general_font_family,
                            fontWeight: FontWeight.w600,
                            fontSize: 10
                          )
                        ),
                        TextSpan(
                          text: " (${_countdown}s)",
                          style: TextStyle(
                            color: _countdown == 0 ? Colors.transparent : const Color(0xff3FA2BE),
                              fontFamily: ProjectStrings.general_font_family,
                              fontWeight: FontWeight.w600,
                              fontSize: 10
                          )
                        )
                      ]
                    )
                  ),
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
      ),
    );
  }
}