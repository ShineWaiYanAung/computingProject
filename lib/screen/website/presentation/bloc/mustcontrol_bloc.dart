import 'package:flutter/cupertino.dart';
import '../../data/constant/enum.dart';
import '../../domain/entities/sales/salesentity.dart';

class DashboardProvider extends ChangeNotifier {
  TimeFilter _filter = TimeFilter.weekly;

  TimeFilter get filter => _filter;

  List<SaleEntity> _allSales = [];
  List<SaleEntity> filteredSales = [];

  // 🔥 set filter from UI
  void setFilter(TimeFilter newFilter) {
    _filter = newFilter;
    _applyFilter();
    notifyListeners();
  }

  // 🔥 receive real-time data
  void setSales(List<SaleEntity> sales) {
    _allSales = sales;
    _applyFilter();
    notifyListeners();
  }

  // 🔥 FILTER LOGIC
  void _applyFilter() {
    if (_allSales.isEmpty) {
      filteredSales = [];
      return;
    }

    final now = _allSales.last.createdAt;

    DateTime start;
    DateTime end;

    switch (_filter) {
      case TimeFilter.weekly:
        final weekday = now.weekday;
        start = DateTime(now.year, now.month, now.day - (weekday - 1));
        end = start.add(const Duration(days: 7));
        break;

      case TimeFilter.monthly:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1);
        break;

      case TimeFilter.yearly:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year + 1, 1, 1);
        break;

      case TimeFilter.allTime:
        filteredSales = _allSales;
        return;
    }

    filteredSales = _allSales
        .where((s) =>
    s.createdAt.isAfter(start) &&
        s.createdAt.isBefore(end))
        .toList();
  }

  // 🔥 REVENUE
  double get revenue =>
      filteredSales.fold(0, (sum, s) => sum + s.subtotal);
  // RevenueGrowth
  double get revenueGrowth {
    if (_allSales.isEmpty) return 0;

    final now = _allSales
        .map((e) => e.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    DateTime currentStart;
    DateTime currentEnd;
    DateTime previousStart;
    DateTime previousEnd;

    switch (_filter) {
      case TimeFilter.weekly:
        final weekday = now.weekday; // 1 = Monday
        currentStart = DateTime(now.year, now.month, now.day - (weekday - 1));
        currentEnd = currentStart.add(const Duration(days: 7));

        previousStart = currentStart.subtract(const Duration(days: 7));
        previousEnd = currentStart;
        break;

      case TimeFilter.monthly:
        currentStart = DateTime(now.year, now.month, 1);
        currentEnd = DateTime(now.year, now.month + 1, 1);

        previousStart = DateTime(now.year, now.month - 1, 1);
        previousEnd = currentStart;
        break;

      case TimeFilter.yearly:
        currentStart = DateTime(now.year, 1, 1);
        currentEnd = DateTime(now.year + 1, 1, 1);

        previousStart = DateTime(now.year - 1, 1, 1);
        previousEnd = currentStart;
        break;

      case TimeFilter.allTime:
        return 0;
    }

    double currentRevenue = _allSales
        .where((s) =>
    !s.createdAt.isBefore(currentStart) &&  // ✅ include start
        s.createdAt.isBefore(currentEnd))       // keep end exclusive
        .fold(0, (sum, s) => sum + s.subtotal);

    double previousRevenue = _allSales
        .where((s) =>
    !s.createdAt.isBefore(previousStart) && // ✅ include start
        s.createdAt.isBefore(previousEnd))
        .fold(0, (sum, s) => sum + s.subtotal);

    print("FILTER: $_filter");
    print("Current Revenue: $currentRevenue");
    print("Previous Revenue: $previousRevenue");
    if (previousRevenue == 0) return 0;

    return ((currentRevenue - previousRevenue) / previousRevenue) * 100;

  }
  // 🔥 PROFIT
  double get profit {
    double total = 0;

    for (var sale in filteredSales) {
      for (var item in sale.items) {
        total += (item.pricePerUnit - item.costPerUnit) * item.quantity;
      }
    }

    return total;
  }
}