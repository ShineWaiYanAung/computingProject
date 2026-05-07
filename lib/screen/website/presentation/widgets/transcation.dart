import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/mustcontrol_bloc.dart';


class TransactionsCard extends StatelessWidget {
  const TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final sales = provider.filteredSales;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 TITLE
          const Text(
            "Transactions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: Text("ID", style: TextStyle(color: Colors.grey))),
              Expanded(child: Text("Item", style: TextStyle(color: Colors.grey))),
              Expanded(child: Text("Date", style: TextStyle(color: Colors.grey))),
              Expanded(child: Text("Qty", style: TextStyle(color: Colors.grey))),
              Expanded(child: Text("Amount", style: TextStyle(color: Colors.grey))),
            ],
          ),

          const Divider(height: 20),

          /// 🔥 LIST
          SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];

                /// 👉 take first item (simple view)
                final item = sale.items.isNotEmpty ? sale.items.first : null;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ID
                      Expanded(
                        child: Text(
                          sale.id.toString(),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      /// ITEM
                      Expanded(
                        child: Text(
                          item?.name ?? "-",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      /// DATE
                      Expanded(
                        child: Text(
                          "${sale.createdAt.day}/${sale.createdAt.month}/${sale.createdAt.year}",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      /// QTY
                      Expanded(
                        child: Text(
                          item != null ? item.quantity.toString() : "0",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      /// AMOUNT
                      Expanded(
                        child: Text(
                          sale.subtotal.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}