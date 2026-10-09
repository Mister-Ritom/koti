import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/design/koti_colors.dart';
import '../../../core/design/koti_spacing.dart';
import '../../../core/design/koti_radii.dart';
import '../../../providers/transaction_providers.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/currency_provider.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final String uuid;

  const TransactionDetailScreen({super.key, required this.uuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          final tx = transactions.where((t) => t.uuid == uuid).firstOrNull;
          
          if (tx == null) {
            return const Center(child: Text('Transaction not found or deleted.'));
          }

          final isExpense = tx.type == 'expense';
          final currency = ref.watch(currencyProvider);
          final formattedAmount = tx.amount.toStringAsFixed(2);
          final formattedDate = DateFormat('EEEE, MMMM d, yyyy • h:mm a').format(tx.date);
          final note = tx.notes ?? "";

          IconData iconData = isExpense ? Icons.shopping_bag : Icons.account_balance_wallet;
          if (tx.iconCodePoint != null && tx.fontFamily != null) {
            iconData = IconData(tx.iconCodePoint!, fontFamily: tx.fontFamily, fontPackage: tx.fontPackage);
          }

          return ListView(
            padding: const EdgeInsets.all(KotiSpacing.l),
            children: [
              // Beautiful Header Card
              Container(
                padding: const EdgeInsets.all(KotiSpacing.xl),
                decoration: BoxDecoration(
                  color: isExpense ? KotiColors.expense.withValues(alpha: 0.1) : KotiColors.income.withValues(alpha: 0.1),
                  borderRadius: KotiRadii.roundedLarge,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(KotiSpacing.l),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Icon(iconData, size: 48, color: isExpense ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black) : KotiColors.income),
                    ),
                    const SizedBox(height: KotiSpacing.l),
                    Text(
                      ((tx.merchant != null && tx.merchant!.isNotEmpty) ? tx.merchant! : (tx.description.isNotEmpty ? tx.description : 'Transaction')),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: KotiSpacing.xs),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: KotiSpacing.xl),
                    Text(
                      '${isExpense ? "-" : "+"}$currency$formattedAmount',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: isExpense ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black) : KotiColors.income,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KotiSpacing.xxl),
              
              // Metadata
              _buildDetailRow(context, 'Type', isExpense ? 'Expense' : 'Income'),
              const Divider(height: 32),
              _buildDetailRow(context, 'Status', 'Completed', icon: Icons.check_circle, iconColor: Colors.green),
              if (note.isNotEmpty) ...[
                const Divider(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Note', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                    const SizedBox(height: KotiSpacing.s),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(KotiSpacing.m),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? KotiColors.darkSurfaceElevated 
                            : Colors.grey.withValues(alpha: 0.05),
                        borderRadius: KotiRadii.roundedMedium,
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.transparent 
                              : Colors.grey.withValues(alpha: 0.2)
                        ),
                      ),
                      child: Text(
                        note,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 48),
              
              // Actions
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Transaction?'),
                        content: const Text('This will permanently remove this record from your history and update your balance.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await ref.read(transactionDaoProvider).deleteTransaction(tx.id);
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete Transaction'),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {IconData? icon, Color? iconColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
            ],
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }
}
