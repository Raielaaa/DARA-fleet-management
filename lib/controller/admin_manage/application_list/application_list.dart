import 'package:dara_app/model/driver/driver_application.dart';
import 'package:dara_app/model/outsource/OutsourceApplication.dart';
import 'package:dara_app/services/firebase/firestore.dart';

class ApplicationListController {
  Firestore _firestore = Firestore();

  Future<List<OutsourceApplication>> getOutsourceApplicationList() async {
    return await _firestore.getOutsourceApplications();
  }

  Future<List<DriverApplication>> getDriverApplicationList() async {
    return await _firestore.getDriverApplications();
  }
}