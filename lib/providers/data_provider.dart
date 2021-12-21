import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application/models/weight_data.dart';

class DataProvider extends ChangeNotifier {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  DataProvider._();
  static DataProvider provider = DataProvider._();

  List<WeightData> _dataList = [];
  List<WeightData> get dataList => _dataList;

  void fetchWeight() {
    FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Weight")
        .orderBy('date', descending: true)
        .snapshots()
        .listen((event) {
      _dataList = [];
      for (int i = 0; i < event.docs.length; i++) {
        WeightData data = WeightData.fromMap(event.docs[i].data());
        data.docId = event.docs[i].id;
        _dataList.add(data);
      }
      notifyListeners();
    });
  }

  void addWeight(double weight) async {
    WeightData data = WeightData(weight: weight, date: DateTime.now());
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Weight")
        .doc()
        .set(data.toJson());
    notifyListeners();
  }

  Future<void> editWeight(double weight, String docId) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Weight")
        .doc(docId)
        .update({"weight": weight});
    notifyListeners();
  }

  Future<void> deleteWeight(String docId) async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(userId)
        .collection("Weight")
        .doc(docId)
        .delete();
    notifyListeners();
  }
}
