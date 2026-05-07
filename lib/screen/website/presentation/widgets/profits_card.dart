import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/mustcontrol_bloc.dart';

class ProfitCard extends StatelessWidget {
  const ProfitCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (_, provider, __) {
        final profit = provider.profit;
        final growth = provider.profitGrowth;

        final isPositive = growth >= 0;

        return Container(
          padding: const EdgeInsets.all(6),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Total Profit (USD)",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 8),

              /// 🔥 PROFIT VALUE
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  profit.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              /// 🔥 GROWTH %
              Text(
                "${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}