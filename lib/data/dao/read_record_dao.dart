import 'package:drift/drift.dart' as drift;

import '../../core/database/app_database.dart' as db;
import '../../domain/models/read_record.dart';

// ⚠️ 注意：当前文件同时使用 domain.ReadRecord（领域模型）和
//    db.ReadRecord（Drift 生成的 ORM 类）。
//    裸 ReadRecord = domain 模型，db.ReadRecord = Drift 类。
//    添加新方法时注意类型别名的指向。
import '../mappers/read_record_mapper.dart';

/// 阅读记录数据访问对象
///
/// 封装 ReadRecords、ReadRecordDetails、ReadRecordSessions 三张表
class ReadRecordDao {
  final db.AppDatabase _database;
  final _mapper = ReadRecordMapper();

  ReadRecordDao(this._database);

  // ── ReadRecords ──

  /// 获取所有阅读记录（总览）
  Future<List<ReadRecord>> getAll() async {
    final items = await _database.select(_database.readRecords).get();
    return _mapper.fromTableList(items);
  }

  /// 获取单本书的阅读记录
  Future<ReadRecord?> getByBook(String bookName, String bookAuthor) async {
    final items = await (_database.select(_database.readRecords)
          ..where((t) =>
              t.bookName.equals(bookName) & t.bookAuthor.equals(bookAuthor)))
        .get();
    return items.isNotEmpty ? _mapper.fromTable(items.first) : null;
  }

  /// 获取总阅读时长（所有书合计）
  Future<int> getTotalReadTime() async {
    final all = await _database.select(_database.readRecords).get();
    return all.fold<int>(0, (sum, r) => sum + r.readTime);
  }

  /// 获取有阅读记录的书籍数量
  Future<int> getReadBookCount() async {
    final all = await _database.select(_database.readRecords).get();
    return all.length;
  }

  /// 插入或更新阅读记录
  Future<void> upsert(ReadRecord record) async {
    await _database.into(_database.readRecords).insert(
      _mapper.toCompanion(record),
      mode: drift.InsertMode.insertOrReplace,
    );
  }

  // ── ReadRecordDetails ──

  /// 获取某天的阅读详情
  Future<List<db.ReadRecordDetail>> getDetailsByDate(String date) async {
    return (_database.select(_database.readRecordDetails)
          ..where((t) => t.date.equals(date)))
        .get();
  }

  /// 获取近 N 天的阅读时长（按天聚合）
  Future<List<DateReadStats>> getDailyStats(int days) async {
    final now = DateTime.now();
    final result = <DateReadStats>[];
    for (var i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final items = await getDetailsByDate(dateStr);
      final totalTime = items.fold<int>(0, (sum, d) => sum + d.readTime);
      result.add(DateReadStats(date: dateStr, readTime: totalTime));
    }
    return result;
  }

  /// 获取连续阅读天数
  Future<int> getStreakDays() async {
    final now = DateTime.now();
    var streak = 0;
    for (var i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final items = await getDetailsByDate(dateStr);
      if (items.isEmpty) break;
      final totalTime = items.fold<int>(0, (sum, d) => sum + d.readTime);
      if (totalTime == 0) break;
      streak++;
    }
    return streak;
  }

  /// 插入或更新阅读详情
  Future<void> upsertDetail(db.ReadRecordDetail detail) async {
    await _database.into(_database.readRecordDetails).insert(
      db.ReadRecordDetailsCompanion(
        deviceId: drift.Value(detail.deviceId),
        bookName: drift.Value(detail.bookName),
        bookAuthor: drift.Value(detail.bookAuthor),
        date: drift.Value(detail.date),
        readTime: drift.Value(detail.readTime),
        readWords: drift.Value(detail.readWords),
        firstReadTime: drift.Value(detail.firstReadTime),
        lastReadTime: drift.Value(detail.lastReadTime),
      ),
      mode: drift.InsertMode.insertOrReplace,
    );
  }

  // ── ReadRecordSessions ──

  /// 插入阅读会话
  Future<int> insertSession(db.ReadRecordSession session) async {
    return _database.into(_database.readRecordSessions).insert(
      db.ReadRecordSessionsCompanion(
        deviceId: drift.Value(session.deviceId),
        bookName: drift.Value(session.bookName),
        bookAuthor: drift.Value(session.bookAuthor),
        startTime: drift.Value(session.startTime),
        endTime: drift.Value(session.endTime),
        words: drift.Value(session.words),
      ),
    );
  }
}

/// 按天统计的阅读数据
class DateReadStats {
  final String date;
  final int readTime; // 毫秒

  const DateReadStats({required this.date, required this.readTime});
}
