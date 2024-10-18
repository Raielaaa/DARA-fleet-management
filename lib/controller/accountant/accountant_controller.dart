import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class AccountantController {
  Future<List<RentInformation>> getAccountantRawList() async {
    return await Firestore().getAccountantRecords();
  }
}