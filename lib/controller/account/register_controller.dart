// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:dara_app/controller/providers/register_provider.dart';
import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/model/account/register_model.dart';
import 'package:dara_app/model/constants/firebase_constants.dart';
import 'package:dara_app/services/firebase/auth.dart';
import 'package:dara_app/services/firebase/firestore.dart';
import 'package:dara_app/services/firebase/phone_auth_service.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../view/shared/loading.dart';

class RegisterController {
  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  void sendOtp(
    String phoneNumber,
    Function(String) onCodeSent,
    BuildContext context,
    Function(FirebaseException) onVerificationFailed
  ) async {
    debugPrint("send otp checkpoint - controller");
    await _phoneAuthService.sendOtp(phoneNumber, onCodeSent, context, onVerificationFailed);
  }

  Future<void> verifyOtp(
      String verificationId,
      String smsCode,
      BuildContext context
      ) async {
    try {
      await _phoneAuthService.verifyOtp(verificationId, smsCode, context);
      // Dismiss loading dialog after successful verification
    } catch (e) {
      debugPrint("Error from OTP: $e");
      // Dismiss loading dialog if there's an error
      // Re-throw the error so it can be caught in the UI layer
      rethrow;
    }
  }

  void insertCredentialsAndUserDetailsToDB({
    required BuildContext context,
  }) {
    CustomComponents.showCupertinoLoadingDialog(
      1,
      ProjectStrings.general_dialog_db_process_request,
      context,
      [
        () async {
          PersistentData _persistentData = PersistentData();
          try {
            //  Creating user account + Get the user ID (UID) after successful user creation
            await Auth().createUserWithEmailAndPassword(
              email: _persistentData.getEmail!,
              password: _persistentData.getPassword!,
              context: context
            );
          } on FirebaseAuthException catch (exception) {
            debugPrint("breakpoint-login-credentials-creation-exeption-2: $exception");
            CustomComponents.showAlertDialog(
              context: context,
              title: ProjectStrings.general_dialog_db_error_header,
              content: "${ProjectStrings.general_dialog_db_error_body}${exception.message}",
              numberOfOptions: 1,
              onPressedPositive: () {
                Navigator.of(context).pop();
              },
            );
          }
        },
      ],
    );
  }

  void validateInputs(
    {
      required BuildContext context,
      required String firstName,
      required String lastName,
      required String birthday,
    }
  ) {
    if (
      firstName.isEmpty ||
      lastName.isEmpty ||
      birthday.isEmpty
    ) {
      CustomComponents.showAlertDialog(
        context: context,
        title: ProjectStrings.account_register_dialog_warning_1_title,
        content: ProjectStrings.account_register_dialog_warning_1_content,
        numberOfOptions: 1,
        onPressedPositive: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      Navigator.pushNamed(context, "register_email_pass");

      //  Store name and birthday on persistent_data singleton class
      PersistentData persistentData = PersistentData();
      persistentData.setFirstName = firstName;
      persistentData.setLastName = lastName;
      persistentData.setBirthday = birthday;
    }
  }

  void validateCredentialsInputted({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  }) {
    if (
      emailController.text.isEmpty ||
      passwordController.text.isEmpty ||
      confirmPasswordController.text.isEmpty
    ) {
      CustomComponents.showAlertDialog(
        context: context,
        title: ProjectStrings.account_register_dialog_warning_1_title,
        content: ProjectStrings.account_register_dialog_warning_1_content,
        numberOfOptions: 1,
        onPressedPositive: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      // Validates password and confirm password entries
      context.read<RegisterProvider>().validatePasswords(
        context: context,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
      );

      //  Stores the email address in the persistent_data singleton class
      PersistentData persistentData = PersistentData();
      persistentData.setEmail = emailController.text;
    }
  }
}