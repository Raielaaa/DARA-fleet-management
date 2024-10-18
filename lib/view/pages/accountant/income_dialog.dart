import "package:dara_app/model/car_list/complete_car_list.dart";
import "package:dara_app/services/firebase/firestore.dart";
import "package:dara_app/view/pages/admin/rent_process/booking_details.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/loading.dart";
import "package:dara_app/view/shared/strings.dart";
import "package:flutter/material.dart";
import "package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart";
import "package:intl/intl.dart";

import "../../../model/renting_proccess/renting_process.dart";

class ShowDialog {
  final DatePickerField _startDateField = DatePickerField(
    label: ProjectStrings.rp_bk_starting_date_label,
    selectedDate: ProjectStrings.rp_bk_starting_date_label,
  );

  final DatePickerField _endDateField = DatePickerField(
    label: ProjectStrings.rp_bk_ending_date_label,
    selectedDate: ProjectStrings.rp_bk_ending_date_label,
  );

  Future<void> editIncomeReport(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          backgroundColor: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "lib/assets/pictures/exit.png",
                  width: 20
                ),
              ),
              CustomComponents.displayText(
                ProjectStrings.income_page_edit_header,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              CustomComponents.displayText(
                ProjectStrings.income_page_edit_subheader,
                fontSize: 10
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }
    );
  }

  Widget buildInfoRow(String title, String value, {Color? titleColor, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomComponents.displayText(
            title,
            fontWeight: FontWeight.w500,
            fontSize: 10,
            color: titleColor ?? Colors.grey,
          ),
          const SizedBox(width: 50),
          Expanded(
            child: CustomComponents.displayText(
              value,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.end,
              fontSize: 10,
              color: valueColor ?? const Color(0xff404040),
            ),
          ),
        ],
      ),
    );
  }

  String calculateDateDifference(String startDateTime, String endDateTime) {
    // Define the date format used in the input strings
    DateFormat dateFormat = DateFormat("MMMM d, yyyy | hh:mm a");

    // Parse the date strings into DateTime objects
    DateTime startDate = dateFormat.parse(startDateTime);
    DateTime endDate = dateFormat.parse(endDateTime);

    // Calculate the difference
    Duration difference = endDate.difference(startDate);

    // Extract days, hours, and minutes
    int days = difference.inDays;
    int hours = difference.inHours.remainder(24);
    int minutes = difference.inMinutes.remainder(60);

    // Return the result as a formatted string
    return "$days days, $hours hours, and $minutes minutes";
  }

  Future<void> seeCompleteReportInfo(RentInformation _rentInformation, BuildContext context) async {
    CompleteCarInfo? _selectedCarInfo;

    LoadingDialog().show(context: context, content: "Please wait while re retrieve records.");
    List<CompleteCarInfo> _completeCarInfo = await Firestore().getCompleteCars();

    for (var item in _completeCarInfo) {
      if (item.carUID == _rentInformation.rent_car_UID) _selectedCarInfo = item;
    }
    LoadingDialog().dismiss();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          backgroundColor: Color(int.parse(
              ProjectColors.mainColorBackground.substring(2),
              radix: 16)),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  top design
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          child: Image.asset(
                            "lib/assets/pictures/header_background_curves.png",
                            width: MediaQuery.of(context).size.width - 10,
                            height: 70, // Adjust height as needed
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 15, left: 15, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomComponents.displayText(
                                  ProjectStrings.dialog_title_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                              Image.asset(
                                "lib/assets/pictures/app_logo_circle.png",
                                width: 80.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(int.parse(
                                                ProjectColors.mainColorBackground
                                                    .substring(2),
                                                radix: 16)),
                                            border: Border.all(
                                                color: Color(int.parse(
                                                    ProjectColors.lineGray)),
                                                width: 1)),
                                        child: Center(
                                            child: CustomComponents.displayText(
                                                "1",
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold))),
                                  ),
                                  const SizedBox(
                                      width:
                                          20.0), // Optional: Add spacing between the Text and the Column
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomComponents.displayText(
                                          ProjectStrings.dialog_car_info_title,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        const SizedBox(height: 2),
                                        CustomComponents.displayText(
                                          ProjectStrings.dialog_car_info,
                                          color: Color(int.parse(
                                              ProjectColors.lightGray
                                                  .substring(2),
                                              radix: 16)),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Color(int.parse(
                                  ProjectColors.lineGray.substring(2),
                                  radix: 16)),
                            ),
                            buildInfoRow(ProjectStrings.dialog_car_model_title, _selectedCarInfo!.name),
                            buildInfoRow(ProjectStrings.dialog_transmission_title, _selectedCarInfo.transmission),
                            buildInfoRow(ProjectStrings.dialog_capacity_title, _selectedCarInfo.capacity),
                            buildInfoRow(ProjectStrings.dialog_fuel_title, _selectedCarInfo.fuelVariant),
                            buildInfoRow(ProjectStrings.dialog_fuel_capacity_title, _selectedCarInfo.fuel),
                            buildInfoRow(ProjectStrings.dialog_unit_color_title, _selectedCarInfo.color),
                            buildInfoRow(ProjectStrings.dialog_engine_title, _selectedCarInfo.engine),
                            buildInfoRow("Owner", _selectedCarInfo.carOwner),

                            const SizedBox(height: 30)
                          ],
                        )
                    ),
                    //  rent information
                    const SizedBox(height: 20),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                                      border: Border.all(
                                        color: Color(int.parse(ProjectColors.lineGray)),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomComponents.displayText(
                                        "2",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.dialog_title_2,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomComponents.displayText(
                                        ProjectStrings.dialog_title_2_subheader,
                                        color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_rent_start_title,
                            _rentInformation.startDateTime,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_rent_end_title,
                            _rentInformation.endDateTime,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_delivery_mode_title,
                            _rentInformation.pickupOrDelivery,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_delivery_location_title,
                            _rentInformation.deliveryLocation.isEmpty ? "NA" : _rentInformation.deliveryLocation,
                          ),
                          buildInfoRow(
                            "Rent Location",
                            _rentInformation.rentLocation,
                          ),
                          buildInfoRow(
                            ProjectStrings.dialog_admin_notes_title,
                            _rentInformation.adminNotes,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    //  report information
                    const SizedBox(height: 20),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(int.parse(ProjectColors.mainColorBackground.substring(2), radix: 16)),
                                      border: Border.all(
                                        color: Color(int.parse(ProjectColors.lineGray)),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: CustomComponents.displayText(
                                        "3",
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomComponents.displayText(
                                        ProjectStrings.income_page_third_panel_title,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomComponents.displayText(
                                        ProjectStrings.income_page_third_panel_subheader,
                                        color: Color(int.parse(ProjectColors.lightGray.substring(2), radix: 16)),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Color(int.parse(ProjectColors.lineGray.substring(2), radix: 16)),
                          ),
                          buildInfoRow(
                            ProjectStrings.income_page_rent_duration_title,
                            calculateDateDifference(_rentInformation.startDateTime, _rentInformation.endDateTime),
                          ),
                          buildInfoRow(
                            ProjectStrings.income_page_reserved_customers_title,
                            _rentInformation.reservationFee == "500" ? "Yes" : "No",
                          ),
                          buildInfoRow(
                            ProjectStrings.income_page_amount_title,
                            "PHP ${_rentInformation.totalAmount}",
                            valueColor: Color(int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
                          ),
                          const SizedBox(height: 30)
                        ],
                      ),
                    ),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}