import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../model/car_list/complete_car_list.dart';
import '../../../../../model/renting_proccess/renting_process.dart';
import '../../../../../services/firebase/firestore.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/components.dart';
import '../../../../shared/info_dialog.dart';
import '../../../../shared/strings.dart';

class EditCarStatusBottomSheet extends StatefulWidget {
  final CompleteCarInfo completeCarInfo;
  final BuildContext parentContext;

  const EditCarStatusBottomSheet({
    Key? key,
    required this.completeCarInfo,
    required this.parentContext,
  }) : super(key: key);

  @override
  EditCarStatusBottomSheetState createState() => EditCarStatusBottomSheetState();
}

class EditCarStatusBottomSheetState extends State<EditCarStatusBottomSheet> {
  int? _currentSelectedCarUnitStatus;
  String selectedCarUnitStatus = "";

  @override
  void initState() {
    super.initState();

    _currentSelectedCarUnitStatus = widget.completeCarInfo.availability == "available" ? 0 : 1;
    selectedCarUnitStatus = widget.completeCarInfo.availability.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
      widthFactor: 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        child: ListView(
          children: [
            UnconstrainedBox(
              child: Container(
                width: 50,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomComponents.displayText("Modify Car Status", fontWeight: FontWeight.bold),
            const SizedBox(height: 5),
            CustomComponents.displayText("Adjust car availability settings visible to users", fontSize: 10),
            const SizedBox(height: 30),
            CustomComponents.displayText("Car Status", fontWeight: FontWeight.bold, fontSize: 10),
            const SizedBox(height: 10),
            switchOptionPaymentStatus(),
            const SizedBox(height: 20),
            saveCancelButtons(),
          ],
        ),
      ),
    );
  }

  // Payment Status Switcher
  Widget switchOptionPaymentStatus() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentSelectedCarUnitStatus = 0;
                    selectedCarUnitStatus = "available";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _currentSelectedCarUnitStatus == 0
                        ? Color(int.parse(ProjectColors.mainColorHexBackground))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center, // Center the text
                  child: CustomComponents.displayText(
                    "Available",
                    color: Color(int.parse(ProjectColors.mainColorHex)),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10), // Add spacing between the options
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentSelectedCarUnitStatus = 1;
                    selectedCarUnitStatus = "unavailable";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _currentSelectedCarUnitStatus == 1
                        ? Color(int.parse(ProjectColors.mainColorHexBackground))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center, // Center the text
                  child: CustomComponents.displayText(
                    "Unavailable",
                    color: Color(int.parse(ProjectColors.mainColorHex)),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Save and Cancel Button
  Widget saveCancelButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            InfoDialog().showDecoratedTwoOptionsDialog(
              context: widget.parentContext,
              content: ProjectStrings.edit_user_info_dialog_content,
              header: ProjectStrings.edit_user_info_dialog_header,
              confirmAction: () async {
                await Firestore().updateCarStatus(carUID: widget.completeCarInfo.carUID, newStatus: selectedCarUnitStatus.toLowerCase());
                Navigator.of(widget.parentContext).pop();
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(int.parse(ProjectColors.redButtonBackground.substring(2), radix: 16))
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15, right: 55, left: 55),
              child: CustomComponents.displayText(
                  "Save",
                  color: Color(int.parse(ProjectColors.redButtonMain.substring(2), radix: 16)),
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),
          ),
        ),
      ],
    );
  }
}