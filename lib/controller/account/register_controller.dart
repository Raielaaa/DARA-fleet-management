import 'package:dara_app/controller/providers/register_provider.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RegisterController {
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
    }
  }
}