import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../di/injection_container.dart';

/// 数据库实例 Provider
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  return databaseInstance;
});
