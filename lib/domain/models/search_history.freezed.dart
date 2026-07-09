// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchKeyword {

@JsonKey(name: 'word') String get word;@JsonKey(name: 'usage') int get usage;@JsonKey(name: 'lastUseTime') int get lastUseTime;
/// Create a copy of SearchKeyword
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchKeywordCopyWith<SearchKeyword> get copyWith => _$SearchKeywordCopyWithImpl<SearchKeyword>(this as SearchKeyword, _$identity);

  /// Serializes this SearchKeyword to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchKeyword&&(identical(other.word, word) || other.word == word)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.lastUseTime, lastUseTime) || other.lastUseTime == lastUseTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,usage,lastUseTime);

@override
String toString() {
  return 'SearchKeyword(word: $word, usage: $usage, lastUseTime: $lastUseTime)';
}


}

/// @nodoc
abstract mixin class $SearchKeywordCopyWith<$Res>  {
  factory $SearchKeywordCopyWith(SearchKeyword value, $Res Function(SearchKeyword) _then) = _$SearchKeywordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'word') String word,@JsonKey(name: 'usage') int usage,@JsonKey(name: 'lastUseTime') int lastUseTime
});




}
/// @nodoc
class _$SearchKeywordCopyWithImpl<$Res>
    implements $SearchKeywordCopyWith<$Res> {
  _$SearchKeywordCopyWithImpl(this._self, this._then);

  final SearchKeyword _self;
  final $Res Function(SearchKeyword) _then;

/// Create a copy of SearchKeyword
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? usage = null,Object? lastUseTime = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as int,lastUseTime: null == lastUseTime ? _self.lastUseTime : lastUseTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchKeyword].
extension SearchKeywordPatterns on SearchKeyword {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchKeyword value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchKeyword() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchKeyword value)  $default,){
final _that = this;
switch (_that) {
case _SearchKeyword():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchKeyword value)?  $default,){
final _that = this;
switch (_that) {
case _SearchKeyword() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'word')  String word, @JsonKey(name: 'usage')  int usage, @JsonKey(name: 'lastUseTime')  int lastUseTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchKeyword() when $default != null:
return $default(_that.word,_that.usage,_that.lastUseTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'word')  String word, @JsonKey(name: 'usage')  int usage, @JsonKey(name: 'lastUseTime')  int lastUseTime)  $default,) {final _that = this;
switch (_that) {
case _SearchKeyword():
return $default(_that.word,_that.usage,_that.lastUseTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'word')  String word, @JsonKey(name: 'usage')  int usage, @JsonKey(name: 'lastUseTime')  int lastUseTime)?  $default,) {final _that = this;
switch (_that) {
case _SearchKeyword() when $default != null:
return $default(_that.word,_that.usage,_that.lastUseTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchKeyword implements SearchKeyword {
  const _SearchKeyword({@JsonKey(name: 'word') required this.word, @JsonKey(name: 'usage') this.usage = 1, @JsonKey(name: 'lastUseTime') this.lastUseTime = 0});
  factory _SearchKeyword.fromJson(Map<String, dynamic> json) => _$SearchKeywordFromJson(json);

@override@JsonKey(name: 'word') final  String word;
@override@JsonKey(name: 'usage') final  int usage;
@override@JsonKey(name: 'lastUseTime') final  int lastUseTime;

/// Create a copy of SearchKeyword
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchKeywordCopyWith<_SearchKeyword> get copyWith => __$SearchKeywordCopyWithImpl<_SearchKeyword>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchKeywordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchKeyword&&(identical(other.word, word) || other.word == word)&&(identical(other.usage, usage) || other.usage == usage)&&(identical(other.lastUseTime, lastUseTime) || other.lastUseTime == lastUseTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,usage,lastUseTime);

@override
String toString() {
  return 'SearchKeyword(word: $word, usage: $usage, lastUseTime: $lastUseTime)';
}


}

/// @nodoc
abstract mixin class _$SearchKeywordCopyWith<$Res> implements $SearchKeywordCopyWith<$Res> {
  factory _$SearchKeywordCopyWith(_SearchKeyword value, $Res Function(_SearchKeyword) _then) = __$SearchKeywordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'word') String word,@JsonKey(name: 'usage') int usage,@JsonKey(name: 'lastUseTime') int lastUseTime
});




}
/// @nodoc
class __$SearchKeywordCopyWithImpl<$Res>
    implements _$SearchKeywordCopyWith<$Res> {
  __$SearchKeywordCopyWithImpl(this._self, this._then);

  final _SearchKeyword _self;
  final $Res Function(_SearchKeyword) _then;

/// Create a copy of SearchKeyword
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? usage = null,Object? lastUseTime = null,}) {
  return _then(_SearchKeyword(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as int,lastUseTime: null == lastUseTime ? _self.lastUseTime : lastUseTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
