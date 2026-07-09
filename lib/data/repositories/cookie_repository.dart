import '../../data/dao/cookie_dao.dart';
import '../../domain/models/cookie.dart';

/// Cookie 仓库
class CookieRepository {
  final CookieDao _dao;

  CookieRepository(this._dao);

  /// 根据 URL 获取 Cookie
  Future<Cookie?> getByUrl(String url) => _dao.getByUrl(url);

  /// 获取所有 Cookie
  Future<List<Cookie>> getAll() => _dao.getAll();

  /// 保存 Cookie
  Future<void> save(String url, String cookie) => _dao.save(url, cookie);

  /// 根据 URL 删除 Cookie
  Future<void> deleteByUrl(String url) => _dao.deleteByUrl(url);
}
