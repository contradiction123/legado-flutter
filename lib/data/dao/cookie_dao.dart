import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/cookie.dart';
import '../mappers/cookie_mapper.dart';

/// Cookie 数据访问对象
class CookieDao {
  final db.AppDatabase _database;
  final _mapper = CookieMapper();

  CookieDao(this._database);

  /// 根据 URL 获取 Cookie
  Future<Cookie?> getByUrl(String url) async {
    final item = await (_database.select(_database.cookies)
          ..where((t) => t.url.equals(url)))
        .getSingleOrNull();
    return item != null ? _mapper.fromTable(item) : null;
  }

  /// 获取所有 Cookie
  Future<List<Cookie>> getAll() async {
    final items = await _database.select(_database.cookies).get();
    return _mapper.fromTableList(items);
  }

  /// 保存 Cookie（插入或替换）
  Future<int> save(String url, String cookie) {
    return _database.into(_database.cookies).insertOnConflictUpdate(
      db.CookiesCompanion(
        url: Value(url),
        cookie: Value(cookie),
      ),
    );
  }

  /// 根据 URL 删除 Cookie
  Future<int> deleteByUrl(String url) {
    return (_database.delete(_database.cookies)
          ..where((t) => t.url.equals(url)))
        .go();
  }
}
