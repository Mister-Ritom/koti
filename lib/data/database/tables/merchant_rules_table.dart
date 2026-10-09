import 'package:drift/drift.dart';

class MerchantRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get merchantPattern => text().unique()();
  IntColumn get iconCodePoint => integer()();
  TextColumn get fontFamily => text()();
  TextColumn get fontPackage => text().nullable()(); 
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
