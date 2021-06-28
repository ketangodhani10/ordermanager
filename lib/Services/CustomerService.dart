import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ordermanager/Helpers/DbHelper.dart';

class CustomerService {
  DbHelper oDbHelper = new DbHelper();

  Future<QuerySnapshot> getByStatusAndDate(int _status, String _date) async {
    return oDbHelper
        .getRef("customers")
        .where("status", isEqualTo: _status)
        .where("createdOn", isEqualTo: _date)
        .get();
  }
}
