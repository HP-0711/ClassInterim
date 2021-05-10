import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  getData() async {
    return await Firestore.instance.collection("Notices").snapshots();
  }
}
