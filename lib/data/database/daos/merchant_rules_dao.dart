import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/merchant_rules_table.dart';

part 'merchant_rules_dao.g.dart';

@DriftAccessor(tables: [MerchantRules])
class MerchantRulesDao extends DatabaseAccessor<AppDatabase> with _$MerchantRulesDaoMixin {
  MerchantRulesDao(AppDatabase db) : super(db);

  Future<List<MerchantRule>> getAllRules() => select(merchantRules).get();
  
  Future<MerchantRule?> findRuleForMerchant(String pattern) {
    return (select(merchantRules)
      ..where((r) => r.merchantPattern.equals(pattern))
      ..limit(1))
    .getSingleOrNull();
  }

  Future<int> insertOrUpdateRule(Insertable<MerchantRule> rule) {
    return into(merchantRules).insertOnConflictUpdate(rule);
  }
}
