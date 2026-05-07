import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/widgets/transcation.dart';
import 'package:flutter/material.dart';

import '../../bloc/mustcontrol_bloc.dart';
import '../../bloc/sales_service.dart';
import 'package:provider/provider.dart';

import '../../widgets/dummyCard.dart';
import '../../widgets/expense.dart';
import '../../widgets/fl_sales_chart.dart';
import '../../widgets/profits_card.dart';
import '../../widgets/revuencard.dart';
import '../../widgets/salesOveriwChart.dart';
import 'order_transation.dart';
class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    // 🔥 CONNECT DATA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardProvider.setSales(salesProvider.sales);
    });

    if (salesProvider.isLoading && salesProvider.sales.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (salesProvider.sales.isEmpty) {
      return const Center(child: Text("No Data Available"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // 🔥 RESPONSIVE BREAKPOINTS
        int crossAxisCount = 4;

        if (width < 1200) crossAxisCount = 3;
        if (width < 900) crossAxisCount = 2;
        if (width < 600) crossAxisCount = 1;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// 🔥 TOP CARDS
              GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.5,
                children: [
                  const RevenueCard(),
                  SalesOverviewCard(),
                  ProfitCard(),
                  ItemsAnalyticsCard(),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 CHART + PIE
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: SalesChart(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child:ExpensePieChart(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 TABLE
              TransactionsCard()
            ],
          ),
        );
      },
    );
  }
}