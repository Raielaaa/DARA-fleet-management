import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/services/firebase/firestore.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/info_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../view/shared/loading.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendOtp(
      String phoneNumber,
      Function(String) onCodeSent,
      BuildContext context,
      Function(FirebaseException) onVerificationFailed
  ) async {
    debugPrint("send otp checkpoint - service");
    await _auth.verifyPhoneNumber(
      forceResendingToken: PersistentData().forceResendingToken,
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //  Sign the user in if verification is instant
        await _auth.signInWithCredential(credential);
        debugPrint("Verification Completed");
      },
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? resentToken) {
        debugPrint("code sent/resent checkpoint");
        onCodeSent(verificationId);
        PersistentData().verificationId = verificationId;
        PersistentData().forceResendingToken = resentToken;
        debugPrint("force-resent-token: ${PersistentData().forceResendingToken}");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint("timeout checkpoint");
        LoadingDialog().dismiss();
        if (PersistentData().isOtpVerified == false) {
          debugPrint("Timeout: $verificationId");
          PersistentData().isFromOtpPage = true;
          debugPrint("service layer: ${PersistentData().isFromOtpPage}");
          Navigator.of(context).pushNamed("register_phone_number");
          LoadingDialog().dismiss();
          InfoDialog().show(
              context: context,
              content: "The One-Time Password (OTP) has expired. Please request a new OTP and input it within 60 seconds to proceed.",
              header: "OTP Expired"
          );
        }  
      }
    );
  }

  Future<void> verifyOtp(String verificationId, String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);

      InfoDialog().show(
          context: context,
          content: "Phone number verified successfully.",
          header: "Notice"
      );
      PersistentData().isOtpVerified = true;

      //  input number to the user if triggered by in-app number verification
      debugPrint("Is from home: ${PersistentData().isFromHomeForPhoneVerification}");
      debugPrint("Number: ${PersistentData().inputtedCellphoneNumber.toString()}");
      if (PersistentData().isFromHomeForPhoneVerification) {
        Firestore().updateUserPhoneNumber(FirebaseAuth.instance.currentUser!.uid, PersistentData().inputtedCellphoneNumber.toString());
      } else {
        insertPhoneNumberToDB();
      }

      Navigator.of(context).pushNamed("register_successful");
      debugPrint("success - register_verify_phone.dart");
    } catch (e) {
      InfoDialog().dismiss();
      InfoDialog().show(
          context: context,
          content: "Failed to verify OTP: ${e.toString()}.",
          header: "Warning"
      );
      // CustomComponents.showToastMessage("Failed to verify OTP: ${e.toString()}", Colors.red, Colors.white);
      debugPrint("DebugPrint - Failed to verify OTP: $e");
      rethrow;  // Propagate error to higher layers
    }
  }

  Future<void> insertPhoneNumberToDB() async {
    try {
      await Firestore().updateUserDataRegister(
          PersistentData().userUId,
          PersistentData().selectedRoleOnRegister == "Renter" ? "verified" : "unverified",
          PersistentData().inputtedCellphoneNumber.toString()
      );
      debugPrint("number successfully added to DB");
    } catch(e) {
      debugPrint("An error occured: $e");
    }
  }
}