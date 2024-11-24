import 'package:dara_app/controller/rent_process/rent_process.dart';
import 'package:dara_app/view/shared/colors.dart';
import 'package:dara_app/view/shared/components.dart';
import 'package:dara_app/view/shared/loading.dart';
import 'package:dara_app/view/shared/strings.dart';
import 'package:flutter/material.dart';

import '../../controller/singleton/persistent_data.dart';

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomComponents.displayText(
                      content,
                      fontSize: 10
                    ),
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

  void showWithCancelProceedButton(
    {
      required BuildContext context,
      required String content,
      String header = "Please wait...",
      int actionCode = 0,
      void Function()? onProceed,
    }
  ) {
    debugPrint("breakpoint - 1");
    if (!_isShowing) {
      debugPrint("breakpoint - 2");
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

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            dismiss();
                            if (actionCode == 0) {
                              RentProcess().showUploadPhotoBottomDialog(context, PersistentData().gcashAlternativeImagePath);
                            }
                          },
                          child: CustomComponents.displayText(
                            "Cancel",
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16))
                          ),
                        ),
                        const SizedBox(width:100),
                        GestureDetector(
                          onTap: () {
                            if (actionCode == 0) {
                              Navigator.pushNamed(context, "rp_submit_documents");
                            }
                            if (onProceed != null) {
                              onProceed();
                            }  
                          },
                          child: CustomComponents.displayText(
                            "Proceed",
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))
                          ),
                        )
                      ],
                    )
                  ],
                ),
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

  void showDecoratedTwoOptionsDialog({
    required BuildContext context,
    required String content,
    String header = "Please wait...",
    Future<void> Function()? confirmAction,
  }) {
    if (!_isShowing) {
      _isShowing = true;

      showDialog(
        context: context,
        barrierDismissible: false,
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
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        dismiss();
                      },
                      child: Image.asset(
                        "lib/assets/pictures/exit.png",
                        width: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomComponents.displayText(
                    header,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 3),
                  CustomComponents.displayText(
                    content,
                    fontSize: 10,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          dismiss();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(int.parse(
                                ProjectColors.confirmActionCancelBackground.substring(2),
                                radix: 16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: CustomComponents.displayText(
                              ProjectStrings.income_page_confirm_delete_cancel,
                              color: Color(int.parse(
                                  ProjectColors.confirmActionCancelMain.substring(2),
                                  radix: 16)),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () async {
                          if (confirmAction != null) {
                            LoadingDialog().show(context: context, content: "Updating records. Please wait and avoid closing the app, as this may take a moment.");
                            await confirmAction();
                            LoadingDialog().dismiss();
                          }
                          dismiss(); // Ensure dismissal after action completes
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color(int.parse(
                                ProjectColors.redButtonBackground.substring(2),
                                radix: 16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 40),
                            child: CustomComponents.displayText(
                              ProjectStrings.income_page_confirm_delete_confirm,
                              color: Color(int.parse(
                                  ProjectColors.redButtonMain.substring(2),
                                  radix: 16)),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ).then((_) {
        _isShowing = false; // Reset _isShowing here after dialog closes
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

  void dismissBoolean() {
    if (_isShowing && _context != null) {
      _isShowing = false;
      _context = null;
    }
  }
}
