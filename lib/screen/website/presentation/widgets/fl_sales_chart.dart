import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constant/enum.dart';
import '../bloc/mustcontrol_bloc.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final data = provider.itemsTrend;

    /// 🔥 SORT DATA
    final entries = data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    /// 🔥 MAX VALUE
    final maxVal =
    entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sales",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                minY: 0,
                maxY: maxVal.toDouble(),

                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),

                /// 🔥 AXES
                titlesData: FlTitlesData(
                  /// Y AXIS
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxVal / 2,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) {
                          return const Text("Low");
                        }
                        if (value < maxVal * 0.75) {
                          return const Text("Medium");
                        }
                        return const Text("High");
                      },
                    ),
                  ),

                  /// X AXIS
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= entries.length) {
                          return const SizedBox();
                        }

                        final key = entries[index].key;
                        final parts = key.split("-");

                        try {
                          /// WEEKLY → Mon Tue Wed
                          if (provider.filter == TimeFilter.weekly) {
                            final date = DateTime(
                              int.parse(parts[0]),
                              int.parse(parts[1]),
                              int.parse(parts[2]),
                            );

                            const days = [
                              "Mon","Tue","Wed","Thu","Fri","Sat","Sun"
                            ];

                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                days[date.weekday - 1],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }

                          /// MONTHLY → show every 3rd day
                          if (provider.filter == TimeFilter.monthly) {
                            if (index % 3 != 0) return const SizedBox();

                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                parts[2],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }

                          /// YEARLY → Jan Feb Mar
                          if (provider.filter == TimeFilter.yearly) {
                            const months = [
                              "Jan","Feb","Mar","Apr","May","Jun",
                              "Jul","Aug","Sep","Oct","Nov","Dec"
                            ];

                            final month = int.parse(parts[1]);

                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                months[month - 1],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }

                          /// ALL TIME → 2024 2025
                          if (provider.filter == TimeFilter.allTime) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                parts[0],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                        } catch (e) {
                          return const SizedBox(); // safe
                        }

                        return const SizedBox();
                      },
                    ),
                  ),

                  topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),

                /// 🔥 BARS (CLEAN BLUE)
                barGroups: List.generate(entries.length, (index) {
                  final value = entries[index].value.toDouble();

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        width: 12,
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue,
                      ),
                    ],
                  );
                }),

                /// 🔥 TOOLTIP
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final actualValue =
                          entries[group.x.toInt()].value;
                      return BarTooltipItem(
                        actualValue.toString(),
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}