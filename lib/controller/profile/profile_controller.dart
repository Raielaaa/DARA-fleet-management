import 'package:dara_app/model/renting_proccess/renting_process.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class ProfileController {
  Future<List<RentInformation>> retrieveRentInformationForProfile(String userUID) async {
    return await Firestore().getRentInformationForProfile(userUID);
  }
}