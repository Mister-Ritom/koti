import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/transactions_table.dart';
import 'tables/categories_table.dart';
import 'tables/merchant_rules_table.dart';
import 'tables/wallets_table.dart';

import 'daos/transaction_dao.dart';
import 'daos/category_dao.dart';
import 'daos/merchant_rules_dao.dart';
import 'daos/wallet_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Transactions, Categories, MerchantRules, Wallets],
  daos: [TransactionDao, CategoryDao, MerchantRulesDao, WalletDao]
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(wallets);
        await m.addColumn(transactions, transactions.walletId);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'koti_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
