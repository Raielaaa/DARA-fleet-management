import 'package:dara_app/model/car_list/complete_car_list.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class CarListController {
  final Firestore _firestore = Firestore();

  Future<List<CompleteCarInfo>> fetchCars() {
    return _firestore.getCompleteCars();
  }

  Future<void> submitRentRecords({
    required String collectionName,
    required String documentName,
    required Map<String, String> data
  }) async {
    await _firestore.addRentRecords(collectionName: collectionName, documentName: documentName, data: data);
  }
}