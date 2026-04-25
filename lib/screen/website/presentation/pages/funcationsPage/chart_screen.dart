import 'package:flutter/material.dart';
import '../../bloc/mustcontrol_bloc.dart';
import '../../bloc/sales_service.dart';
import 'package:provider/provider.dart';

import '../../widgets/revuencard.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();
    final dashboardProvider = context.read<DashboardProvider>();

    // 🔥 CONNECT DATA HERE
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashboardProvider.setSales(salesProvider.sales);
    });
    /// 🔄 SHOW LOADING ONLY IF NO DATA YET
    if (salesProvider.isLoading && salesProvider.sales.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    /// ❌ NO DATA AFTER LOADING
    if (salesProvider.sales.isEmpty) {
      return const Center(
        child: Text("No Data Available"),
      );
    }

    /// ✅ SHOW CHART
    return RevenueCard();
  }


}
