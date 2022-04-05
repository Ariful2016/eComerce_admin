
import 'package:ecomerce_admin/db/firestore_helper.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{
  Future<bool> checkAdmin(String email) => FirestoreHelper.checkAdmin(email);

}