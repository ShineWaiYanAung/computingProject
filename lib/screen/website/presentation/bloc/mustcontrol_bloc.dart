import 'package:flutter/cupertino.dart';
import '../../data/constant/enum.dart';
import '../../domain/entities/expense/expense.dart';
import '../../domain/entities/sales/salesentity.dart';

class DashboardProvider extends ChangeNotifier {
  TimeFilter _filter = TimeFilter.weekly;
  List<ExpenseEntity> _expenses = [];

  List<ExpenseEntity> get expenses => _expenses;
  TimeFilter get filter => _filter;

  List<SaleEntity> _allSales = [];
  List<SaleEntity> filteredSales = [];

  //  set filter from UI
  void setFilter(TimeFilter newFilter) {
    _filter = newFilter;
    _applyFilter();
    notifyListeners();
  }

  // receive real-time data
  void setSales(List<SaleEntity> sales) {
    _allSales = sales;
    _applyFilter();
    notifyListeners();
  }

  //  FILTER LOGIC
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

  //  REVENUE
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
  //  PROFIT
  double get profit {
    double total = 0;

    for (var sale in filteredSales) {
      for (var item in sale.items) {
        total += (item.pricePerUnit - item.costPerUnit) * item.quantity;
      }
    }

    return total;
  }
  double get profitGrowth {
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
        final weekday = now.weekday;
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

    double currentProfit = 0;
    double previousProfit = 0;

    for (var sale in _allSales) {
      for (var item in sale.items) {
        final profit =
            (item.pricePerUnit - item.costPerUnit) * item.quantity;

        if (!sale.createdAt.isBefore(currentStart) &&
            sale.createdAt.isBefore(currentEnd)) {
          currentProfit += profit;
        }

        if (!sale.createdAt.isBefore(previousStart) &&
            sale.createdAt.isBefore(previousEnd)) {
          previousProfit += profit;
        }
      }
    }

    if (previousProfit == 0) return 0;

    return ((currentProfit - previousProfit) / previousProfit) * 100;
  }
  // order
// =========================
// 📦 ITEMS ANALYTICS

  void setExpenses(List<ExpenseEntity>? data) {
    _expenses = data ?? [];
    notifyListeners();
  }
// 🔹 Total items sold (all transactions)
  int get totalItemsSold {
    int total = 0;

    for (var sale in filteredSales) {
      for (var item in sale.items) {
        total += item.quantity.toInt();
      }
    }

    return total;
  }

// 🔹 Average items per transaction
  double get itemsPerTransaction {
    if (filteredSales.isEmpty) return 0;

    return totalItemsSold / filteredSales.length;
  }

// 🔹 Items growth (like revenueGrowth)
  double get itemsGrowth {
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
        final weekday = now.weekday;
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

    int current = 0;
    int previous = 0;

    for (var sale in _allSales) {
      for (var item in sale.items) {
        if (!sale.createdAt.isBefore(currentStart) &&
            sale.createdAt.isBefore(currentEnd)) {
          current += item.quantity.toInt();
        }

        if (!sale.createdAt.isBefore(previousStart) &&
            sale.createdAt.isBefore(previousEnd)) {
          previous += item.quantity.toInt();
        }
      }
    }

    if (previous == 0) return 0;

    return ((current - previous) / previous) * 100;
  }

// 🔹 Items trend (for chart)
  Map<String, int> get itemsTrend {
    final Map<String, int> grouped = {};

    for (var sale in filteredSales) {
      String key;

      switch (_filter) {
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

      for (var item in sale.items) {
        grouped[key] = (grouped[key] ?? 0) + item.quantity.toInt();
      }
    }

    return grouped;
  }
  Map<String, double> get expenseBreakdown {

    final Map<String, double> grouped = {};

    if (_expenses.isEmpty) return grouped;

    final now = _expenses
        .map((e) => e.createdAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);

    DateTime start;
    DateTime end;

    switch (_filter) {

    /// WEEKLY
      case TimeFilter.weekly:

        final weekday = now.weekday;

        start = DateTime(
          now.year,
          now.month,
          now.day - (weekday - 1),
        );

        end = start.add(
          const Duration(days: 7),
        );

        break;

    /// MONTHLY
      case TimeFilter.monthly:

        start = DateTime(
          now.year,
          now.month,
          1,
        );

        end = DateTime(
          now.year,
          now.month + 1,
          1,
        );

        break;

    /// YEARLY
      case TimeFilter.yearly:

        start = DateTime(
          now.year,
          1,
          1,
        );

        end = DateTime(
          now.year + 1,
          1,
          1,
        );

        break;

    /// ALL TIME
      case TimeFilter.allTime:

        for (var e in _expenses) {

          grouped[e.category] =
              (grouped[e.category] ?? 0)
                  + e.amount;
        }

        return grouped;
    }

    /// 🔥 FILTERED EXPENSES
    final filtered = _expenses.where((e) {

      return !e.createdAt.isBefore(start)
          && e.createdAt.isBefore(end);

    }).toList();

    /// 🔥 GROUP BY CATEGORY
    for (var e in filtered) {

      grouped[e.category] =
          (grouped[e.category] ?? 0)
              + e.amount;
    }

    print("📊 FILTER: $_filter");
    print("📈 EXPENSE BREAKDOWN: $grouped");

    return grouped;
  }

}