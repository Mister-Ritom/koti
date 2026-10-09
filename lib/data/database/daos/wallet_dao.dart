import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/wallets_table.dart';

part 'wallet_dao.g.dart';

@DriftAccessor(tables: [Wallets])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(super.db);

  Future<List<Wallet>> getAllWallets() => select(wallets).get();
  
  Stream<List<Wallet>> watchAllWallets() => select(wallets).watch();
  
  Future<Wallet> getWalletById(String id) {
    return (select(wallets)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<int> insertWallet(WalletsCompanion wallet) => into(wallets).insert(wallet);
  
  Future<bool> updateWallet(Wallet wallet) => update(wallets).replace(wallet);
  
  Future<int> deleteWallet(Wallet wallet) => delete(wallets).delete(wallet);
}
