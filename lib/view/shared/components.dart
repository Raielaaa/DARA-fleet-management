import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class CustomComponents {
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
      Function()? iconPressed
    }
  ) {
    return TextField(
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
        // suffixIcon: isIconPresent ? const Icon(Icons.remove_red_eye_outlined) : null,
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
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          borderSide: BorderSide(
            color: Color(0xff3FA2BE)
          )
        ),
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
}