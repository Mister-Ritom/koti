import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import 'database_provider.dart';

final transactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final dao = ref.watch(transactionDaoProvider);
  return dao.watchAllTransactions();
});

final earliestDateProvider = Provider<DateTime>((ref) {
  final transactions = ref.watch(transactionsProvider).valueOrNull;
  if (transactions == null || transactions.isEmpty) {
    return DateTime.now();
  }
  
  DateTime earliest = transactions.first.date;
  for (final t in transactions) {
    if (t.date.isBefore(earliest)) {
      earliest = t.date;
    }
  }
  return earliest;
});
