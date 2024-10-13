import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/services/firebase/firestore.dart';
import 'package:intl/intl.dart';

class ProfileController {
  Future<List<RentInformation>> retrieveRentInformationForProfile(String userUID) async {
    return await Firestore().getRentInformationForProfile(userUID);
  }

  int calculateDateDifference(String startDateTime, String endDateTime) {
    DateFormat format = DateFormat("MMMM dd, yyyy | hh:mm a");

    DateTime startDate = format.parse(startDateTime);
    DateTime endDate = format.parse(endDateTime);

    Duration difference = endDate.difference(startDate);

    return difference.inMinutes;
  }

  String convertMinutesToString(int totalMinutes) {
    int days = totalMinutes ~/ 1440; // 1 day = 1440 minutes
    int hours = (totalMinutes % 1440) ~/ 60; // Remaining hours
    int minutes = totalMinutes % 60; // Remaining minutes

    return "${days.toString().padLeft(2, '0')} Days "
        "${hours.toString().padLeft(2, '0')} Hours "
        "${minutes.toString().padLeft(2, '0')} Minutes";
  }
}