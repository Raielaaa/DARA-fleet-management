import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:flutter/material.dart';

class InfoDialog {
  static final InfoDialog _instance = InfoDialog._internal();

  InfoDialog._internal();

  factory InfoDialog() {
    return _instance;
  }

  // To keep track of the current context and dialog state
  BuildContext? _context;
  bool _isShowing = false;

  // Method to show the loading dialog
  void show(
    {
      required BuildContext context,
      required String content,
      String header = "Please wait..."
    }
  ) {
    debugPrint("breakpoint - 1");
    if (!_isShowing) {
      debugPrint("breakpoint - 2");
      _isShowing = true;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          _context = context;
          return Dialog(
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
                      header,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(),
                  ),
                  CustomComponents.displayText(
                    content,
                    fontSize: 10
                  ),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        _isShowing = false;
        _context = null;
      });
    }
  }

  // Method to dismiss the loading dialog
  void dismiss() {
    if (_isShowing && _context != null) {
      Navigator.of(_context!).pop();
      _isShowing = false;
      _context = null;
    }
  }
}
