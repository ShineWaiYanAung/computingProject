import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/salesmodel.dart';
import '../../domain/entities/sales/salesentity.dart';
import 'mustcontrol_bloc.dart';
import 'package:provider/provider.dart';
class SalesService {
  final _fireStore = FirebaseFirestore.instance;

  Stream<List<SaleEntity>> streamSales(String businessId) {
    return _fireStore
        .collection('sales')
        .where('business_id', isEqualTo: businessId) // ✅ correct field
        .orderBy('created_at', descending: true)     // ✅ now safe
        .snapshots()
        .map((snapshot) {
      print("📥 SNAPSHOT SIZE: ${snapshot.docs.length}");

      return snapshot.docs
          .map((doc) =>
          SaleModel.fromJson(doc.data()).toEntity())
          .toList();
    });
  }
}
class SalesProvider extends ChangeNotifier {
  final SalesService _service = SalesService();

  List<SaleEntity> sales = [];
  bool isLoading = true; // 🔥 ADD THIS

  void startListening(String businessId) {
    print("🔥 START LISTENING: $businessId");

    isLoading = true;
    notifyListeners();

    _service.streamSales(businessId).listen(
          (data) {
        print("✅ DATA RECEIVED: ${data.length}");

        sales = data;
        isLoading = false;



        notifyListeners();
      },
      onError: (error) {
        print("❌ ERROR FROM FIRESTORE: $error");

        isLoading = false; // 🔥 VERY IMPORTANT
        notifyListeners();
      },
    );
  }

}