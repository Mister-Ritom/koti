import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../core/design/koti_colors.dart';
import '../../core/design/koti_spacing.dart';
import '../../core/design/koti_radii.dart';
import '../../providers/balance_providers.dart';
import '../../providers/transaction_providers.dart';
import '../../providers/currency_provider.dart';
import '../../data/database/app_database.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(KotiSpacing.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BalanceCard(),
                  const SizedBox(height: KotiSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => context.push('/all-transactions'),
                        child: const Text('See all', style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  const SizedBox(height: KotiSpacing.m),
                  const _TransactionList(),
                ],
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)), // Space for bottom nav
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(KotiSpacing.l, KotiSpacing.xxl, KotiSpacing.l, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('My Wallet', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text('Welcome Back', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? KotiColors.darkSurfaceElevated : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (Theme.of(context).brightness == Brightness.light)
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: IconButton(
                  icon: Icon(ref.watch(hideBalanceProvider) ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                  onPressed: () => ref.read(hideBalanceProvider.notifier).toggle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(currentBalanceProvider);
    final currency = ref.watch(currencyProvider);
    final hideBalance = ref.watch(hideBalanceProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KotiSpacing.xl),
      decoration: BoxDecoration(
        color: KotiColors.primaryAccent,
        borderRadius: KotiRadii.roundedXLarge,
        boxShadow: [
          BoxShadow(
            color: KotiColors.primaryAccent.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white),
              Text('Available', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: KotiSpacing.xl),
          Text(
            hideBalance ? '****' : '$currency${balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: KotiSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Koti Tracker', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70)),
              Text('Active', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white70, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(KotiSpacing.xl),
              child: Column(
                children: [
                  const SizedBox(height: KotiSpacing.xxl),
                  const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  const SizedBox(height: KotiSpacing.l),
                  const Text('No transactions yet.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: KotiSpacing.xs),
                  const Text('Tap the + button below to start tracking!', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length > 5 ? 5 : transactions.length,
          itemBuilder: (context, index) {
            return _TransactionTile(transaction: transactions[index]);
          },
        );
      },
      loading: () => const Center(child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      )),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}

class _TransactionTile extends ConsumerWidget {
  final Transaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpense = transaction.type == 'expense';
    final currency = ref.watch(currencyProvider);
    final hideBalance = ref.watch(hideBalanceProvider);
    final formattedAmount = transaction.amount.toStringAsFixed(2);
    final formattedDate = DateFormat('MMM d, yyyy').format(transaction.date);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color amountColor = isExpense 
      ? (isDark ? Colors.white : Colors.black)
      : KotiColors.income;
    String amountPrefix = isExpense ? '-' : '+';

    IconData icon;
    if (transaction.iconCodePoint != null && transaction.fontFamily != null) {
      icon = IconData(transaction.iconCodePoint!, fontFamily: transaction.fontFamily, fontPackage: transaction.fontPackage);
    } else {
      icon = isExpense ? Icons.shopping_bag : Icons.account_balance_wallet;
    }

    return GestureDetector(
      onTap: () => context.push('/transaction/${transaction.uuid}'),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: KotiSpacing.m),
        padding: const EdgeInsets.all(KotiSpacing.m),
        decoration: BoxDecoration(
          color: isDark ? KotiColors.darkSurfaceElevated : Colors.white,
          borderRadius: KotiRadii.roundedMedium,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(KotiSpacing.m),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.withValues(alpha: 0.1),
                borderRadius: KotiRadii.roundedMedium,
              ),
              child: Icon(icon, color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(width: KotiSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description, 
                    style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: KotiSpacing.xs),
                  Text(formattedDate, style: TextStyle(color: Colors.grey.withValues(alpha: 0.8), fontSize: 13)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountPrefix$currency$formattedAmount', 
                  style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16)
                ),
                const SizedBox(height: KotiSpacing.xs),
                Text(DateFormat('h:mm a').format(transaction.date), style: TextStyle(color: Colors.grey.withValues(alpha: 0.8), fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
