import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/di/injection_container.dart';
import '../../../../data/dao/read_record_dao.dart';
import '../../../../domain/models/read_record.dart';

/// 阅读统计状态
class ReadStatsState {
  final int totalReadTime; // 总阅读时长（毫秒）
  final int readBookCount; // 读过几本书
  final int streakDays; // 连续阅读天数
  final int todayReadTime; // 今天阅读时长
  final List<DateReadStats> recentStats; // 近 7 天统计
  final bool isLoading;
  final String? error;

  const ReadStatsState({
    this.totalReadTime = 0,
    this.readBookCount = 0,
    this.streakDays = 0,
    this.todayReadTime = 0,
    this.recentStats = const <DateReadStats>[],
    this.isLoading = false,
    this.error,
  });

  ReadStatsState copyWith({
    int? totalReadTime,
    int? readBookCount,
    int? streakDays,
    int? todayReadTime,
    List<DateReadStats>? recentStats,
    bool? isLoading,
    String? error,
  }) {
    return ReadStatsState(
      totalReadTime: totalReadTime ?? this.totalReadTime,
      readBookCount: readBookCount ?? this.readBookCount,
      streakDays: streakDays ?? this.streakDays,
      todayReadTime: todayReadTime ?? this.todayReadTime,
      recentStats: recentStats ?? this.recentStats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 阅读记录与统计 Provider
///
/// 功能：
/// 1. 自动记录阅读会话时间（进入阅读器 → 退出时累加）
/// 2. 提供阅读统计汇总数据（总时长、书籍数、连续天数、每日统计）
class ReadRecordProvider extends StateNotifier<ReadStatsState> {
  ReadRecordProvider() : super(ReadStatsState()) {
    loadStats();
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  ReadRecordDao? _dao;

  Future<ReadRecordDao> _getDao() async {
    if (_dao == null) {
      final db = await databaseInstance;
      _dao = ReadRecordDao(db);
    }
    return _dao!;
  }

  /// 加载所有统计数据
  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true);
    try {
      final dao = await _getDao();
      if (_disposed) return;
      final totalReadTime = await dao.getTotalReadTime();
      if (_disposed) return;
      final readBookCount = await dao.getReadBookCount();
      if (_disposed) return;
      final streakDays = await dao.getStreakDays();
      if (_disposed) return;
      final recentStats = await dao.getDailyStats(7);

      if (_disposed) return;
      // 今日阅读时长
      final now = DateTime.now();
      final todayStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final todayDetails = await dao.getDetailsByDate(todayStr);
      final todayReadTime = todayDetails.fold(0, (sum, d) => sum + d.readTime);

      if (!_disposed) {
        state = ReadStatsState(
          totalReadTime: totalReadTime,
          readBookCount: readBookCount,
          streakDays: streakDays,
          todayReadTime: todayReadTime,
          recentStats: recentStats,
          isLoading: false,
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, error: '加载统计数据失败: $e');
      }
    }
  }

  /// 开始阅读会话（进入阅读器时调用）
  int _sessionStartMs = 0;
  String _sessionBookName = '';
  String _sessionBookAuthor = '';

  void startReadingSession(String bookName, String bookAuthor) {
    _sessionStartMs = DateTime.now().millisecondsSinceEpoch;
    _sessionBookName = bookName;
    _sessionBookAuthor = bookAuthor;
  }

  /// 结束阅读会话（退出阅读器时调用）
  Future<void> endReadingSession() async {
    if (_sessionStartMs == 0) return;

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final durationMs = nowMs - _sessionStartMs;
    _sessionStartMs = 0; // 无论是否记录，都重置计时
    if (durationMs < 1000) return; // 少于 1 秒不记录

    try {
      final dao = await _getDao();
      final deviceId = 'default';
      final now = DateTime.now();
      final dateStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // 更新 ReadRecords（总时长累计）
      final existing = await dao.getByBook(
        _sessionBookName,
        _sessionBookAuthor,
      );
      final currentTime = existing?.readTime ?? 0;
      await dao.upsert(
        ReadRecord(
          deviceId: deviceId,
          bookName: _sessionBookName,
          bookAuthor: _sessionBookAuthor,
          readTime: currentTime + durationMs,
          lastRead: nowMs,
        ),
      );

      // 更新 ReadRecordDetails（当天累计）
      final todayDetails = await dao.getDetailsByDate(dateStr);
      final todayEntry = todayDetails
          .where(
            (d) =>
                d.bookName == _sessionBookName &&
                d.bookAuthor == _sessionBookAuthor,
          )
          .toList();
      final existingDetail = todayEntry.isNotEmpty ? todayEntry.first : null;

      await dao.upsertDetail(
        // ignore: non_constant_identifier_names
        db.ReadRecordDetail(
          deviceId: deviceId,
          bookName: _sessionBookName,
          bookAuthor: _sessionBookAuthor,
          date: dateStr,
          readTime: (existingDetail?.readTime ?? 0) + durationMs,
          readWords: 0, // 暂不统计字数
          firstReadTime: existingDetail?.firstReadTime ?? nowMs,
          lastReadTime: nowMs,
        ),
      );

      _sessionStartMs = 0;
    } catch (_) {
      // 记录失败不影响阅读
    }
  }
}

/// 阅读统计 Provider
final readStatsProvider =
    StateNotifierProvider<ReadRecordProvider, ReadStatsState>((ref) {
      return ReadRecordProvider();
    });
