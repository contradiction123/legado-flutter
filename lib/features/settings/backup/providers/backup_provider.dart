import '../../../../data/dao/book_source_dao.dart';
import '../../../../data/dao/replace_rule_dao.dart';
import '../../../../data/dao/rss_source_dao.dart';
import '../../../../core/database/app_database.dart';
import '../engine/backup_manager.dart';
import '../engine/webdav_manager.dart';

/// 备份状态管理
class BackupProvider {
  final BackupManager _backupManager;
  WebDavManager? _webDavManager;

  BackupManager get backupManager => _backupManager;

  BackupProvider(
    BookSourceDao bookSourceDao,
    ReplaceRuleDao replaceRuleDao,
    RssSourceDao rssSourceDao,
    AppDatabase database,
  ) : _backupManager = BackupManager(
        bookSourceDao,
        replaceRuleDao,
        rssSourceDao,
        database,
      );

  /// 配置 WebDAV
  void configureWebDav({
    required String url,
    required String username,
    required String password,
    String basePath = '/legado_backup',
  }) {
    _webDavManager = WebDavManager(
      baseUrl: url,
      username: username,
      password: password,
      basePath: basePath,
    );
  }

  /// 获取 WebDAV 管理器
  WebDavManager? get webDavManager => _webDavManager;

  /// 导出本地备份
  Future<String> exportBackup({String? password}) async {
    return _backupManager.exportBackup(password: password);
  }

  /// 导入本地备份
  Future<int> importBackup(String filePath, {String? password}) async {
    return _backupManager.importBackup(filePath, password: password);
  }

  /// 上传到 WebDAV
  Future<bool> uploadToWebDav(String localPath) async {
    if (_webDavManager == null) return false;
    await _webDavManager!.ensureDirectory();
    return _webDavManager!.uploadBackup(localPath);
  }

  /// 从 WebDAV 下载
  Future<String?> downloadFromWebDav(String fileName) async {
    return _webDavManager?.downloadBackup(fileName);
  }
}
