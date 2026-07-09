import '../../data/dao/chapter_dao.dart';
import '../../data/mappers/chapter_mapper.dart';
import '../../domain/models/book_chapter.dart';

/// 章节仓库
///
/// 封装 ChapterDao + ChapterMapper，对外只暴露领域模型
class ChapterRepository {
  final ChapterDao _dao;
  final ChapterMapper _mapper;

  ChapterRepository(this._dao, this._mapper);

  /// 获取某本书的所有章节
  Future<List<BookChapter>> getByBookUrl(String bookUrl) async {
    final rows = await _dao.getByBookUrl(bookUrl);
    return _mapper.fromTableList(rows);
  }

  /// 通过索引获取章节
  Future<BookChapter?> getByIndex(String bookUrl, int index) async {
    final row = await _dao.getByIndex(bookUrl, index);
    return row != null ? _mapper.fromTable(row) : null;
  }

  /// 批量插入章节
  Future<void> batchInsert(String bookUrl, List<BookChapter> chapters) async {
    final companions = chapters.map((c) => _mapper.toCompanion(c)).toList();
    await _dao.insertAll(companions);
  }

  /// 删除某本书的所有章节
  Future<void> deleteByBookUrl(String bookUrl) async {
    await _dao.deleteByBookUrl(bookUrl);
  }

  /// 获取某本书的章节总数
  Future<int> countByBookUrl(String bookUrl) async {
    return _dao.countByBookUrl(bookUrl);
  }
}
