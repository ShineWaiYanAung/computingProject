import 'package:cloud_firestore/cloud_firestore.dart';

// your imports (keep as is)
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/expensemode.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/inventorymode.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/productmodel.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/salesmodel.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/bizmodel.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/usermodel.dart';

import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/expense/expense.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/inventory/inventoryEntity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/product/productEntity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/sales/salesentity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/business/bizentity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/userentity/userentity.dart';

class SeedData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> run() async {
    await createBusiness();
    await createUsers();
    await createProducts();

    // 🔥 IMPORTANT: use aligned generator
    await generateAlignedYearData();

    print("✅ ALL DATA UPLOADED");
  }

  // 🏢 BUSINESS
  Future<void> createBusiness() async {
    final business = BusinessEntity(
      id: "B-001",
      name: "Ocean Fish Shop",
      createdAt: DateTime.now(),
    );

    await firestore
        .collection('businesses')
        .doc(business.id)
        .set(BusinessModel.fromEntity(business).toJson());
  }

  // 👤 USERS
  Future<void> createUsers() async {
    final now = DateTime.now();

    final users = [
      UserEntity(id: "U-001", name: "John", role: "cashier", businessId: "B-001", createdAt: now),
      UserEntity(id: "U-002", name: "Mike", role: "staff", businessId: "B-001", createdAt: now),
      UserEntity(id: "U-003", name: "Sara", role: "staff", businessId: "B-001", createdAt: now),
      UserEntity(id: "U-004", name: "Ali", role: "staff", businessId: "B-001", createdAt: now),
      UserEntity(id: "U-005", name: "Tom", role: "staff", businessId: "B-001", createdAt: now),
    ];

    for (var user in users) {
      await firestore.collection('users').doc(user.id)
          .set(UserModel.fromEntity(user).toJson());
    }
  }

  // 🐟 PRODUCTS
  Future<void> createProducts() async {
    final now = DateTime.now();

    final products = [
      ProductEntity(id: "P-001", businessId: "B-001", name: "Tilapia", category: "fish", type: "weighted", createdAt: now, createdBy: "U-002"),
      ProductEntity(id: "P-002", businessId: "B-001", name: "Salmon", category: "fish", type: "weighted", createdAt: now, createdBy: "U-002"),
      ProductEntity(id: "P-003", businessId: "B-001", name: "Tuna", category: "fish", type: "weighted", createdAt: now, createdBy: "U-002"),
      ProductEntity(id: "P-004", businessId: "B-001", name: "Shrimp", category: "fish", type: "weighted", createdAt: now, createdBy: "U-002"),
      ProductEntity(id: "P-005", businessId: "B-001", name: "Crab", category: "fish", type: "weighted", createdAt: now, createdBy: "U-002"),
      ProductEntity(id: "P-006", businessId: "B-001", name: "Soft Drink", category: "shop", type: "fixed", createdAt: now, createdBy: "U-002"),
      ProductEntity(id: "P-007", businessId: "B-001", name: "Ice Pack", category: "shop", type: "fixed", createdAt: now, createdBy: "U-002"),
    ];

    for (var p in products) {
      await firestore.collection('products').doc(p.id)
          .set(ProductModel.fromEntity(p).toJson());
    }
  }

  // 💸 EXPENSES
  Future<void> addDailyExpenses(DateTime date) async {
    final expenses = [
      ExpenseEntity(
        id: "E-${date.millisecondsSinceEpoch}-1",
        businessId: "B-001",
        type: "expense",
        category: "ice",
        title: "Ice",
        amount: 20,
        frequency: "daily",
        createdAt: date,
        createdBy: "U-001",
      ),
      ExpenseEntity(
        id: "E-${date.millisecondsSinceEpoch}-2",
        businessId: "B-001",
        type: "salary",
        category: "staff",
        title: "Daily wages",
        amount: 100,
        frequency: "daily",
        createdAt: date,
        createdBy: "U-002",
      ),
    ];

    for (var e in expenses) {
      await firestore.collection('expenses').doc(e.id)
          .set(ExpenseModel.fromEntity(e).toJson());
    }
  }

  // 🔥 FULL ALIGNED SYSTEM
  Future<void> generateAlignedYearData() async {
    final startDate = DateTime(2025, 1, 1);

    List<InventoryEntity> inventoryPool = [];

    int invId = 1;
    int saleId = 1;

    for (int day = 0; day < 365; day++) {
      final date = startDate.add(Duration(days: day));

      // 📦 RESTOCK (every 3 days)
      if (day % 3 == 0) {
        final newStock = InventoryEntity(
          id: "I-${invId++}",
          productId: "P-001",
          businessId: "B-001",
          type: "weighted",
          stockQuantity: 50,
          costPrice: 6 + (day % 3),
          sellingPrice: 10 + (day % 3),
          isActive: true,
          createdAt: date,
          updatedAt: date,
          createdBy: "U-002",
        );

        inventoryPool.add(newStock);

        await firestore
            .collection('inventory')
            .doc(newStock.id)
            .set(InventoryModel.fromEntity(newStock).toJson());
      }

      // 🛒 SELL (FIFO)
      double demand = 20 + (day % 10);
      List<SaleItemEntity> items = [];

      for (int i = 0; i < inventoryPool.length; i++) {
        final inv = inventoryPool[i];

        if (!inv.isActive || inv.stockQuantity <= 0) continue;

        double used = demand > inv.stockQuantity
            ? inv.stockQuantity
            : demand;

        // ✅ update using copyWith (IMMUTABLE FIX)
        final updatedInv = inv.copyWith(
          stockQuantity: inv.stockQuantity - used,
          isActive: (inv.stockQuantity - used) > 0,
          updatedAt: date,
        );

        inventoryPool[i] = updatedInv; // 🔥 IMPORTANT

        demand -= used;

        items.add(SaleItemEntity(
          productId: inv.productId,
          name: "Tilapia",
          type: inv.type,
          quantity: used,
          pricePerUnit: inv.sellingPrice,
          total: used * inv.sellingPrice, costPerUnit: inv.costPrice,
        ));

        if (demand <= 0) break;
      }

      if (items.isEmpty) continue;

      double subtotal =
      items.fold(0.0, (sum, i) => sum + i.total);

      final sale = SaleEntity(
        id: "S-${saleId++}",
        businessId: "B-001",
        createdAt: date,
        createdBy: "U-001",
        items: items,
        subtotal: subtotal,
      );

      await firestore
          .collection('sales')
          .doc(sale.id)
          .set(SaleModel.fromEntity(sale).toJson());

      await addDailyExpenses(date);
    }
  }
}