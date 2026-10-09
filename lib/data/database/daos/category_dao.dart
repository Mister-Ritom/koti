import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(AppDatabase db) : super(db);

  Future<List<Category>> getAllCategories() => select(categories).get();
  
  Stream<List<Category>> watchActiveCategories() {
    return (select(categories)
      ..where((c) => c.isArchived.equals(false))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder, mode: OrderingMode.asc)]))
    .watch();
  }

  Future<int> insertCategory(Insertable<Category> category) => into(categories).insert(category);
  
  Future<bool> updateCategory(Insertable<Category> category) => update(categories).replace(category);
  
  Future<int> deleteCategory(int id) => (delete(categories)..where((c) => c.id.equals(id))).go();
}
