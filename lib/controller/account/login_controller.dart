import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/services/firebase/auth.dart';
import 'package:dara_app/services/google/google.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/loading.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../model/account/register_model.dart';
import '../../model/constants/firebase_constants.dart';
import '../../services/firebase/firestore.dart';

class LoginController {
  void insertGoogleCredentialsToDB({
    required String userUID,
    required String firstName,
    required String lastName,
    required String birthday,
    required String email,
    required String role,
    required BuildContext context
  }) async {
    RegisterModel _userData = RegisterModel(
        id: userUID ?? "empty_userID",
        firstName: firstName,
        lastName: lastName,
        birthday: birthday,
        email: email,
        number: "",
        role: role,
        status: "unverified",
        dateCreated: getCurrentDateTime(),
        totalAmountSpent: "",
        longestRentalDate: "",
        favorite: "",
        rentalCount: ""
    );

    try {
      await Firestore().addUserInfo(
          collectionName: FirebaseConstants.registerCollection,
          documentName: userUID ?? "empty document name",
          data: _userData.getModelData()
      );
      Navigator.of(context).pushNamed("home_main");
      debugPrint("breakpoint-login-credentials-creation");

    } on FirebaseException catch (exception) {
      debugPrint("breakpoint-login-credentials-creation-exeption-1: $exception");
      CustomComponents.showAlertDialog(
        context: context,
        title: ProjectStrings.general_dialog_db_error_header,
        content: "${ProjectStrings.general_dialog_db_error_body}${exception.message}",
        numberOfOptions: 1,
        onPressedPositive: () {
          Navigator.of(context).pop();
        },
      );
    } catch(e) {
      debugPrint("fatal error: $e");
    }
  }

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("MMMM dd, yyyy : hh:mm a");
    return formatter.format(now);
  }

  void googleSignin(BuildContext context) {
    GoogleLogin().signInWithGoogle(context);
  }

  void validateInputs(
    {
      required BuildContext context,
      required String email,
      required String password,
    }
  ) {
    if (email.isEmpty || password.isEmpty) {
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
      try {
        Auth().signInWithEmailAndPassword(email: email, password: password, context: context);
      } catch (e) {
        LoadingDialog().dismiss();
        CustomComponents.showAlertDialog(
          context: context,
          title: ProjectStrings.account_register_dialog_warning_1_title,
          content: "An error occured",
          numberOfOptions: 1,
          onPressedPositive: () {
            Navigator.of(context).pop();
          },
        );
      }
      // CustomComponents.showCupertinoLoadingDialog(
      //   2,
      //   ProjectStrings.general_dialog_db_process_request,
      //   context,
      //   [
      //     () async {
      //       try {
      //         await Auth().signInWithEmailAndPassword(
      //           email: email,
      //           password: password
      //         );

      //         debugPrint("login success");

      //         // if (!context.mounted) return;
      //         // Navigator.pushNamed(context, "home_main_admin");
      //       } on FirebaseAuthException catch (e) {
      //         debugPrint("Auth login error - ${e.message}");
      //       }
      //     }
      //   ]
      // );
    }
  }
}