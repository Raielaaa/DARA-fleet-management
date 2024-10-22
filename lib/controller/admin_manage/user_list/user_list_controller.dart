import 'package:dara_app/model/account/register_model.dart';

import '../../../services/firebase/firestore.dart';

class UserListController {
  Future<List<RegisterModel>> getCompleteUserList() async {
    return await Firestore().getCompleteUserList();
  }
}