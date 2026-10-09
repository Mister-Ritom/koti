import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/design/koti_colors.dart';
import '../../../core/design/koti_spacing.dart';
import '../../../providers/transaction_providers.dart';
import '../../../providers/currency_provider.dart';
import '../../../providers/balance_providers.dart';

class AllTransactionsScreen extends ConsumerWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final currency = ref.watch(currencyProvider);
    final hideBalance = ref.watch(hideBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text('No transactions yet.', style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: KotiSpacing.l, vertical: KotiSpacing.m),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              final isExpense = t.type == 'expense';
              final formattedAmount = t.amount.toStringAsFixed(2);
              final formattedDate = DateFormat('MMM d, yyyy').format(t.date);

              IconData icon;
              if (t.iconCodePoint != null) {
                icon = IconData(t.iconCodePoint!, fontFamily: t.fontFamily, fontPackage: t.fontPackage);
              } else {
                icon = isExpense ? Icons.shopping_bag : Icons.account_balance_wallet;
              }

              final titleText = (t.merchant != null && t.merchant!.isNotEmpty) 
                  ? t.merchant! 
                  : (t.description.isNotEmpty ? t.description : 'Transaction');

              return GestureDetector(
                onTap: () => context.push('/transaction/${t.uuid}'),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  margin: const EdgeInsets.only(bottom: KotiSpacing.s),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? KotiColors.darkSurfaceElevated : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (Theme.of(context).brightness == Brightness.light)
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: IgnorePointer(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: KotiSpacing.m, vertical: KotiSpacing.xs),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (isExpense ? KotiColors.expense : KotiColors.income).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: isExpense ? KotiColors.expense : KotiColors.income,
                        ),
                      ),
                      title: Text(titleText, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(formattedDate, style: const TextStyle(color: Colors.grey)),
                      trailing: Text(
                        hideBalance ? '****' : '$currency$formattedAmount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isExpense ? Theme.of(context).textTheme.bodyLarge?.color : KotiColors.income,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
