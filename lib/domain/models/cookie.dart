import 'package:freezed_annotation/freezed_annotation.dart';

part 'cookie.freezed.dart';
part 'cookie.g.dart';

/// Cookie
///
/// 对应原：Cookie.kt
@freezed
abstract class Cookie with _$Cookie {
  const factory Cookie({
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'cookie') required String cookie,
  }) = _Cookie;

  factory Cookie.fromJson(Map<String, dynamic> json) => _$CookieFromJson(json);
}
