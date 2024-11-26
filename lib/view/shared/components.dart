// ignore_for_file: unused_element

import "dart:async";

import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/services/firebase/auth.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:simple_loading_dialog/simple_loading_dialog.dart";

import "../pages/account/register/widgets/terms_and_conditions.dart";
import "../pages/admin/home/about_modal_sheet.dart";

class CustomComponents {
  static Widget menuButtons(BuildContext context) {
    return PopupMenuButton(
      icon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image.asset(
          "lib/assets/pictures/three_vertical_dots.png",
        ),
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'option_terms',
            child: CustomComponents.displayText(
                "Terms",
                fontWeight: FontWeight.bold,
                fontSize: 10
            ),
          ),
          PopupMenuItem<String>(
            value: 'option_about',
            child: CustomComponents.displayText(
                "About",
                fontWeight: FontWeight.bold,
                fontSize: 10
            ),
          ),
        ];
      },
      onSelected: (String value) {
        // Handle menu item selection
        switch (value) {
          case 'option_terms':
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => termsAndCondition(context, 2)
            );
            break;
          case 'option_about':
            showModalBottomSheet<void>(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return const AboutModalSheet();
                }
            );
            break;
        }
      },
    );
  }
  static void showToastMessage(
      String message,
      Color backgroundColor,
      Color textColor
      ) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 12.0
    );
  }

  static String capitalizeFirstLetter(String string) {
    return string[0].toUpperCase() + string.substring(1).toLowerCase();
  }

  static void showCupertinoLoadingDialog(
    int eventCode,
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
      dialogBuilder: (context, _) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width - 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomComponents.displayText(
                  "Please wait...",
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Divider(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 15),
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Color(int.parse(
                          ProjectColors.mainColorHex.substring(2),
                          radix: 16)),
                      strokeWidth: 3.5,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: CustomComponents.displayText(
                      content,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    completer.future.then((_) => {
      if (eventCode == 1) {
        Navigator.pushNamed(context, "register_phone_number")
      } else if (eventCode == 2) {
        Navigator.pushNamed(context, "home_main")
      }
    });
  }

  static DefaultTextStyle displayText(
    String text,
    {
      Color color = const Color(0xff404040),
      String fontFamily = ProjectStrings.general_font_family,
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      FontStyle fontStyle = FontStyle.normal
    }
  ) {
    return DefaultTextStyle(
      textAlign: textAlign,
      style: TextStyle(
        fontStyle: fontStyle,
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
      child: Text(
          text,
        overflow: TextOverflow.ellipsis,
        maxLines: 10,
      )
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
      String label, {
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
            color: Color(0xff3FA2BE),
          ),
        ),
        Function()? iconPressed,
        List<TextInputFormatter>? inputFormatters, // <-- New optional parameter
      }) {
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
        fontSize: 10,
      ),
      inputFormatters: inputFormatters, // <-- Pass inputFormatters here
      decoration: InputDecoration(
        suffixIcon: isIconPresent
            ? IconButton(
          onPressed: iconPressed,
          icon: Icon(
            isTextHidden ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xff3FA2BE),
          ),
        )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: inputBorder,
        labelText: label,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: labelColor,
          fontSize: 10,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xff3FA2BE),
        ),
      ),
    );
  }

  static ElevatedButton displayElevatedButton(
    String buttonText,
    {
      Function()? onPressed,
      Color textColor = Colors.white,
      Color buttonColor = const Color(0xff3FA2BE),
      double fontSize = 14,
      double borderRadius = 7
    }
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(buttonColor),
        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          )
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: CustomComponents.displayText(
          buttonText,
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: fontSize
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