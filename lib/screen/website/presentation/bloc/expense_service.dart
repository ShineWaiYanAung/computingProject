import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/expense/expense.dart';

class ExpenseService {
  final _db = FirebaseFirestore.instance;

  Stream<List<ExpenseEntity>> getExpenses(String businessId) {

    print("🚀 FETCHING EXPENSES FOR: $businessId");

    return _db
        .collection('expenses')
        .where('business_id', isEqualTo: businessId)
        .snapshots()
        .map((snapshot) {

      print("🔥 FIREBASE DOCS: ${snapshot.docs.length}");

      final List<ExpenseEntity> expenses = [];

      for (var doc in snapshot.docs) {

        try {

          final data = doc.data();

          print("📄 RAW DATA: $data");

          /// SAFE DATE
          DateTime createdAt = DateTime.now();

          final rawDate = data['created_at'];

          if (rawDate is Timestamp) {
            createdAt = rawDate.toDate();
          }
          else if (rawDate is String) {
            createdAt = DateTime.tryParse(rawDate)
                ?? DateTime.now();
          }

          expenses.add(
            ExpenseEntity(
              id: doc.id,
              businessId: data['business_id'] ?? '',
              type: data['type'] ?? '',
              category: data['category'] ?? 'Other',
              title: data['title'] ?? '',
              amount:
              (data['amount'] as num?)?.toDouble() ?? 0,
              frequency: data['frequency'] ?? '',
              createdAt: createdAt,
              createdBy: data['created_by'] ?? '',
              updatedAt: null,
              updatedBy: null,
            ),
          );

        } catch (e) {

          print("❌ EXPENSE PARSE ERROR: $e");

        }
      }

      print("✅ FINAL EXPENSE COUNT: ${expenses.length}");

      return expenses;
    });
  }
}