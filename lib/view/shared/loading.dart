import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  static final LoadingDialog _instance = LoadingDialog._internal();

  LoadingDialog._internal();

  factory LoadingDialog() {
    return _instance;
  }

  // To keep track of the current context and dialog state
  BuildContext? _context;
  bool _isShowing = false;

  // Method to show the loading dialog
  void show({
    required BuildContext context,
    required String content,
    String header = "Please wait...",
  }) {
    if (!_isShowing) {
      _isShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          _context = context;
          return PopScope(
            canPop: false,
            child: Dialog(
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
        },
      );
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
