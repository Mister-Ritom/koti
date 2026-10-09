import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_providers.dart';
import 'theme_provider.dart';
import 'wallet_providers.dart';

final initialBalanceProvider = StateProvider<double>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getDouble('initialBalance') ?? 0.0;
});

final currentBalanceProvider = Provider<double>((ref) {
  final initialBalance = ref.watch(initialBalanceProvider);
  final transactionsAsync = ref.watch(transactionsProvider);
  final walletsAsync = ref.watch(walletsProvider);
  
  // If there are wallets, calculate balance dynamically across them
  double totalBalance = 0;
  bool useWallets = false;
  
  walletsAsync.whenData((wallets) {
    if (wallets.isNotEmpty) {
      useWallets = true;
      for (final wallet in wallets) {
        totalBalance += wallet.initialBalance;
      }
    }
  });
  
  if (!useWallets) {
    totalBalance = initialBalance;
  }
  
  return transactionsAsync.maybeWhen(
    data: (transactions) {
      double balance = totalBalance;
      for (final t in transactions) {
        if (t.type == 'income') {
          balance += t.amount;
        } else if (t.type == 'expense') {
          balance -= t.amount;
        }
      }
      return balance;
    },
    orElse: () => totalBalance,
  );
});

final hideBalanceProvider = StateNotifierProvider<HideBalanceNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return HideBalanceNotifier(prefs);
});

class HideBalanceNotifier extends StateNotifier<bool> {
  final dynamic prefs;
  
  HideBalanceNotifier(this.prefs) : super(prefs.getBool('hideBalance') ?? false);
  
  void toggle() {
    state = !state;
    prefs.setBool('hideBalance', state);
  }
}
