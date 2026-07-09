import '../../data/dao/bookmark_dao.dart';
import '../../domain/models/bookmark.dart';

/// 书签仓库
///
/// 封装 BookmarkDao，对外只暴露领域模型
class BookmarkRepository {
  final BookmarkDao _dao;

  BookmarkRepository(this._dao);

  /// 按书名和作者获取书签
  Future<List<Bookmark>> getByBook(String bookName, String bookAuthor) {
    return _dao.getByBook(bookName, bookAuthor);
  }

  /// 获取所有书签
  Future<List<Bookmark>> getAll() {
    return _dao.getAll();
  }

  /// 添加书签
  Future<void> add(Bookmark bookmark) async {
    await _dao.insert(bookmark);
  }

  /// 按时间删除书签
  Future<void> removeByTime(int time) async {
    await _dao.deleteByTime(time);
  }

  /// 删除某本书的所有书签
  Future<void> removeByBook(String bookName, String bookAuthor) async {
    await _dao.deleteByBook(bookName, bookAuthor);
  }
}
