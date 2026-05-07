import 'package:cloud_firestore/cloud_firestore.dart';

// MODELS (UNCHANGED)
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/expensemode.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/inventorymode.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/productmodel.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/salesmodel.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/bizmodel.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/data/models/usermodel.dart';

// ENTITIES (UNCHANGED)
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/expense/expense.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/inventory/inventoryEntity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/product/productEntity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/sales/salesentity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/business/bizentity.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/domain/entities/userentity/userentity.dart';
import 'package:flutter/material.dart';


class SeedAutoScreen extends StatefulWidget {
  const SeedAutoScreen({super.key});

  @override
  State<SeedAutoScreen> createState() => _SeedAutoScreenState();
}

class _SeedAutoScreenState extends State<SeedAutoScreen> {
  final TextEditingController businessController = TextEditingController();

  bool isLoading = false;

  String? lastBusinessId; // 🔥 store last created

  // 🔥 AUTO PRODUCTS
  List<ProductEntity> generateProducts(String businessId) {
    final now = DateTime.now();

    final names = [
      "Rice","Sugar","Milk","Eggs","Bread",
      "Butter","Cheese","Flour","Salt","Oil",
      "Tea","Coffee","Biscuits","Juice","Cereal",
      "Tilapia","Salmon","Tuna","Shrimp","Crab"
    ];

    return List.generate(names.length, (i) {
      return ProductEntity(
        id: "P-${i + 1}",
        businessId: businessId,
        name: names[i],
        category: i < 10 ? "grocery" : "fish",
        type: i % 2 == 0 ? "weighted" : "fixed",
        createdAt: now,
        createdBy: "U-002",
      );
    });
  }

  /// ✅ GENERATE DATA
  Future<void> runSeed() async {
    if (businessController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    final businessId = "B-${DateTime.now().millisecondsSinceEpoch}";
    final products = generateProducts(businessId);

    try {
      await SeedData().run(
        businessId: businessId,
        businessName: businessController.text.trim(),
        products: products,
      );

      lastBusinessId = businessId; // 🔥 save for delete

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Data Generated")),
      );

      businessController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  /// 🧹 DELETE DATA
  Future<void> deleteData() async {
    if (lastBusinessId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No business to delete")),
      );
      return;
    }

    setState(() => isLoading = true);

    await SeedData().deleteAllData(lastBusinessId!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑 Data Deleted")),
    );

    lastBusinessId = null;

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    businessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auto Data Generator")),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// BUSINESS NAME
                TextField(
                  controller: businessController,
                  decoration: const InputDecoration(
                    labelText: "Business Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTONS
                isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                  children: [
                    /// GENERATE
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: runSeed,
                        child: const Text("Generate Data"),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DELETE
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: deleteData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Delete Data"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductForm {
  TextEditingController nameController = TextEditingController();
  String category = "fish";
  String type = "weighted";
}
class SeedData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ===========================
  // 🚀 MAIN RUN (DYNAMIC, NO JSON CHANGE)
  // ===========================
  Future<void> run({
    required String businessId,
    required String businessName,
    required List<ProductEntity> products, // 🔥 USER CONTROLS THIS
  }) async {
    await deleteAllData(businessId);

    await createBusiness(businessId, businessName);
    await createUsers(businessId);
    await createProducts(products);
    await generateAlignedYearData(businessId, products);

    print("✅ DATA GENERATED");
  }

  // ===========================
  // 🏢 BUSINESS
  // ===========================
  Future<void> createBusiness(String id, String name) async {
    final business = BusinessEntity(
      id: id,
      name: name,
      createdAt: DateTime.now(),
    );

    await firestore.collection('businesses').doc(id)
        .set(BusinessModel.fromEntity(business).toJson());
  }

  Future<void> deleteBusiness(String businessId) async {
    await firestore.collection('businesses').doc(businessId).delete();
  }

  // ===========================
  // 👤 USERS
  // ===========================
  Future<void> createUsers(String businessId) async {
    final now = DateTime.now();

    final users = [
      UserEntity(id: "U-001", name: "Owner", role: "cashier", businessId: businessId, createdAt: now),
      UserEntity(id: "U-002", name: "Staff", role: "staff", businessId: businessId, createdAt: now),
    ];

    for (var user in users) {
      await firestore.collection('users').doc(user.id)
          .set(UserModel.fromEntity(user).toJson());
    }
  }

  Future<void> deleteUsers(String businessId) async {
    final snap = await firestore.collection('users')
        .where('businessId', isEqualTo: businessId).get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  // ===========================
  // 🛒 PRODUCTS (NO HARDCODE)
  // ===========================
  Future<void> createProducts(List<ProductEntity> products) async {
    for (var p in products) {
      await firestore.collection('products').doc(p.id)
          .set(ProductModel.fromEntity(p).toJson());
    }
  }

  Future<void> deleteProducts(String businessId) async {
    final snap = await firestore.collection('products')
        .where('businessId', isEqualTo: businessId).get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  // ===========================
  // 💸 EXPENSES
  // ===========================
  Future<void> addDailyExpenses(DateTime date, String businessId) async {
    final expense = ExpenseEntity(
      id: "E-${date.millisecondsSinceEpoch}",
      businessId: businessId,
      type: "expense",
      category: "daily",
      title: "Daily Expense",
      amount: 50,
      frequency: "daily",
      createdAt: date,
      createdBy: "U-001",
    );

    await firestore.collection('expenses').doc(expense.id)
        .set(ExpenseModel.fromEntity(expense).toJson());
  }

  Future<void> deleteExpenses(String businessId) async {
    final snap = await firestore.collection('expenses')
        .where('businessId', isEqualTo: businessId).get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  // ===========================
  // 📦 INVENTORY + SALES (DYNAMIC PRODUCTS)
  // ===========================
  Future<void> generateAlignedYearData(
      String businessId,
      List<ProductEntity> products,
      ) async {
    final startDate = DateTime(2025, 1, 1);

    List<InventoryEntity> inventoryPool = [];

    int invId = 1;
    int saleId = 1;

    for (int day = 0; day < 365; day++) {
      final date = startDate.add(Duration(days: day));

      // 🔥 RESTOCK RANDOM PRODUCT
      if (day % 3 == 0) {
        final product = products[day % products.length];

        final stock = InventoryEntity(
          id: "I-${invId++}",
          productId: product.id,
          businessId: businessId,
          type: product.type,
          stockQuantity: 50,
          costPrice: 5,
          sellingPrice: 10,
          isActive: true,
          createdAt: date,
          updatedAt: date,
          createdBy: "U-002",
        );

        inventoryPool.add(stock);

        await firestore.collection('inventory').doc(stock.id)
            .set(InventoryModel.fromEntity(stock).toJson());
      }

      double demand = 20;
      List<SaleItemEntity> items = [];

      for (int i = 0; i < inventoryPool.length; i++) {
        final inv = inventoryPool[i];

        if (!inv.isActive || inv.stockQuantity <= 0) continue;

        double used = demand > inv.stockQuantity
            ? inv.stockQuantity
            : demand;

        inventoryPool[i] = inv.copyWith(
          stockQuantity: inv.stockQuantity - used,
          isActive: (inv.stockQuantity - used) > 0,
          updatedAt: date,
        );

        demand -= used;

        final product = products.firstWhere((p) => p.id == inv.productId);

        items.add(SaleItemEntity(
          productId: inv.productId,
          name: product.name,
          type: inv.type,
          quantity: used,
          pricePerUnit: inv.sellingPrice,
          total: used * inv.sellingPrice,
          costPerUnit: inv.costPrice,
        ));

        if (demand <= 0) break;
      }

      if (items.isEmpty) continue;

      final subtotal =
      items.fold(0.0, (sum, i) => sum + i.total);

      final sale = SaleEntity(
        id: "S-${saleId++}",
        businessId: businessId,
        createdAt: date,
        createdBy: "U-001",
        items: items,
        subtotal: subtotal,
      );

      await firestore.collection('sales').doc(sale.id)
          .set(SaleModel.fromEntity(sale).toJson());

      await addDailyExpenses(date, businessId);
    }
  }

  Future<void> deleteSales(String businessId) async {
    final snap = await firestore.collection('sales')
        .where('businessId', isEqualTo: businessId).get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteInventory(String businessId) async {
    final snap = await firestore.collection('inventory')
        .where('businessId', isEqualTo: businessId).get();

    for (var doc in snap.docs) {
      await doc.reference.delete();
    }
  }

  // ===========================
  // 🧹 DELETE ALL
  // ===========================
  Future<void> deleteAllData(String businessId) async {
    await deleteSales(businessId);
    await deleteInventory(businessId);
    await deleteExpenses(businessId);
    await deleteProducts(businessId);
    await deleteUsers(businessId);
    await deleteBusiness(businessId);
  }
}