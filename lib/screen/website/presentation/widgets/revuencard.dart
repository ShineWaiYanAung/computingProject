import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/mustcontrol_bloc.dart';
class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (_, provider, __) {
        final revenue = provider.revenue;
        final growth = provider.revenueGrowth;

        final isPositive = growth >= 0;

        return Container(
          width: 400,
          height: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Revenue (USD)",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 10),

              Text(
                revenue.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

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