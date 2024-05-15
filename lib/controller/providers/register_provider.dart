import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/pages/account/register/widgets/terms_and_conditions.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class RegisterProvider extends ChangeNotifier {
  bool isPasswordMatch = true;

  void validatePasswords({
    required BuildContext context,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController
  }) {
    isPasswordMatch = (passwordController.text == confirmPasswordController.text ? true : false);
    if (passwordController.text == confirmPasswordController.text) {
      isPasswordMatch = true;

      //  Display Terms and Conditions ModalBottomSheet
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return termsAndCondition(context);
        }
      );

      //  Stores password to the persistent_data singleton class
      PersistentData persistentData = PersistentData();
      persistentData.setPassword = confirmPasswordController.text;
    } else {
      isPasswordMatch = false;
      passwordController.clear();
      confirmPasswordController.clear();

      //  Display dialog - password doesn't match
      CustomComponents.showAlertDialog(
        context: context,
        title: ProjectStrings.account_register_dialog_warning_1_title,
        content: ProjectStrings.account_register_dialog_warning_2_content,
        numberOfOptions: 1,
        onPressedPositive: () {
          Navigator.of(context).pop();
        },
      );
    }

    notifyListeners();
  }
}