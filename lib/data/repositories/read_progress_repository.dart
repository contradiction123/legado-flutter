import '../../core/database/app_database.dart' as db;
import '../../data/dao/read_record_dao.dart';
import '../../domain/models/read_record.dart';

/// 阅读进度仓库
class ReadProgressRepository {
  final ReadRecordDao _dao;

  ReadProgressRepository(this._dao);

  Future<ReadRecord?> getByBook(String bookName, String bookAuthor) =>
      _dao.getByBook(bookName, bookAuthor);

  Future<int> getTotalReadTime() => _dao.getTotalReadTime();

  Future<int> getReadBookCount() => _dao.getReadBookCount();

  Future<void> upsert(ReadRecord record) => _dao.upsert(record);

  Future<List<DateReadStats>> getDailyStats(int days) =>
      _dao.getDailyStats(days);

  Future<int> getStreakDays() => _dao.getStreakDays();

  Future<void> endReadingSession({
    required String deviceId,
    required String bookName,
    required String bookAuthor,
    required int startTime,
    required int words,
  }) async {
    final endTime = DateTime.now().millisecondsSinceEpoch;
    final readTime = endTime - startTime;

    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await _dao.insertSession(
      db.ReadRecordSession(
        id: 0,
        deviceId: deviceId,
        bookName: bookName,
        bookAuthor: bookAuthor,
        startTime: startTime,
        endTime: endTime,
        words: words,
      ),
    );

    final existing = await _dao.getByBook(bookName, bookAuthor);
    await _dao.upsert(
      ReadRecord(
        deviceId: deviceId,
        bookName: bookName,
        bookAuthor: bookAuthor,
        readTime: (existing?.readTime ?? 0) + readTime,
        lastRead: endTime,
      ),
    );

    final todayDetails = await _dao.getDetailsByDate(dateStr);
    final todayEntry = todayDetails
        .where((d) => d.bookName == bookName && d.bookAuthor == bookAuthor)
        .toList();
    final existingDetail = todayEntry.isNotEmpty ? todayEntry.first : null;

    await _dao.upsertDetail(
      db.ReadRecordDetail(
        deviceId: deviceId,
        bookName: bookName,
        bookAuthor: bookAuthor,
        date: dateStr,
        readTime: (existingDetail?.readTime ?? 0) + readTime,
        readWords: words,
        firstReadTime: existingDetail?.firstReadTime ?? startTime,
        lastReadTime: endTime,
      ),
    );
  }
}
