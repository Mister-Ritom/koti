import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_provider.dart';

import 'dart:io';
import 'package:intl/intl.dart';

final currencyProvider = StateNotifierProvider<CurrencyNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  String? savedCurrency = prefs.getString('currency_symbol');
  
  if (savedCurrency == null) {
    try {
      final format = NumberFormat.simpleCurrency(locale: Platform.localeName);
      savedCurrency = format.currencySymbol;
    } catch (e) {
      savedCurrency = '\$';
    }
  }
  
  return CurrencyNotifier(prefs, savedCurrency!);
});

class CurrencyNotifier extends StateNotifier<String> {
  final SharedPreferences prefs;
  CurrencyNotifier(this.prefs, super.state);

  void setCurrency(String symbol) {
    state = symbol;
    prefs.setString('currency_symbol', symbol);
  }
}
