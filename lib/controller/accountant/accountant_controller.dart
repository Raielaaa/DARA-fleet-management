import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class AccountantController {
  Future<List<RentInformation>> getAccountantRawList() async {
    return await Firestore().getAccountantRecords();
  }

  Future<void> updateRentRecords({
    required RentInformation selectedRentInformation,
    String? newStartDate,
    String? newEndDate,
    String? newStartTime,
    String? newEndTime,
    String? newAmount
  }) async {
    Firestore().updateRentRecordsFromAccountant(
      selectedRentInformation: selectedRentInformation,
      newStartDate: newStartDate,
      newEndDate: newEndDate,
      newStartTime: newStartTime,
      newEndTime: newEndTime,
      newAmount: newAmount
    );
  }
}