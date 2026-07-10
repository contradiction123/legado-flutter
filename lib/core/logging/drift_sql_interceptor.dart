import 'dart:async';

import 'package:drift/drift.dart';

import 'app_logger.dart';
import 'log_tag.dart';

class DriftSqlInterceptor extends QueryInterceptor {
  DriftSqlInterceptor(this._logger);

  final AppLogger _logger;

  @override
  Future<void> runCustom(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) async {
    final startedAt = DateTime.now();
    try {
      await executor.runCustom(statement, args);
      _logger.debug(
        LogTag.dbDrift,
        'SQL Custom',
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
    } catch (error, stackTrace) {
      _logger.error(
        LogTag.dbDrift,
        'SQL Custom Error',
        error: error,
        stackTrace: stackTrace,
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
      rethrow;
    }
  }

  @override
  Future<int> runInsert(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) async {
    final startedAt = DateTime.now();
    try {
      final insertedId = await executor.runInsert(statement, args);
      _logger.debug(
        LogTag.dbDrift,
        'SQL Insert',
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
          'InsertedId': insertedId,
        },
      );
      return insertedId;
    } catch (error, stackTrace) {
      _logger.error(
        LogTag.dbDrift,
        'SQL Insert Error',
        error: error,
        stackTrace: stackTrace,
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
      rethrow;
    }
  }

  @override
  Future<int> runUpdate(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) async {
    final startedAt = DateTime.now();
    try {
      final affectedRows = await executor.runUpdate(statement, args);
      _logger.debug(
        LogTag.dbDrift,
        'SQL Update',
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
          'AffectedRows': affectedRows,
        },
      );
      return affectedRows;
    } catch (error, stackTrace) {
      _logger.error(
        LogTag.dbDrift,
        'SQL Update Error',
        error: error,
        stackTrace: stackTrace,
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
      rethrow;
    }
  }

  @override
  Future<int> runDelete(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) async {
    final startedAt = DateTime.now();
    try {
      final affectedRows = await executor.runDelete(statement, args);
      _logger.debug(
        LogTag.dbDrift,
        'SQL Delete',
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
          'AffectedRows': affectedRows,
        },
      );
      return affectedRows;
    } catch (error, stackTrace) {
      _logger.error(
        LogTag.dbDrift,
        'SQL Delete Error',
        error: error,
        stackTrace: stackTrace,
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) async {
    final startedAt = DateTime.now();
    try {
      final rows = await executor.runSelect(statement, args);
      _logger.debug(
        LogTag.dbDrift,
        'SQL Select',
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
          'RowCount': rows.length,
        },
      );
      return rows;
    } catch (error, stackTrace) {
      _logger.error(
        LogTag.dbDrift,
        'SQL Select Error',
        error: error,
        stackTrace: stackTrace,
        extra: {
          'Sql': statement,
          'Args': args,
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
      rethrow;
    }
  }

  @override
  Future<void> runBatched(
    QueryExecutor executor,
    BatchedStatements statements,
  ) async {
    final startedAt = DateTime.now();
    try {
      await executor.runBatched(statements);
      _logger.debug(
        LogTag.dbDrift,
        'SQL Batch',
        extra: {
          'Statements': statements.statements,
          'Arguments': [
            for (final item in statements.arguments)
              {
                'StatementIndex': item.statementIndex,
                'Args': item.arguments,
              },
          ],
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
    } catch (error, stackTrace) {
      _logger.error(
        LogTag.dbDrift,
        'SQL Batch Error',
        error: error,
        stackTrace: stackTrace,
        extra: {
          'Statements': statements.statements,
          'Arguments': [
            for (final item in statements.arguments)
              {
                'StatementIndex': item.statementIndex,
                'Args': item.arguments,
              },
          ],
          'DurationMs': DateTime.now().difference(startedAt).inMilliseconds,
        },
      );
      rethrow;
    }
  }
}
