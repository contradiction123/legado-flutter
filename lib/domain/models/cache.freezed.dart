// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Cache {

@JsonKey(name: 'key') String get key;@JsonKey(name: 'value') String? get value;@JsonKey(name: 'deadline') int get deadline;
/// Create a copy of Cache
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheCopyWith<Cache> get copyWith => _$CacheCopyWithImpl<Cache>(this as Cache, _$identity);

  /// Serializes this Cache to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cache&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.deadline, deadline) || other.deadline == deadline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,deadline);

@override
String toString() {
  return 'Cache(key: $key, value: $value, deadline: $deadline)';
}


}

/// @nodoc
abstract mixin class $CacheCopyWith<$Res>  {
  factory $CacheCopyWith(Cache value, $Res Function(Cache) _then) = _$CacheCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'key') String key,@JsonKey(name: 'value') String? value,@JsonKey(name: 'deadline') int deadline
});




}
/// @nodoc
class _$CacheCopyWithImpl<$Res>
    implements $CacheCopyWith<$Res> {
  _$CacheCopyWithImpl(this._self, this._then);

  final Cache _self;
  final $Res Function(Cache) _then;

/// Create a copy of Cache
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? value = freezed,Object? deadline = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Cache].
extension CachePatterns on Cache {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cache value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cache() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cache value)  $default,){
final _that = this;
switch (_that) {
case _Cache():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cache value)?  $default,){
final _that = this;
switch (_that) {
case _Cache() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String key, @JsonKey(name: 'value')  String? value, @JsonKey(name: 'deadline')  int deadline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cache() when $default != null:
return $default(_that.key,_that.value,_that.deadline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'key')  String key, @JsonKey(name: 'value')  String? value, @JsonKey(name: 'deadline')  int deadline)  $default,) {final _that = this;
switch (_that) {
case _Cache():
return $default(_that.key,_that.value,_that.deadline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'key')  String key, @JsonKey(name: 'value')  String? value, @JsonKey(name: 'deadline')  int deadline)?  $default,) {final _that = this;
switch (_that) {
case _Cache() when $default != null:
return $default(_that.key,_that.value,_that.deadline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cache implements Cache {
  const _Cache({@JsonKey(name: 'key') required this.key, @JsonKey(name: 'value') this.value, @JsonKey(name: 'deadline') this.deadline = 0});
  factory _Cache.fromJson(Map<String, dynamic> json) => _$CacheFromJson(json);

@override@JsonKey(name: 'key') final  String key;
@override@JsonKey(name: 'value') final  String? value;
@override@JsonKey(name: 'deadline') final  int deadline;

/// Create a copy of Cache
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheCopyWith<_Cache> get copyWith => __$CacheCopyWithImpl<_Cache>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CacheToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cache&&(identical(other.key, key) || other.key == key)&&(identical(other.value, value) || other.value == value)&&(identical(other.deadline, deadline) || other.deadline == deadline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,value,deadline);

@override
String toString() {
  return 'Cache(key: $key, value: $value, deadline: $deadline)';
}


}

/// @nodoc
abstract mixin class _$CacheCopyWith<$Res> implements $CacheCopyWith<$Res> {
  factory _$CacheCopyWith(_Cache value, $Res Function(_Cache) _then) = __$CacheCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'key') String key,@JsonKey(name: 'value') String? value,@JsonKey(name: 'deadline') int deadline
});




}
/// @nodoc
class __$CacheCopyWithImpl<$Res>
    implements _$CacheCopyWith<$Res> {
  __$CacheCopyWithImpl(this._self, this._then);

  final _Cache _self;
  final $Res Function(_Cache) _then;

/// Create a copy of Cache
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? value = freezed,Object? deadline = null,}) {
  return _then(_Cache(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
