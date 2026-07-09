import '../../data/dao/book_source_dao.dart';
import '../../domain/models/book_source.dart';

/// 书源仓库
///
/// 封装 DAO 调用，对外只暴露领域模型
class BookSourceRepository {
  final BookSourceDao _dao;

  BookSourceRepository(this._dao);

  /// 获取所有书源
  Future<List<BookSource>> getAll() => _dao.getAll();

  /// 根据 URL 获取书源
  Future<BookSource?> getByUrl(String url) => _dao.getByUrl(url);

  /// 获取所有已启用的书源
  Future<List<BookSource>> getEnabled() => _dao.getEnabled();

  /// 按分组获取书源
  Future<List<BookSource>> getByGroup(String group) => _dao.getByGroup(group);

  /// 搜索书源
  Future<List<BookSource>> search(String keyword) => _dao.search(keyword);

  /// 获取所有分组名称
  Future<List<String>> getDistinctGroups() => _dao.getDistinctGroups();

  /// 保存书源（插入或更新）
  Future<bool> save(BookSource source) async {
    final existing = await _dao.getByUrl(source.bookSourceUrl);
    if (existing != null) {
      await _dao.setEnabled(source.bookSourceUrl, source.enabled);
      return true;
    } else {
      await _dao.insert(source);
      return true;
    }
  }

  /// 批量导入书源
  Future<int> importAll(List<BookSource> sources) async {
    var count = 0;
    for (final source in sources) {
      await save(source);
      count++;
    }
    return count;
  }

  /// 启用/禁用
  Future<void> setEnabled(String url, bool enabled) =>
      _dao.setEnabled(url, enabled).then((_) {});

  /// 删除书源
  Future<void> deleteByUrl(String url) =>
      _dao.deleteByUrl(url).then((_) {});

  /// 获取启用的书源数量
  Future<int> countEnabled() async {
    final all = await _dao.getEnabled();
    return all.length;
  }
}
