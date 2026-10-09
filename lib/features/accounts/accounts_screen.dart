import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../core/design/koti_colors.dart';
import '../../core/design/koti_spacing.dart';
import '../../core/design/koti_radii.dart';
import '../../providers/wallet_providers.dart';
import '../../providers/currency_provider.dart';
import '../../data/database/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/balance_providers.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletsAsync = ref.watch(walletsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Wallets', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddWalletDialog(context, ref),
          )
        ],
      ),
      body: walletsAsync.when(
        data: (wallets) {
          if (wallets.isEmpty) {
            return const Center(child: Text('No wallets yet. Add one!'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(KotiSpacing.m),
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return _WalletListItem(wallet: wallet, currency: currency, isDark: isDark);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showAddWalletDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Wallet'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Wallet Name (e.g. Work Credit Card)'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final db = ref.read(databaseProvider);
                await db.walletDao.insertWallet(
                  WalletsCompanion.insert(
                    id: const Uuid().v4(),
                    name: name,
                    type: 'custom',
                  ),
                );
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _WalletListItem extends ConsumerWidget {
  final Wallet wallet;
  final String currency;
  final bool isDark;

  const _WalletListItem({required this.wallet, required this.currency, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider(wallet));
    final double balance = balanceAsync.valueOrNull ?? wallet.initialBalance;
    final hideBalance = ref.watch(hideBalanceProvider);
    
    return Container(
      margin: const EdgeInsets.only(bottom: KotiSpacing.m),
      padding: const EdgeInsets.all(KotiSpacing.l),
      decoration: BoxDecoration(
        color: isDark ? KotiColors.darkSurfaceElevated : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          if (!isDark)
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KotiColors.primaryAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet, color: KotiColors.primaryAccent, size: 28),
          ),
          const SizedBox(width: KotiSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wallet.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(wallet.type, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                hideBalance ? '****' : '$currency${balance.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
