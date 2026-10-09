import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/app_database.dart';
import '../data/database/daos/wallet_dao.dart';
import 'database_provider.dart';
import 'transaction_providers.dart';

final walletDaoProvider = Provider<WalletDao>((ref) {
  return ref.watch(databaseProvider).walletDao;
});

final walletsProvider = StreamProvider<List<Wallet>>((ref) {
  return ref.watch(walletDaoProvider).watchAllWallets();
});

final selectedWalletIdProvider = StateProvider<String?>((ref) => null);

// Helper to calculate balance per wallet
final walletBalanceProvider = Provider.family<AsyncValue<double>, Wallet>((ref, wallet) {
  final transactionsAsync = ref.watch(transactionsProvider);
  
  return transactionsAsync.maybeWhen(
    data: (transactions) {
      double balance = wallet.initialBalance;
      final walletTransactions = transactions.where((t) => t.walletId == wallet.id);
      
      for (final t in walletTransactions) {
        if (t.type == 'income') {
          balance += t.amount;
        } else if (t.type == 'expense') {
          balance -= t.amount;
        }
      }
      return AsyncData(balance);
    },
    orElse: () => const AsyncLoading(),
  );
});
