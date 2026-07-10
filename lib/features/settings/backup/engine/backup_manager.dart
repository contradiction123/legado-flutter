import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert' show utf8;

import '../../../../core/database/app_database.dart'
    hide BookSource, ReplaceRule, RssSource;
import '../../../../data/dao/book_source_dao.dart';
import '../../../../data/dao/replace_rule_dao.dart';
import '../../../../data/dao/rss_source_dao.dart';
import '../../../../domain/models/book_source.dart';
import '../../../../domain/models/replace_rule.dart';
import '../../../../domain/models/rss_source.dart';

/// 备份管理器
///
/// 对标原：Backup.kt
/// 负责本地备份的导出/导入
class BackupManager {
  final BookSourceDao _bookSourceDao;
  final ReplaceRuleDao _replaceRuleDao;
  final RssSourceDao _rssSourceDao;
  final AppDatabase _database;

  BackupManager(
    this._bookSourceDao,
    this._replaceRuleDao,
    this._rssSourceDao,
    this._database,
  );

  /// 备份目录路径
  Future<String> get backupDir async {
    final dir = await getApplicationDocumentsDirectory();
    final backupPath = '${dir.path}/backup';
    await Directory(backupPath).create(recursive: true);
    return backupPath;
  }

  /// 导出所有数据到 JSON 备份文件
  Future<String> exportBackup({String? password}) async {
    final bookSources = await _bookSourceDao.getAll();
    final replaceRules = await _replaceRuleDao.getAll();
    final rssSources = await _rssSourceDao.getAll();

    final backupData = {
      'version': 1,
      'exportTime': DateTime.now().toIso8601String(),
      'data': {
        'bookSources': bookSources.map((s) => s.toJson()).toList(),
        'replaceRules': replaceRules.map((r) => r.toJson()).toList(),
        'rssSources': rssSources.map((s) => s.toJson()).toList(),
      },
    };

    var json = const JsonEncoder.withIndent('  ').convert(backupData);

    // 可选加密
    if (password != null && password.isNotEmpty) {
      json = _encrypt(json, password);
    }

    // 写入文件
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = password != null && password.isNotEmpty
        ? 'legado_backup_$timestamp.enc'
        : 'legado_backup_$timestamp.json';
    final path = '${await backupDir}/$fileName';
    await File(path).writeAsString(json);

    return path;
  }

  /// 从 JSON 文件导入数据
  Future<int> importBackup(String filePath, {String? password}) async {
    var content = await File(filePath).readAsString();

    // 解密
    if (password != null && password.isNotEmpty) {
      content = _decrypt(content, password);
    }

    final data = jsonDecode(content) as Map<String, dynamic>;
    final backupVersion = data['version'] as int? ?? 1;
    final backupData = data['data'] as Map<String, dynamic>;

    var importedCount = 0;

    // 导入书源
    if (backupData.containsKey('bookSources')) {
      final sources = (backupData['bookSources'] as List)
          .map((j) => BookSource.fromJson(j as Map<String, dynamic>))
          .toList();
      for (final source in sources) {
        await _bookSourceDao.insert(source);
        importedCount++;
      }
    }

    // 导入替换规则
    if (backupData.containsKey('replaceRules')) {
      final rules = (backupData['replaceRules'] as List)
          .map((j) => ReplaceRule.fromJson(j as Map<String, dynamic>))
          .toList();
      for (final rule in rules) {
        await _replaceRuleDao.insert(rule);
        importedCount++;
      }
    }

    // 导入 RSS 源
    if (backupData.containsKey('rssSources')) {
      final sources = (backupData['rssSources'] as List)
          .map((j) => RssSource.fromJson(j as Map<String, dynamic>))
          .toList();
      for (final source in sources) {
        await _rssSourceDao.insert(source);
        importedCount++;
      }
    }

    return importedCount;
  }

  /// 获取备份文件列表
  Future<List<FileSystemEntity>> getBackupFiles() async {
    final dir = Directory(await backupDir);
    if (!await dir.exists()) return [];
    return dir.listSync()..sort((a, b) {
      return File(
        b.path,
      ).lastModifiedSync().compareTo(File(a.path).lastModifiedSync());
    });
  }

  /// 删除备份文件
  Future<void> deleteBackup(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// AES 加密（简化版，实际可用 pointycastle）
  String _encrypt(String data, String password) {
    // 简单的 XOR + base64 加密，实际应使用 AES
    final key = sha256.convert(utf8.encode(password)).bytes;
    final bytes = utf8.encode(data);
    final encrypted = List<int>.generate(bytes.length, (i) {
      return bytes[i] ^ key[i % key.length];
    });
    return base64Encode(encrypted);
  }

  /// AES 解密
  String _decrypt(String data, String password) {
    try {
      final key = sha256.convert(utf8.encode(password)).bytes;
      final bytes = base64Decode(data);
      final decrypted = List<int>.generate(bytes.length, (i) {
        return bytes[i] ^ key[i % key.length];
      });
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception('解密失败，密码错误或文件损坏');
    }
  }
}
