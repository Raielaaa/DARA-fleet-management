import "package:dara_app/controller/singleton/persistent_data.dart";
import "package:dara_app/view/shared/info_dialog.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart";
import "package:dara_app/view/shared/colors.dart";
import "package:dara_app/view/shared/components.dart";
import "package:dara_app/view/shared/strings.dart";

class DatePickerField {
  String label;
  String selectedDate;

  DatePickerField({required this.label, required this.selectedDate});
}

class TimePickerField {
  String label;
  String selectedTime;

  TimePickerField({required this.label, required this.selectedTime});
}

class RPBookingDetails extends StatefulWidget {
  const RPBookingDetails({super.key});

  @override
  State<RPBookingDetails> createState() => _RPBookingDetailsState();
}

class _RPBookingDetailsState extends State<RPBookingDetails> {
  String selectedAddress = ProjectStrings.rp_bk_address_label;
  String selectedDateStartOrEnd = "";
  String selectedTimeStartOrEnd = "";
  final PersistentData _persistentData = PersistentData();
  bool rentWithDriver = false;


  final DatePickerField _startDateField = DatePickerField(
    label: ProjectStrings.rp_bk_starting_date_label,
    selectedDate: ProjectStrings.rp_bk_starting_date_label,
  );

  final DatePickerField _endDateField = DatePickerField(
    label: ProjectStrings.rp_bk_ending_date_label,
    selectedDate: ProjectStrings.rp_bk_ending_date_label,
  );

  final TimePickerField _startTimeField = TimePickerField(
    label: ProjectStrings.rp_bk_starting_time,
    selectedTime: ProjectStrings.rp_bk_starting_time,
  );

  final TimePickerField _endTimeField = TimePickerField(
    label: ProjectStrings.rp_bk_ending_time,
    selectedTime: ProjectStrings.rp_bk_ending_time,
  );

  Future<void> _selectDate(
      BuildContext context, DatePickerField datePickerField) async {

    final DateTime currentDate = DateTime.now();
    final DateTime initialDate = DateTime(currentDate.year, currentDate.month, currentDate.day);  // Set time to 00:00:00

    final DateTime? picked = await showRoundedDatePicker(
      context: context,
      height: 300,
      theme: ThemeData(
        primaryColor: Color(
            int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(
              int.parse(ProjectColors.mainColorHex.substring(2), radix: 16)),
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.red,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Color(
              int.parse(ProjectColors.blackBody.substring(2), radix: 16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(
                int.parse(ProjectColors.mainColorHex.substring(2), radix: 16))),
          ),
        ),
      ),
      initialDate: initialDate,  // Ensure the same date is used
      firstDate: initialDate,    // Restrict to today onwards
      lastDate: DateTime(currentDate.year + 100),  // Allow future dates
      borderRadius: 5,
    );

    if (picked != null) {
      setState(() {
        datePickerField.selectedDate =
            DateFormat("MMMM dd, yyyy").format(picked);

        if (selectedDateStartOrEnd == "start_date") {
          _persistentData.bookingDetailsStartingDate = datePickerField.selectedDate;
        } else if (selectedDateStartOrEnd == "end_date") {
          _persistentData.bookingDetailsEndingDate = datePickerField.selectedDate;
        }
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TimePickerField timePickerField) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(int.parse(ProjectColors.mainColorHex.substring(2),
                  radix: 16)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final pickedTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        timePickerField.selectedTime = DateFormat("hh:mm a").format(pickedTime);

        if (selectedTimeStartOrEnd == "start_time") {
          _persistentData.bookingDetailsStartingTime = timePickerField.selectedTime;
        } else if (selectedTimeStartOrEnd == "end_time") {
          _persistentData.bookingDetailsEndingTime = timePickerField.selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(int.parse(ProjectColors.mainColorBackground.substring(2),
            radix: 16)),
        child: Padding(
          padding: const EdgeInsets.only(top: 38),
          child: Column(
            children: [
              _buildAppBar(),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 30, bottom: 30),
                    child: Column(
                      children: [
                        //  start and end date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDateTimePickerColumn(
                                _startDateField,
                                _selectDate,
                                ProjectStrings.rp_bk_starting_date,
                              "start_date"
                            ),
                            _buildDateTimePickerColumn(_endDateField,
                                _selectDate, ProjectStrings.rp_bk_ending_date,
                              "end_date"
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        //  start and end time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimePickerColumn(
                                _startTimeField, _selectTime, "start_time"),
                            _buildTimePickerColumn(_endTimeField, _selectTime, "end_time"),
                          ],
                        ),

                        //  address
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Ensures alignment to start
                          children: [
                            CustomComponents.displayText(
                              ProjectStrings.rp_bk_address,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 7),
                            GestureDetector(
                              onTap: () async {
                                // Assuming the map screen returns the address as a result
                                final selectedLocation = await Navigator.of(context).pushNamed("map_screen");

                                if (selectedLocation != null) {
                                  setState(() {
                                    selectedAddress = selectedLocation as String;
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Color(int.parse(
                                        ProjectColors.darkGray.substring(2),
                                        radix: 16)),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 4, bottom: 4),
                                      child: Icon(
                                        Icons.location_pin,
                                        color: Color(int.parse(
                                            ProjectColors.darkGray.substring(2),
                                            radix: 16)),
                                        size: 22,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          selectedAddress,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey.shade600,
                                            fontFamily: ProjectStrings.general_font_family
                                          ),
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        //  book with a driver
                        const SizedBox(height: 30),
                        Container(
                          height: 90,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color(int.parse(
                                  ProjectColors.darkGray.substring(2),
                                  radix: 16)),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomComponents.displayText(
                                      ProjectStrings.rp_bk_book_driver,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 200,
                                      child: CustomComponents.displayText(
                                          ProjectStrings.rp_bk_book_driver_body,
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Switch(value: rentWithDriver, onChanged: (result) {
                                  setState(() {
                                    rentWithDriver = !rentWithDriver;
                                    _persistentData.bookingDetailsRentWithDriver = rentWithDriver;
                                  });
                                })
                              ],
                            ),
                          ),
                        ),

                        //  proceed button
                        const SizedBox(height: 200),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<
                                        Color>(
                                    Color(int.parse(
                                        ProjectColors.mainColorHex.substring(2),
                                        radix: 16))),
                                shape: MaterialStatePropertyAll<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            onPressed: () {
                              PersistentData _persistentData = PersistentData();

                              if (
                                _persistentData.bookingDetailsMapsLocationFromLongitudeLatitude == "" ||
                                _persistentData.bookingDetailsStartingDate == "" ||
                                _persistentData.bookingDetailsEndingDate == "" ||
                                _persistentData.bookingDetailsStartingTime == "" ||
                                _persistentData.bookingDetailsEndingTime == ""
                              ) {
                                InfoDialog().show(context: context, content: "Please ensure all required fields are filled out before proceeding. Missing information may prevent successful submission.", header: "Warning");
                              } else {
                                _persistentData.bookingDetailsMapsLocationFromLongitudeLatitude_forrent_location = _persistentData.bookingDetailsMapsLocationFromLongitudeLatitude;

                                //  check rent time date difference
                                String startTime = _persistentData.bookingDetailsStartingTime;
                                String startDate = _persistentData.bookingDetailsStartingDate;
                                String endTime = _persistentData.bookingDetailsEndingTime;
                                String endDate = _persistentData.bookingDetailsEndingDate;
                                debugPrint("Selected time difference: ${calculateStartEndDateTimeDifference("${startDate} | ${startTime}", "${endDate} | ${endTime}")}");

                                if (calculateStartEndDateTimeDifference("${startDate} | ${startTime}", "${endDate} | ${endTime}") < 720) {
                                  InfoDialog().show(
                                      context: context,
                                      content: "The rental duration must be at least 12 hours. Please review the time range you've entered.",
                                      header: "Warning"
                                  );

                                } else {
                                  _persistentData.rentalDurationInMinutes = calculateStartEndDateTimeDifference("${startDate} | ${startTime}", "${endDate} | ${endTime}");
                                  _persistentData.endMapsLatitude = double.parse(_persistentData.mapsLatitude);
                                  _persistentData.endMapsLongitude = double.parse(_persistentData.mapsLongitude);

                                  debugPrint("End maps latitude: ${_persistentData.mapsLatitude}");
                                  debugPrint("End maps latitude: ${_persistentData.mapsLongitude}");

                                  Navigator.of(context).pushNamed("rp_delivery_mode");
                                }
                              }
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                child: CustomComponents.displayText(
                                    ProjectStrings.rp_bk_proceed,
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int calculateStartEndDateTimeDifference(String startDateTimeString, String endDateTimeString) {
    DateFormat format = DateFormat("MMMM dd, yyyy | hh:mm a");
    DateTime startDateTime = format.parse(startDateTimeString);
    DateTime endDateTime = format.parse(endDateTimeString);

    Duration difference = endDateTime.difference(startDateTime);

    return difference.inMinutes;
  }

  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      height: 65,
      color: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset("lib/assets/pictures/left_arrow.png"),
          ),
          Center(
            child: CustomComponents.displayText(
              ProjectStrings.rp_bk_appbar_title,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimePickerColumn(DatePickerField datePickerField,
      Function(BuildContext, DatePickerField) selectDate, String headerName, String startOrEndDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomComponents.displayText(
          headerName,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () {
            selectDate(context, datePickerField);
            setState(() {
              selectedDateStartOrEnd = startOrEndDate;
            });
          },
          child: Container(
            width: 155,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Color(
                    int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                  child: Icon(
                    Icons.calendar_month,
                    color: Color(int.parse(ProjectColors.darkGray.substring(2),
                        radix: 16)),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                CustomComponents.displayText(
                  datePickerField.selectedDate,
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerColumn(TimePickerField timePickerField,
      Function(BuildContext, TimePickerField) selectTime, String startOrEndTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomComponents.displayText(
          timePickerField.label,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: () {
            selectTime(context, timePickerField); // Show time picker on tap
            setState(() {
              selectedTimeStartOrEnd = startOrEndTime;
            });
          },
          child: Container(
            width: 155,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Color(
                    int.parse(ProjectColors.darkGray.substring(2), radix: 16)),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                  child: Icon(
                    Icons.access_time,
                    color: Color(int.parse(ProjectColors.darkGray.substring(2),
                        radix: 16)),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 15),
                CustomComponents.displayText(
                  timePickerField.selectedTime,
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
