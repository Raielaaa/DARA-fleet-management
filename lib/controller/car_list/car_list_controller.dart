import 'package:dara_app/model/car_list/complete_car_list.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class CarListController {
  final Firestore _firestore = Firestore();

  Future<List<CompleteCarInfo>> fetchCars() {
    return _firestore.getCompleteCars();
  }
}