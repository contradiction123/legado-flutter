import '../../core/database/app_database.dart';

/// 搜索结果数据访问对象
class SearchBookDao {
  final AppDatabase _database;

  SearchBookDao(this._database);

  /// 插入搜索结果
  Future<int> insert(SearchBooksCompanion entry) {
    return _database.into(_database.searchBooks).insert(entry);
  }

  /// 批量插入搜索结果（先清空旧数据）
  Future<void> replaceAll(List<SearchBooksCompanion> entries) async {
    await _database.delete(_database.searchBooks).go();
    for (final entry in entries) {
      await _database.into(_database.searchBooks).insert(entry);
    }
  }

  /// 清空搜索结果
  Future<int> clearAll() {
    return _database.delete(_database.searchBooks).go();
  }
}
