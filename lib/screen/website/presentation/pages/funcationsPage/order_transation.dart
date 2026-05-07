import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/mustcontrol_bloc.dart';

class ItemsAnalyticsCard extends StatelessWidget {
  const ItemsAnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (_, provider, __) {
        final total = provider.totalItemsSold;
        final avg = provider.itemsPerTransaction;
        final growth = provider.itemsGrowth;

        final isPositive = growth >= 0;

        return Container(
          padding: const EdgeInsets.all(8),
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
              const Text(
                "Items Sold",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 10),

              /// 🔥 TOTAL
              Text(
                total.toString(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),



              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// 🔥 GROWTH
                  Text(
                    "${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 12,
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// 🔥 AVG
                  Text(
                    "Avg: ${avg.toStringAsFixed(1)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )

              /// 🔥 MINI CHART
              // const SizedBox(
              //   height: 60,
              //   child: MiniItemsChart(),
              // ),
            ],
          ),
        );
      },
    );
  }
}
class MiniItemsChart extends StatelessWidget {
  const MiniItemsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final data = provider.itemsTrend;

    final values = data.values.toList();

    if (values.isEmpty) {
      return const Center(child: Text("No Data"));
    }

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);

    final spots = <FlSpot>[];

    for (int i = 0; i < values.length; i++) {
      double normalized = 0.5;

      if (maxVal != minVal) {
        normalized = (values[i] - minVal) / (maxVal - minVal);
      }

      spots.add(FlSpot(i.toDouble(), normalized));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 1,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,

            /// 🔥 COLOR GRADIENT (your requirement)
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.orange, Colors.green],
            ),

            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.2),
                  Colors.orange.withOpacity(0.2),
                  Colors.green.withOpacity(0.2),
                ],
              ),
            ),

            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}