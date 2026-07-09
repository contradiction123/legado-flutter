import '../../data/dao/book_dao.dart';
import '../../data/mappers/book_mapper.dart';
import '../../domain/models/book.dart';

/// 书籍仓库
class BookRepository {
  final BookDao _dao;
  final BookMapper _mapper;

  BookRepository(this._dao, this._mapper);

  /// 获取所有书籍
  Future<List<Book>> getAll() async {
    final rows = await _dao.getAll();
    return _mapper.fromTableList(rows);
  }

  /// 根据 URL 获取书籍
  Future<Book?> getByUrl(String url) async {
    final row = await _dao.getByUrl(url);
    return row != null ? _mapper.fromTable(row) : null;
  }

  /// 按分组获取书籍
  Future<List<Book>> getByGroup(int group) async {
    final rows = await _dao.getByGroup(group);
    return _mapper.fromTableList(rows);
  }

  /// 保存书籍
  Future<bool> save(Book book) async {
    final existing = await _dao.getByUrl(book.bookUrl);
    final companion = _mapper.toCompanion(book);
    if (existing != null) {
      return _dao.update(companion);
    } else {
      await _dao.insert(companion);
      return true;
    }
  }

  /// 删除书籍
  Future<void> deleteByUrl(String url) async {
    await _dao.deleteByUrl(url);
  }

  /// 更新阅读进度
  Future<void> updateProgress(
    String bookUrl, {
    required int durChapterIndex,
    required int durChapterPos,
    String? durChapterTitle,
  }) {
    return _dao
        .updateProgress(
          bookUrl,
          durChapterIndex: durChapterIndex,
          durChapterPos: durChapterPos,
          durChapterTitle: durChapterTitle,
        )
        .then((_) {});
  }

  /// 获取最近阅读
  Future<List<Book>> getRecentRead({int limitCount = 10}) async {
    final rows = await _dao.getRecentRead(limitCount: limitCount);
    return _mapper.fromTableList(rows);
  }
}
