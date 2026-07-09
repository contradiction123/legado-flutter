import '../../data/dao/book_group_dao.dart';
import '../../data/mappers/book_group_mapper.dart';
import '../../domain/models/book_group.dart';

/// 书籍分组仓库
///
/// 封装 BookGroupDao + BookGroupMapper，对外只暴露领域模型
class BookGroupRepository {
  final BookGroupDao _dao;
  final BookGroupMapper _mapper;

  BookGroupRepository(this._dao, this._mapper);

  /// 获取所有分组（按排序字段排列）
  Future<List<BookGroup>> getAll() {
    return _dao.getAll();
  }

  /// 按分组名称查找
  Future<BookGroup?> getByName(String name) async {
    final groups = await _dao.getAll();
    return groups.where((g) => g.groupName == name).firstOrNull;
  }

  /// 添加分组
  Future<void> add(BookGroup group) async {
    await _dao.insert(_mapper.toCompanion(group));
  }

  /// 更新分组
  Future<void> update(BookGroup group) async {
    await _dao.update(_mapper.toCompanion(group));
  }

  /// 删除分组
  Future<void> delete(int id) async {
    await _dao.delete(id);
  }
}
