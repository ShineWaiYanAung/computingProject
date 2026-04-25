import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/bizmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

Stream<List<BusinessModel>> getBusinesses() {
  return FirebaseFirestore.instance
      .collection('businesses')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => BusinessModel.fromJson(doc.data()))
      .toList());
}

class BusinessProvider extends ChangeNotifier {
  BusinessModel? _selected;

  BusinessModel? get selected => _selected;

  void selectBusiness(BusinessModel business) {
    _selected = business;
    notifyListeners();
  }
}