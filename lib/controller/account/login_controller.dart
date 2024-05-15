import 'package:dara_app/controller/singleton/persistent_data.dart';
import 'package:dara_app/services/firebase/auth.dart';
import 'package:dara_app/services/google/google.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginController {
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
      CustomComponents.showCupertinoLoadingDialog(
        2,
        ProjectStrings.general_dialog_db_process_request,
        context,
        [
          () async {
            try {
              await Auth().signInWithEmailAndPassword(
                email: email,
                password: password
              );

              debugPrint("login success");
            } on FirebaseAuthException catch (e) {
              debugPrint("Auth login error - ${e.message}");
            }
          }
        ]
      );
    }
  }
}