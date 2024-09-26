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
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        //  Sign the user in if verification is instant
        await _auth.signInWithCredential(credential);
        debugPrint("Verification Completed");
      },
      verificationFailed: onVerificationFailed,
      codeSent: (String verificationId, int? resentToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint("Timeout: $verificationId");
      }
    );
  }

  Future<void> verifyOtp(String verificationId, String smsCode, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode
      );

      Navigator.pushNamed(context, "register_verify_number");
      await _auth.signInWithCredential(credential);
      InfoDialog().show(context: context, content: "Phone number verified successfully.", header: "Notice");
    } catch (e) {
      InfoDialog().show(context: context, content: "Failed to verify OTP: $e", header: "Warning");
      debugPrint("DebugPrint - Failed to verify OTP: $e");
    }
  }
}