import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/salesmodel.dart';
import '../../domain/entities/sales/salesentity.dart';
import 'mustcontrol_bloc.dart';
import 'package:provider/provider.dart';
class SalesService {
  final _fireStore = FirebaseFirestore.instance;

  Stream<List<SaleEntity>> streamSales() {
    return _fireStore
        .collection('sales')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SaleModel.fromJson(doc.data()).toEntity())
          .toList();
    });
  }
}
class SalesProvider extends ChangeNotifier {
  final SalesService _service = SalesService();

  List<SaleEntity> sales = [];

  void startListening(BuildContext context) {
    _service.streamSales().listen((data) {
      sales = data;
      context.read<DashboardProvider>().setSales(sales);
      notifyListeners(); // 🔥 UI updates instantly
    });
  }
}