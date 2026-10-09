import 'package:flutter_test/flutter_test.dart';
import 'package:koti/data/database/app_database.dart';
import 'package:koti/domain/services/analytics_service.dart';

void main() {
  group('AnalyticsService', () {
    test('generateMonthlyReport calculates totals correctly', () {
      final now = DateTime(2024, 6, 15);
      final transactions = [
        Transaction(
          id: 1, uuid: '1', amount: 500, type: 'income', description: 'Salary', date: now,
          currency: 'USD', isRecurring: false, createdAt: now, updatedAt: now,
          iconCodePoint: null, fontFamily: null, fontPackage: null, categoryId: null, merchant: null, notes: null, paymentMethod: null
        ),
        Transaction(
          id: 2, uuid: '2', amount: 100, type: 'expense', description: 'Groceries', date: now,
          currency: 'USD', isRecurring: false, createdAt: now, updatedAt: now,
          iconCodePoint: null, fontFamily: null, fontPackage: null, categoryId: null, merchant: null, notes: null, paymentMethod: null
        ),
        Transaction(
          id: 3, uuid: '3', amount: 50, type: 'expense', description: 'Groceries', date: now,
          currency: 'USD', isRecurring: false, createdAt: now, updatedAt: now,
          iconCodePoint: null, fontFamily: null, fontPackage: null, categoryId: null, merchant: null, notes: null, paymentMethod: null
        ),
      ];

      final report = AnalyticsService.generateMonthlyReport(transactions, now);

      expect(report.totalIncome, 500);
      expect(report.totalExpense, 150);
      expect(report.netChange, 350);
      expect(report.categoryBreakdown['Groceries'], 150);
    });

    test('generateMonthlyReport excludes transactions outside month', () {
      final june = DateTime(2024, 6, 15);
      final july = DateTime(2024, 7, 5);
      
      final transactions = [
        Transaction(
          id: 1, uuid: '1', amount: 500, type: 'income', description: 'Salary', date: june,
          currency: 'USD', isRecurring: false, createdAt: june, updatedAt: june,
          iconCodePoint: null, fontFamily: null, fontPackage: null, categoryId: null, merchant: null, notes: null, paymentMethod: null
        ),
        Transaction(
          id: 2, uuid: '2', amount: 100, type: 'expense', description: 'Rent', date: july,
          currency: 'USD', isRecurring: false, createdAt: july, updatedAt: july,
          iconCodePoint: null, fontFamily: null, fontPackage: null, categoryId: null, merchant: null, notes: null, paymentMethod: null
        ),
      ];

      final report = AnalyticsService.generateMonthlyReport(transactions, june);

      expect(report.totalIncome, 500);
      expect(report.totalExpense, 0); // July transaction excluded
    });
  });
}
