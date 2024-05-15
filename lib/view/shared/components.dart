// ignore_for_file: unused_element

import "dart:async";

import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/services/firebase/auth.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:simple_loading_dialog/simple_loading_dialog.dart";

class CustomComponents {
  static void showCupertinoLoadingDialog(
    String content,
    BuildContext context,
    List<void Function()> functions,
  ) {
    Completer<void> completer = Completer<void>();

    showSimpleLoadingDialog<String>(
      context: context,
      future: () async {
        //  execute all provided void functions synchronously
        await Future.forEach(functions, (Function function) async {
          await function();
        });

        completer.complete();

        return "Task completed";
      },
      dialogBuilder: (context, _) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            CupertinoActivityIndicator(
              radius: 15.0, // Customize the size
              animating: true, // Control animation
              color: Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16),
              ), // Customize color
            ),
            const SizedBox(height: 25),
            displayText(
              content,
              textAlign: TextAlign.center
            ),
          ],
        ),
      ),
    );

    completer.future.then((_) => {
      // Navigator.of(context).pop()
      Navigator.pushNamed(context, "register_phone_number")
    });
  }

  static DefaultTextStyle displayText(
    String text,
    {
      Color color = Colors.black,
      String fontFamily = ProjectStrings.general_font_family,
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start
    }
  ) {
    return DefaultTextStyle(
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
      child: Text(text)
    );
  }

  static Container displayCarouselIndicator(
    {
      double width = 45,
      double height = 10,
      Color color = const Color(0xff3FA2BE)
    }
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color
      ),
    );
  }

  static TextField displayTextField(
    String label,
    {
      TextEditingController? controller,
      bool isFocused = false,
      TextInputType keyboardType = TextInputType.emailAddress,
      TextInputAction textInputAction = TextInputAction.next,
      bool isAutoCorrected = false,
      TextAlign textAlign = TextAlign.start,
      Color cursorColor = const Color(0xff3FA2BE),
      int maxLength = 20,
      int maxLines = 1,
      FontWeight labelWeight = FontWeight.bold,
      Color labelColor = Colors.grey,
      bool isIconPresent = false,
      bool isTextHidden = false,
      InputBorder inputBorder = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        borderSide: BorderSide(
          color: Color(0xff3FA2BE)
        )
      ),
      Function()? iconPressed
    }
  ) {
    return TextField(
      controller: controller,
      obscureText: isTextHidden,
      autofocus: isFocused,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autocorrect: isAutoCorrected,
      textAlign: textAlign,
      cursorColor: cursorColor,
      cursorErrorColor: Colors.red,
      maxLines: maxLines,
      maxLength: maxLength,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: ProjectStrings.general_font_family,
        fontSize: 14
      ),
      decoration: InputDecoration(
        suffixIcon: isIconPresent
          ? IconButton(
              onPressed: iconPressed,
              icon: Icon(
                isTextHidden ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xff3FA2BE)
              ),
            )
          : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7)
        ),
        focusedBorder: inputBorder,
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: labelColor,
          fontSize: 12
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xff3FA2BE),
          // fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  static ElevatedButton displayElevatedButton(
    String buttonText,
    {
      Function()? onPressed,
      Color textColor = Colors.white,
      Color buttonColor = const Color(0xff3FA2BE)
    }
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(buttonColor),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7)
          )
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: CustomComponents.displayText(
          buttonText,
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14
        ),
      ),
    );
  }

  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  static void showAlertDialog({
    Function()? onPressedPositive,
    Function()? onPressedNegative,
    String positiveButtonText = "",
    String negativeButtonText = "",
    int numberOfOptions = 2,
    required BuildContext context,
    required String title,
    required String content,
  }) {
    showCupertinoModalPopup<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: displayText(
          title,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          textAlign: TextAlign.center
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: displayText(
            content,
            fontSize: 14,
            textAlign: TextAlign.center
          ),
        ),
        actions: <CupertinoDialogAction>[
          if (numberOfOptions == 1)
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(ProjectStrings.general_dialog_ok),
              onPressed: () {
                if (onPressedPositive != null) onPressedPositive();
              },
            ),
          if (numberOfOptions == 2)
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                if (onPressedPositive != null) onPressedPositive();
              },
              child: Text(
                positiveButtonText.isEmpty ? ProjectStrings.general_dialog_yes : positiveButtonText
              ),
            ),
          if (numberOfOptions == 2)
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                if (onPressedNegative != null) onPressedNegative();
              },
              child: Text(
                negativeButtonText.isEmpty ? ProjectStrings.general_dialog_no : negativeButtonText
              ),
            ),
        ],
      ),
    );
  }
}