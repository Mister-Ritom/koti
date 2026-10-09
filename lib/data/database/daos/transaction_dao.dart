import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';
import '../tables/categories_table.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions, Categories])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<Transaction>> getAllTransactions() {
    return (select(transactions)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .get();
  }
  
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }
  
  Stream<List<Transaction>> watchTransactionsByMonth(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    return (select(transactions)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<int> insertTransaction(Insertable<Transaction> transaction) {
    return into(transactions).insert(transaction);
  }

  Future<bool> updateTransaction(Insertable<Transaction> transaction) {
    return update(transactions).replace(transaction);
  }

  Future<int> deleteTransaction(int id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }
}
