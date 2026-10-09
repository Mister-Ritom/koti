import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Balance Calculation Logic', () {
    test('Correctly adds income and subtracts expenses', () {
      double initialBalance = 1000.0;
      double income = 500.0;
      double expense = 250.0;
      
      double current = initialBalance + income - expense;
      
      expect(current, 1250.0);
    });
  });
}
