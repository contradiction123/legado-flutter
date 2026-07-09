import '../../data/dao/search_history_dao.dart';
import '../../domain/models/search_history.dart';

/// 搜索关键词历史仓库
class SearchHistoryRepository {
  final SearchHistoryDao _dao;

  SearchHistoryRepository(this._dao);

  /// 获取所有搜索关键词
  Future<List<SearchKeyword>> getAll() => _dao.getAll();

  /// 搜索关键词（模糊匹配）
  Future<List<SearchKeyword>> search(String keyword) => _dao.search(keyword);

  /// 添加搜索关键词
  Future<void> add(String word) => _dao.add(word);

  /// 删除搜索关键词
  Future<void> delete(String word) => _dao.delete(word);

  /// 清空所有搜索关键词
  Future<void> clear() => _dao.clear();
}
