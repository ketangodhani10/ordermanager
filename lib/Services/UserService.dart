import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordermanager/Helpers/DbHelper.dart';

class UserService {
  DbHelper oDbHelper = new DbHelper();

  Future<QuerySnapshot> verifyUser(String userName, String password) async {
    return oDbHelper
        .getRef("users")
        .where("userName", isEqualTo: userName)
        .where("password", isEqualTo: password)
        .get();
  }
}
