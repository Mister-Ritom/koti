import 'package:drift/drift.dart';

class Wallets extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()(); // e.g., 'Main Wallet'
  TextColumn get type => text()(); // 'cash', 'bank', 'credit'
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  IntColumn get color => integer().nullable()(); // color hex
  IntColumn get iconCodePoint => integer().nullable()();
  TextColumn get fontFamily => text().nullable()();
  TextColumn get fontPackage => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}
