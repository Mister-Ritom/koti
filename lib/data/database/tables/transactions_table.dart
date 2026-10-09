import 'package:drift/drift.dart';
import 'categories_table.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('INR'))();
  TextColumn get type => text()(); // 'expense' | 'income'
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get merchant => text().nullable()();
  IntColumn get categoryId => integer().nullable().references(Categories, #id)();
  
  // Intelligent icon override mapping
  IntColumn get iconCodePoint => integer().nullable()();
  TextColumn get fontFamily => text().nullable()();
  TextColumn get fontPackage => text().nullable()();
  
  // Wallet tracking
  TextColumn get walletId => text().nullable()();
  
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
