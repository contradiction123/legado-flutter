import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache.freezed.dart';
part 'cache.g.dart';

/// 缓存
///
/// 对应原：Cache.kt
/// 存储在 caches 表中
@freezed
abstract class Cache with _$Cache {
  const factory Cache({
    @JsonKey(name: 'key') required String key,
    @JsonKey(name: 'value') String? value,
    @JsonKey(name: 'deadline') @Default(0) int deadline,
  }) = _Cache;

  factory Cache.fromJson(Map<String, dynamic> json) => _$CacheFromJson(json);
}
