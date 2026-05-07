import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../bloc/mustcontrol_bloc.dart';


class ExpensePieChart extends StatelessWidget {
  const ExpensePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final data = provider.expenseBreakdown;

    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(child: Text("No Expense Data")),
      );
    }

    final total = data.values.fold(0.0, (a, b) => a + b);

    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    int index = 0;

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
            "Expense Breakdown",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 PIE CHART
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: data.entries.map((entry) {
                  final value = entry.value;
                  final percent = (value / total) * 100;

                  final color = colors[index % colors.length];
                  index++;

                  return PieChartSectionData(
                    value: value,
                    color: color,
                    radius: 60,
                    title: "${percent.toStringAsFixed(0)}%",
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 LEGEND
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: data.entries.map((entry) {
              final i = data.keys.toList().indexOf(entry.key);
              final color = colors[i % colors.length];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${entry.key} (${entry.value.toStringAsFixed(0)})",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}