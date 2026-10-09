import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../../core/design/koti_colors.dart';
import '../../../core/design/koti_spacing.dart';
import '../../../core/design/koti_radii.dart';
import '../../../data/database/app_database.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/currency_provider.dart';
import '../../../providers/wallet_providers.dart';
import '../../../domain/services/icon_matcher_service.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  final String type;

  const AddTransactionSheet({super.key, required this.type});

  static void show(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Hides the pill
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: AddTransactionSheet(type: type),
      ),
    );
  }

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _noteController = TextEditingController();
  
  IconData? _matchedIcon;
  DateTime _selectedDate = DateTime.now();
  String? _error;
  String? _selectedWalletId;

  @override
  void initState() {
    super.initState();
    _merchantController.addListener(_onMerchantChanged);
  }

  void _onMerchantChanged() {
    final text = _merchantController.text;
    final icon = IconMatcherService.getBestIconForMerchant(text);
    if (icon != _matchedIcon) setState(() => _matchedIcon = icon);
    if (_error != null) setState(() => _error = null); // clear error when typing
  }
  
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = DateTime(
        picked.year, picked.month, picked.day,
        _selectedDate.hour, _selectedDate.minute,
      ));
    }
  }

  void _saveTransaction() async {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(amountText);
    final merchant = _merchantController.text.trim();
    
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Please enter a valid amount.');
      return;
    }
    
    if (merchant.isEmpty) {
      setState(() => _error = 'Please provide a description.');
      return;
    }

    final dao = ref.read(transactionDaoProvider);
    
    // We completely eliminated manual categories. 
    // The database will now strictly save the merchant string and the intelligently matched Icon data.
    final transaction = TransactionsCompanion.insert(
      uuid: const Uuid().v4(),
      amount: amount,
      type: widget.type,
      description: drift.Value(merchant),
      merchant: drift.Value(merchant),
      date: _selectedDate,
      walletId: drift.Value(_selectedWalletId),
      iconCodePoint: drift.Value(_matchedIcon?.codePoint),
      fontFamily: drift.Value(_matchedIcon?.fontFamily),
      fontPackage: drift.Value(_matchedIcon?.fontPackage),
      notes: drift.Value(_noteController.text.trim()),
    );

    await dao.insertTransaction(transaction);
    if (mounted) Navigator.pop(context); // Close the sheet perfectly
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = widget.type == 'expense';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currency = ref.watch(currencyProvider);
    final walletsAsync = ref.watch(walletsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: KotiRadii.bottomSheet,
      ),
      padding: const EdgeInsets.all(KotiSpacing.l),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: KotiSpacing.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isExpense ? 'Add Expense' : 'Add Income', style: Theme.of(context).textTheme.titleLarge),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(DateFormat('MMM d, yyyy').format(_selectedDate)),
              )
            ],
          ),
          const SizedBox(height: KotiSpacing.xl),
          
          if (_error != null) ...[
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: KotiSpacing.s),
          ],
          
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: isExpense ? KotiColors.expense : KotiColors.income,
            ),
            decoration: InputDecoration(
              prefixText: '$currency ',
              hintText: '0.00',
              border: InputBorder.none,
              hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            autofocus: true,
          ),
          const SizedBox(height: KotiSpacing.l),
          
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: isDark ? KotiColors.darkIconBackground : KotiColors.lightIconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(_matchedIcon ?? (isExpense ? Icons.shopping_bag : Icons.account_balance_wallet), color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(width: KotiSpacing.m),
              Expanded(
                child: TextField(
                  controller: _merchantController,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    hintText: isExpense ? 'Merchant or description' : 'Source of income', 
                    border: InputBorder.none
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: KotiSpacing.m),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              hintText: 'Add an optional note...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(KotiRadii.small), borderSide: BorderSide.none),
              filled: true,
              fillColor: isDark ? KotiColors.darkIconBackground : KotiColors.lightIconBackground,
              prefixIcon: const Icon(Icons.notes),
            ),
          ),
          
          const SizedBox(height: KotiSpacing.m),
          
          walletsAsync.maybeWhen(
            data: (wallets) {
              if (wallets.isEmpty) return const SizedBox.shrink();
              if (_selectedWalletId == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _selectedWalletId = wallets.first.id);
                });
              }
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: KotiSpacing.m),
                decoration: BoxDecoration(
                  color: isDark ? KotiColors.darkIconBackground : KotiColors.lightIconBackground,
                  borderRadius: BorderRadius.circular(KotiRadii.small),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedWalletId ?? wallets.first.id,
                    isExpanded: true,
                    icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.grey),
                    items: wallets.map((w) => DropdownMenuItem(
                      value: w.id,
                      child: Text(w.name),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedWalletId = val),
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
          
          const SizedBox(height: KotiSpacing.xxl),
          
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saveTransaction,
              style: FilledButton.styleFrom(
                backgroundColor: isExpense ? KotiColors.expense : KotiColors.income,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: KotiSpacing.m),
                shape: const RoundedRectangleBorder(borderRadius: KotiRadii.roundedMedium),
              ),
              child: const Text('Save Transaction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: KotiSpacing.m),
        ],
      ),
    );
  }
}
