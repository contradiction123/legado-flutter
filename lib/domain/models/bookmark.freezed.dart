// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Bookmark {

@JsonKey(name: 'time') int? get time;@JsonKey(name: 'bookName') String get bookName;@JsonKey(name: 'bookAuthor') String get bookAuthor;@JsonKey(name: 'chapterIndex') int get chapterIndex;@JsonKey(name: 'chapterPos') int get chapterPos;@JsonKey(name: 'chapterName') String get chapterName;@JsonKey(name: 'bookText') String get bookText;@JsonKey(name: 'content') String get content;
/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkCopyWith<Bookmark> get copyWith => _$BookmarkCopyWithImpl<Bookmark>(this as Bookmark, _$identity);

  /// Serializes this Bookmark to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bookmark&&(identical(other.time, time) || other.time == time)&&(identical(other.bookName, bookName) || other.bookName == bookName)&&(identical(other.bookAuthor, bookAuthor) || other.bookAuthor == bookAuthor)&&(identical(other.chapterIndex, chapterIndex) || other.chapterIndex == chapterIndex)&&(identical(other.chapterPos, chapterPos) || other.chapterPos == chapterPos)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.bookText, bookText) || other.bookText == bookText)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,bookName,bookAuthor,chapterIndex,chapterPos,chapterName,bookText,content);

@override
String toString() {
  return 'Bookmark(time: $time, bookName: $bookName, bookAuthor: $bookAuthor, chapterIndex: $chapterIndex, chapterPos: $chapterPos, chapterName: $chapterName, bookText: $bookText, content: $content)';
}


}

/// @nodoc
abstract mixin class $BookmarkCopyWith<$Res>  {
  factory $BookmarkCopyWith(Bookmark value, $Res Function(Bookmark) _then) = _$BookmarkCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'time') int? time,@JsonKey(name: 'bookName') String bookName,@JsonKey(name: 'bookAuthor') String bookAuthor,@JsonKey(name: 'chapterIndex') int chapterIndex,@JsonKey(name: 'chapterPos') int chapterPos,@JsonKey(name: 'chapterName') String chapterName,@JsonKey(name: 'bookText') String bookText,@JsonKey(name: 'content') String content
});




}
/// @nodoc
class _$BookmarkCopyWithImpl<$Res>
    implements $BookmarkCopyWith<$Res> {
  _$BookmarkCopyWithImpl(this._self, this._then);

  final Bookmark _self;
  final $Res Function(Bookmark) _then;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = freezed,Object? bookName = null,Object? bookAuthor = null,Object? chapterIndex = null,Object? chapterPos = null,Object? chapterName = null,Object? bookText = null,Object? content = null,}) {
  return _then(_self.copyWith(
time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,bookName: null == bookName ? _self.bookName : bookName // ignore: cast_nullable_to_non_nullable
as String,bookAuthor: null == bookAuthor ? _self.bookAuthor : bookAuthor // ignore: cast_nullable_to_non_nullable
as String,chapterIndex: null == chapterIndex ? _self.chapterIndex : chapterIndex // ignore: cast_nullable_to_non_nullable
as int,chapterPos: null == chapterPos ? _self.chapterPos : chapterPos // ignore: cast_nullable_to_non_nullable
as int,chapterName: null == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String,bookText: null == bookText ? _self.bookText : bookText // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Bookmark].
extension BookmarkPatterns on Bookmark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bookmark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bookmark value)  $default,){
final _that = this;
switch (_that) {
case _Bookmark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bookmark value)?  $default,){
final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'time')  int? time, @JsonKey(name: 'bookName')  String bookName, @JsonKey(name: 'bookAuthor')  String bookAuthor, @JsonKey(name: 'chapterIndex')  int chapterIndex, @JsonKey(name: 'chapterPos')  int chapterPos, @JsonKey(name: 'chapterName')  String chapterName, @JsonKey(name: 'bookText')  String bookText, @JsonKey(name: 'content')  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
return $default(_that.time,_that.bookName,_that.bookAuthor,_that.chapterIndex,_that.chapterPos,_that.chapterName,_that.bookText,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'time')  int? time, @JsonKey(name: 'bookName')  String bookName, @JsonKey(name: 'bookAuthor')  String bookAuthor, @JsonKey(name: 'chapterIndex')  int chapterIndex, @JsonKey(name: 'chapterPos')  int chapterPos, @JsonKey(name: 'chapterName')  String chapterName, @JsonKey(name: 'bookText')  String bookText, @JsonKey(name: 'content')  String content)  $default,) {final _that = this;
switch (_that) {
case _Bookmark():
return $default(_that.time,_that.bookName,_that.bookAuthor,_that.chapterIndex,_that.chapterPos,_that.chapterName,_that.bookText,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'time')  int? time, @JsonKey(name: 'bookName')  String bookName, @JsonKey(name: 'bookAuthor')  String bookAuthor, @JsonKey(name: 'chapterIndex')  int chapterIndex, @JsonKey(name: 'chapterPos')  int chapterPos, @JsonKey(name: 'chapterName')  String chapterName, @JsonKey(name: 'bookText')  String bookText, @JsonKey(name: 'content')  String content)?  $default,) {final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
return $default(_that.time,_that.bookName,_that.bookAuthor,_that.chapterIndex,_that.chapterPos,_that.chapterName,_that.bookText,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Bookmark implements Bookmark {
  const _Bookmark({@JsonKey(name: 'time') this.time, @JsonKey(name: 'bookName') required this.bookName, @JsonKey(name: 'bookAuthor') this.bookAuthor = '', @JsonKey(name: 'chapterIndex') this.chapterIndex = 0, @JsonKey(name: 'chapterPos') this.chapterPos = 0, @JsonKey(name: 'chapterName') required this.chapterName, @JsonKey(name: 'bookText') required this.bookText, @JsonKey(name: 'content') required this.content});
  factory _Bookmark.fromJson(Map<String, dynamic> json) => _$BookmarkFromJson(json);

@override@JsonKey(name: 'time') final  int? time;
@override@JsonKey(name: 'bookName') final  String bookName;
@override@JsonKey(name: 'bookAuthor') final  String bookAuthor;
@override@JsonKey(name: 'chapterIndex') final  int chapterIndex;
@override@JsonKey(name: 'chapterPos') final  int chapterPos;
@override@JsonKey(name: 'chapterName') final  String chapterName;
@override@JsonKey(name: 'bookText') final  String bookText;
@override@JsonKey(name: 'content') final  String content;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkCopyWith<_Bookmark> get copyWith => __$BookmarkCopyWithImpl<_Bookmark>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookmarkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bookmark&&(identical(other.time, time) || other.time == time)&&(identical(other.bookName, bookName) || other.bookName == bookName)&&(identical(other.bookAuthor, bookAuthor) || other.bookAuthor == bookAuthor)&&(identical(other.chapterIndex, chapterIndex) || other.chapterIndex == chapterIndex)&&(identical(other.chapterPos, chapterPos) || other.chapterPos == chapterPos)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.bookText, bookText) || other.bookText == bookText)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,bookName,bookAuthor,chapterIndex,chapterPos,chapterName,bookText,content);

@override
String toString() {
  return 'Bookmark(time: $time, bookName: $bookName, bookAuthor: $bookAuthor, chapterIndex: $chapterIndex, chapterPos: $chapterPos, chapterName: $chapterName, bookText: $bookText, content: $content)';
}


}

/// @nodoc
abstract mixin class _$BookmarkCopyWith<$Res> implements $BookmarkCopyWith<$Res> {
  factory _$BookmarkCopyWith(_Bookmark value, $Res Function(_Bookmark) _then) = __$BookmarkCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'time') int? time,@JsonKey(name: 'bookName') String bookName,@JsonKey(name: 'bookAuthor') String bookAuthor,@JsonKey(name: 'chapterIndex') int chapterIndex,@JsonKey(name: 'chapterPos') int chapterPos,@JsonKey(name: 'chapterName') String chapterName,@JsonKey(name: 'bookText') String bookText,@JsonKey(name: 'content') String content
});




}
/// @nodoc
class __$BookmarkCopyWithImpl<$Res>
    implements _$BookmarkCopyWith<$Res> {
  __$BookmarkCopyWithImpl(this._self, this._then);

  final _Bookmark _self;
  final $Res Function(_Bookmark) _then;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = freezed,Object? bookName = null,Object? bookAuthor = null,Object? chapterIndex = null,Object? chapterPos = null,Object? chapterName = null,Object? bookText = null,Object? content = null,}) {
  return _then(_Bookmark(
time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,bookName: null == bookName ? _self.bookName : bookName // ignore: cast_nullable_to_non_nullable
as String,bookAuthor: null == bookAuthor ? _self.bookAuthor : bookAuthor // ignore: cast_nullable_to_non_nullable
as String,chapterIndex: null == chapterIndex ? _self.chapterIndex : chapterIndex // ignore: cast_nullable_to_non_nullable
as int,chapterPos: null == chapterPos ? _self.chapterPos : chapterPos // ignore: cast_nullable_to_non_nullable
as int,chapterName: null == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String,bookText: null == bookText ? _self.bookText : bookText // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
