import 'package:drift/drift.dart';

import '../../core/database/app_database.dart' as db;
import '../../domain/models/bookmark.dart';

// ⚠️ 注意：当前文件同时使用 domain.Bookmark（领域模型）和
//    db.Bookmark（Drift 生成的 ORM 类）。
//    裸 Bookmark = domain 模型，db.Bookmark = Drift 类。
import '../mappers/bookmark_mapper.dart';

/// 书签数据访问对象
class BookmarkDao {
  final db.AppDatabase _database;
  final _mapper = BookmarkMapper();

  BookmarkDao(this._database);

  /// 获取所有书签
  Future<List<Bookmark>> getAll() async {
    final items = await _database.select(_database.bookmarks).get();
    return _mapper.fromTableList(items);
  }

  /// 按书籍获取书签
  Future<List<Bookmark>> getByBook(String bookName, String bookAuthor) async {
    final items =
        await (_database.select(_database.bookmarks)..where(
              (t) =>
                  t.bookName.equals(bookName) & t.bookAuthor.equals(bookAuthor),
            ))
            .get();
    return _mapper.fromTableList(items);
  }

  /// 插入书签
  Future<int> insert(Bookmark bookmark) {
    return _database
        .into(_database.bookmarks)
        .insert(_mapper.toNewCompanion(bookmark));
  }

  /// 按时间删除书签
  Future<int> deleteByTime(int time) {
    return (_database.delete(
      _database.bookmarks,
    )..where((t) => t.time.equals(time))).go();
  }

  /// 删除某本书的所有书签
  Future<int> deleteByBook(String bookName, String bookAuthor) {
    return (_database.delete(_database.bookmarks)..where(
          (t) => t.bookName.equals(bookName) & t.bookAuthor.equals(bookAuthor),
        ))
        .go();
  }
}
