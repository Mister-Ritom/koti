import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database/app_database.dart';
import '../../providers/transaction_providers.dart';

final monthlyAnalyticsProvider = Provider.family<AsyncValue<MonthlyReport>, DateTime>((ref, month) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.whenData((transactions) {
    return AnalyticsService.generateMonthlyReport(transactions, month);
  });
});

class MonthlyReport {
  final DateTime month;
  final double totalIncome;
  final double totalExpense;
  final double netChange;
  final Map<String, double> categoryBreakdown; // By Merchant/Description
  final Map<int, double> dailySpending; // Day of month -> amount spent
  final List<String> insights;
  final Transaction? largestExpense;
  final int totalTransactions;
  final double averageDailySpend;

  MonthlyReport({
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.netChange,
    required this.categoryBreakdown,
    required this.dailySpending,
    required this.insights,
    required this.totalTransactions,
    required this.averageDailySpend,
    this.largestExpense,
  });
}

class AnalyticsService {
  static MonthlyReport generateMonthlyReport(List<Transaction> allTransactions, DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    
    final monthTransactions = allTransactions.where((t) => 
      t.date.isAfter(start.subtract(const Duration(seconds: 1))) && 
      t.date.isBefore(end.add(const Duration(seconds: 1)))
    ).toList();

    double income = 0;
    double expense = 0;
    Map<String, double> categories = {};
    Map<int, double> daily = {};
    Transaction? largest;
    int expenseCount = 0;

    for (final t in monthTransactions) {
      if (t.type == 'income') {
        income += t.amount;
      } else {
        expense += t.amount;
        expenseCount++;
        
        // Category breakdown (Group by first word or full description)
        categories[t.description] = (categories[t.description] ?? 0) + t.amount;
        
        // Daily spending breakdown
        final day = t.date.day;
        daily[day] = (daily[day] ?? 0) + t.amount;
        
        if (largest == null || t.amount > largest.amount) {
          largest = t;
        }
      }
    }

    // Sort categories by highest spend
    var sortedCategories = Map.fromEntries(
      categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value))
    );

    // Calculate Days Passed (for average daily spend)
    final now = DateTime.now();
    int daysPassed = (month.year == now.year && month.month == now.month) 
        ? now.day 
        : end.day;
    double avgDaily = daysPassed > 0 ? (expense / daysPassed) : 0;

    // --- Generate Advanced Insights ---
    List<String> insights = [];
    
    // Net Flow Insight
    if (expense > income && income > 0) {
      insights.add("You've spent \$${(expense - income).toStringAsFixed(2)} more than you brought in this month.");
    } else if (income > expense) {
      insights.add("Excellent! You are running a surplus of \$${(income - expense).toStringAsFixed(2)} this month.");
    }

    // Velocity Insight
    if (avgDaily > 0) {
      insights.add("You are spending an average of \$${avgDaily.toStringAsFixed(2)} per day.");
    }

    // Frequency Insight
    if (expenseCount > 0) {
      insights.add("You made $expenseCount purchases this month.");
    }

    // Largest Expense Insight
    if (largest != null) {
      insights.add("Your heaviest single hit was \$${largest.amount.toStringAsFixed(2)} at ${largest.description}.");
    }
    
    // Highest Spending Day Insight
    if (daily.isNotEmpty) {
      var busiestDay = daily.entries.reduce((a, b) => a.value > b.value ? a : b);
      if (busiestDay.value > (avgDaily * 2)) {
        insights.add("Watch out—on the ${busiestDay.key}th you spent \$${busiestDay.value.toStringAsFixed(2)}, making it your highest spending day.");
      }
    }

    return MonthlyReport(
      month: month,
      totalIncome: income,
      totalExpense: expense,
      netChange: income - expense,
      categoryBreakdown: sortedCategories,
      dailySpending: daily,
      insights: insights,
      totalTransactions: monthTransactions.length,
      averageDailySpend: avgDaily,
      largestExpense: largest,
    );
  }
}
