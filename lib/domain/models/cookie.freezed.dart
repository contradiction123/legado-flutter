// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cookie.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cookie {

@JsonKey(name: 'url') String get url;@JsonKey(name: 'cookie') String get cookie;
/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CookieCopyWith<Cookie> get copyWith => _$CookieCopyWithImpl<Cookie>(this as Cookie, _$identity);

  /// Serializes this Cookie to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cookie&&(identical(other.url, url) || other.url == url)&&(identical(other.cookie, cookie) || other.cookie == cookie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,cookie);

@override
String toString() {
  return 'Cookie(url: $url, cookie: $cookie)';
}


}

/// @nodoc
abstract mixin class $CookieCopyWith<$Res>  {
  factory $CookieCopyWith(Cookie value, $Res Function(Cookie) _then) = _$CookieCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String url,@JsonKey(name: 'cookie') String cookie
});




}
/// @nodoc
class _$CookieCopyWithImpl<$Res>
    implements $CookieCopyWith<$Res> {
  _$CookieCopyWithImpl(this._self, this._then);

  final Cookie _self;
  final $Res Function(Cookie) _then;

/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? cookie = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,cookie: null == cookie ? _self.cookie : cookie // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Cookie].
extension CookiePatterns on Cookie {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cookie value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cookie() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cookie value)  $default,){
final _that = this;
switch (_that) {
case _Cookie():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cookie value)?  $default,){
final _that = this;
switch (_that) {
case _Cookie() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String url, @JsonKey(name: 'cookie')  String cookie)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cookie() when $default != null:
return $default(_that.url,_that.cookie);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String url, @JsonKey(name: 'cookie')  String cookie)  $default,) {final _that = this;
switch (_that) {
case _Cookie():
return $default(_that.url,_that.cookie);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')  String url, @JsonKey(name: 'cookie')  String cookie)?  $default,) {final _that = this;
switch (_that) {
case _Cookie() when $default != null:
return $default(_that.url,_that.cookie);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cookie implements Cookie {
  const _Cookie({@JsonKey(name: 'url') required this.url, @JsonKey(name: 'cookie') required this.cookie});
  factory _Cookie.fromJson(Map<String, dynamic> json) => _$CookieFromJson(json);

@override@JsonKey(name: 'url') final  String url;
@override@JsonKey(name: 'cookie') final  String cookie;

/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CookieCopyWith<_Cookie> get copyWith => __$CookieCopyWithImpl<_Cookie>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CookieToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cookie&&(identical(other.url, url) || other.url == url)&&(identical(other.cookie, cookie) || other.cookie == cookie));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,cookie);

@override
String toString() {
  return 'Cookie(url: $url, cookie: $cookie)';
}


}

/// @nodoc
abstract mixin class _$CookieCopyWith<$Res> implements $CookieCopyWith<$Res> {
  factory _$CookieCopyWith(_Cookie value, $Res Function(_Cookie) _then) = __$CookieCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String url,@JsonKey(name: 'cookie') String cookie
});




}
/// @nodoc
class __$CookieCopyWithImpl<$Res>
    implements _$CookieCopyWith<$Res> {
  __$CookieCopyWithImpl(this._self, this._then);

  final _Cookie _self;
  final $Res Function(_Cookie) _then;

/// Create a copy of Cookie
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? cookie = null,}) {
  return _then(_Cookie(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,cookie: null == cookie ? _self.cookie : cookie // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
