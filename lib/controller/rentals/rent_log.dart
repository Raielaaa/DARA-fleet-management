import 'package:dara_app/model/car_list/complete_car_list.dart';
import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class RentLog {
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