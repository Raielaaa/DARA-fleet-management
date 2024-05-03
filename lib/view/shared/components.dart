import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";

class CustomComponents {
  static DefaultTextStyle displayText(
    String text,
    {
      Color color = Colors.black,
      String fontFamily = ProjectStrings.general_font_family,
      double fontSize = 18,
      FontWeight fontWeight = FontWeight.normal
    }
  ) {
    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight
      ),
      child: Text(text)
    );
  }
}