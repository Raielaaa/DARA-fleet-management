import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../model/renting_proccess/renting_process.dart';
import '../../../../../services/firebase/firestore.dart';
import '../../../../shared/colors.dart';
import '../../../../shared/components.dart';
import '../../../../shared/info_dialog.dart';
import '../../../../shared/strings.dart';

class EditRentalInfoBottomSheet extends StatefulWidget {
  final RentInformation completeRentInfo;
  final BuildContext parentContext;

  const EditRentalInfoBottomSheet({
    Key? key,
    required this.completeRentInfo,
    required this.parentContext,
  }) : super(key: key);

  @override
  _EditRentalInfoBottomSheetState createState() => _EditRentalInfoBottomSheetState();
}

class _EditRentalInfoBottomSheetState extends State<EditRentalInfoBottomSheet> {
  int? _currentSelectedIndexPaymentStatus;
  int? _currentSelectedIndexRentStatus;
  String selectedItemForEditPaymentStatus = "";
  String selectedItemForEditRentStatus = "";

  @override
  void initState() {
    super.initState();
    _currentSelectedIndexPaymentStatus = widget.completeRentInfo.paymentStatus == "paid" ? 0 : 1;
    _currentSelectedIndexRentStatus = widget.completeRentInfo.postApproveStatus == "ongoing" ? 0
        : widget.completeRentInfo.postApproveStatus == "completed" ? 1 : 2;

    selectedItemForEditPaymentStatus = widget.completeRentInfo.paymentStatus;
    selectedItemForEditRentStatus = widget.completeRentInfo.postApproveStatus;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.55,
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
            CustomComponents.displayText("Edit Rental Information", fontWeight: FontWeight.bold),
            const SizedBox(height: 5),
            CustomComponents.displayText("Update payment status and rental progress", fontSize: 10),
            const SizedBox(height: 30),
            CustomComponents.displayText("Payment Status", fontWeight: FontWeight.bold, fontSize: 10),
            const SizedBox(height: 10),
            switchOptionPaymentStatus(),
            const SizedBox(height: 15),
            CustomComponents.displayText("Rent Status", fontWeight: FontWeight.bold, fontSize: 10),
            const SizedBox(height: 10),
            switchOptionRentStatus(),
            const SizedBox(height: 50),
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
                    _currentSelectedIndexPaymentStatus = 0;
                    selectedItemForEditPaymentStatus = "paid";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _currentSelectedIndexPaymentStatus == 0
                        ? Color(int.parse(ProjectColors.mainColorHexBackground))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center, // Center the text
                  child: CustomComponents.displayText(
                    "Paid",
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
                    _currentSelectedIndexPaymentStatus = 1;
                    selectedItemForEditPaymentStatus = "unpaid";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: _currentSelectedIndexPaymentStatus == 1
                        ? Color(int.parse(ProjectColors.mainColorHexBackground))
                        : Colors.white,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  alignment: Alignment.center, // Center the text
                  child: CustomComponents.displayText(
                    "Unpaid",
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

  // Rent Status Switcher
  Widget switchOptionRentStatus() {
    return SlideSwitcher(
      indents: 3,
      containerColor: Colors.white,
      containerBorderRadius: 7,
      slidersColors: [
        Color(int.parse(ProjectColors.mainColorHexBackground.substring(2), radix: 16)),
      ],
      containerHeight: 50,
      containerWight: MediaQuery.of(context).size.width - 50,
      initialIndex: _currentSelectedIndexRentStatus ?? 0,
      onSelect: (index) {
        setState(() {
          _currentSelectedIndexRentStatus = index;
          selectedItemForEditRentStatus = (index == 0) ? "ongoing" : (index == 1) ? "completed" : "cancelled";
        });
      },
      children: [
        CustomComponents.displayText(
          "Ongoing",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Completed",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        CustomComponents.displayText(
          "Cancelled",
          color: Color(int.parse(ProjectColors.mainColorHex)),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ],
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
                await Firestore().updateRentStatusRentLogs(
                    carUID: widget.completeRentInfo.rent_car_UID,
                    estimatedDrivingDistance: widget.completeRentInfo.estimatedDrivingDistance,
                    startDateTime: widget.completeRentInfo.startDateTime,
                    endDateTime: widget.completeRentInfo.endDateTime,
                    newPaymentStatus: selectedItemForEditPaymentStatus,
                    newPostApproveStatus: selectedItemForEditRentStatus
                );
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

// Method to show the bottom sheet
Future<void> showEditBottomSheet(BuildContext parentContext, RentInformation completeRentInfo) {
  return showModalBottomSheet(
    context: parentContext,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return EditRentalInfoBottomSheet(
        completeRentInfo: completeRentInfo,
        parentContext: parentContext,
      );
    },
  );
}
