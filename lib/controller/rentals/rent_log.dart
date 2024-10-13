import 'package:dara_app/model/car_list/complete_car_list.dart';
import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/services/firebase/firestore.dart';
import 'package:intl/intl.dart';

class RentLog {
  int calculateDateDifference(String startDateTime, String endDateTime) {
    DateFormat format = DateFormat("MMMM dd, yyyy | hh:mm a");

    DateTime startDate = format.parse(startDateTime);
    DateTime endDate = format.parse(endDateTime);

    Duration difference = endDate.difference(startDate);

    return difference.inMinutes;
  }

  String getCurrentFormattedDateTime() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MMMM dd, yyyy | hh:mm a');
    return formatter.format(now);
  }

  Future<List<RentInformation>> getSelectedRentRecords({
    required String startDate,
    required String endDate,
    required String location
  }) async {
    return await Firestore().getSelectedRecordsInfo(startDate, endDate, location);
  }

  Future<CompleteCarInfo> getSelectedCarCompleteInfo({
    required String carName
  }) async {
    return await Firestore().getSelectedCarInformation(carName: carName);
  }
}