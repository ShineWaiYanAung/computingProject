import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/mustcontrol_bloc.dart';
import '../../data/constant/enum.dart';

class MiniSalesChart extends StatelessWidget {
  const MiniSalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final sales = provider.filteredSales;
    final filter = provider.filter;

    /// 🔥 STEP 1: GROUP DATA
    final Map<String, double> grouped = {};

    for (var sale in sales) {
      String key;

      switch (filter) {
        case TimeFilter.weekly:
        case TimeFilter.monthly:
          key =
          "${sale.createdAt.year}-${sale.createdAt.month}-${sale.createdAt.day}";
          break;

        case TimeFilter.yearly:
        case TimeFilter.allTime:
          key =
          "${sale.createdAt.year}-${sale.createdAt.month}";
          break;
      }

      grouped[key] = (grouped[key] ?? 0) + sale.subtotal;
    }

    /// 🔥 STEP 2: SORT
    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final values = entries.map((e) => e.value).toList();

    if (values.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    /// 🔥 STEP 3: NORMALIZE
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);

    final spots = <FlSpot>[];

    for (int i = 0; i < values.length; i++) {
      double normalized = 0;

      if (maxVal != minVal) {
        normalized = (values[i] - minVal) / (maxVal - minVal);
      }

      spots.add(FlSpot(i.toDouble(), normalized));
    }

    /// 🔥 STEP 4: BUILD CHART
    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1,

        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),

        /// 🔥 TOOLTIP (2 DECIMAL ONLY)
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  spot.y.toStringAsFixed(2), // 👈 FIXED HERE
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),

        /// 🔥 CHART STYLE
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,

            /// 🔥 COLOR (LOW → HIGH)
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.red,
                Colors.orange,
                Colors.green,
              ],
            ),

            /// 🔥 AREA COLOR
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.15),
                  Colors.orange.withOpacity(0.15),
                  Colors.green.withOpacity(0.15),
                ],
              ),
            ),

            /// 🔥 DOT COLOR BASED ON VALUE
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final y = spot.y;

                Color dotColor;

                if (y < 0.33) {
                  dotColor = Colors.red;
                } else if (y < 0.66) {
                  dotColor = Colors.orange;
                } else {
                  dotColor = Colors.green;
                }

                return FlDotCirclePainter(
                  radius: 3,
                  color: dotColor,
                  strokeWidth: 0,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class SalesOverviewCard extends StatelessWidget {
  const SalesOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    final totalSales = provider.filteredSales.length;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [

          /// 🔥 LEFT SIDE (DATA)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total Sell Overall",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "$totalSales",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 RIGHT SIDE (REAL CHART)
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 60,
              child: MiniSalesChart(),
            ),
          ),
        ],
      ),
    );
  }
}