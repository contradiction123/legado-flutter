// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_list_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookListRule {

@JsonKey(name: 'bookList') String? get bookList;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'intro') String? get intro;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'lastChapter') String? get lastChapter;@JsonKey(name: 'updateTime') String? get updateTime;@JsonKey(name: 'bookUrl') String? get bookUrl;@JsonKey(name: 'coverUrl') String? get coverUrl;@JsonKey(name: 'wordCount') String? get wordCount;
/// Create a copy of BookListRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookListRuleCopyWith<BookListRule> get copyWith => _$BookListRuleCopyWithImpl<BookListRule>(this as BookListRule, _$identity);

  /// Serializes this BookListRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookListRule&&(identical(other.bookList, bookList) || other.bookList == bookList)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.bookUrl, bookUrl) || other.bookUrl == bookUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookList,name,author,intro,kind,lastChapter,updateTime,bookUrl,coverUrl,wordCount);

@override
String toString() {
  return 'BookListRule(bookList: $bookList, name: $name, author: $author, intro: $intro, kind: $kind, lastChapter: $lastChapter, updateTime: $updateTime, bookUrl: $bookUrl, coverUrl: $coverUrl, wordCount: $wordCount)';
}


}

/// @nodoc
abstract mixin class $BookListRuleCopyWith<$Res>  {
  factory $BookListRuleCopyWith(BookListRule value, $Res Function(BookListRule) _then) = _$BookListRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bookList') String? bookList,@JsonKey(name: 'name') String? name,@JsonKey(name: 'author') String? author,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'lastChapter') String? lastChapter,@JsonKey(name: 'updateTime') String? updateTime,@JsonKey(name: 'bookUrl') String? bookUrl,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'wordCount') String? wordCount
});




}
/// @nodoc
class _$BookListRuleCopyWithImpl<$Res>
    implements $BookListRuleCopyWith<$Res> {
  _$BookListRuleCopyWithImpl(this._self, this._then);

  final BookListRule _self;
  final $Res Function(BookListRule) _then;

/// Create a copy of BookListRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookList = freezed,Object? name = freezed,Object? author = freezed,Object? intro = freezed,Object? kind = freezed,Object? lastChapter = freezed,Object? updateTime = freezed,Object? bookUrl = freezed,Object? coverUrl = freezed,Object? wordCount = freezed,}) {
  return _then(_self.copyWith(
bookList: freezed == bookList ? _self.bookList : bookList // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lastChapter: freezed == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,bookUrl: freezed == bookUrl ? _self.bookUrl : bookUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookListRule].
extension BookListRulePatterns on BookListRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookListRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookListRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookListRule value)  $default,){
final _that = this;
switch (_that) {
case _BookListRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookListRule value)?  $default,){
final _that = this;
switch (_that) {
case _BookListRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookList')  String? bookList, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'lastChapter')  String? lastChapter, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'bookUrl')  String? bookUrl, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'wordCount')  String? wordCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookListRule() when $default != null:
return $default(_that.bookList,_that.name,_that.author,_that.intro,_that.kind,_that.lastChapter,_that.updateTime,_that.bookUrl,_that.coverUrl,_that.wordCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookList')  String? bookList, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'lastChapter')  String? lastChapter, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'bookUrl')  String? bookUrl, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'wordCount')  String? wordCount)  $default,) {final _that = this;
switch (_that) {
case _BookListRule():
return $default(_that.bookList,_that.name,_that.author,_that.intro,_that.kind,_that.lastChapter,_that.updateTime,_that.bookUrl,_that.coverUrl,_that.wordCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bookList')  String? bookList, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'lastChapter')  String? lastChapter, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'bookUrl')  String? bookUrl, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'wordCount')  String? wordCount)?  $default,) {final _that = this;
switch (_that) {
case _BookListRule() when $default != null:
return $default(_that.bookList,_that.name,_that.author,_that.intro,_that.kind,_that.lastChapter,_that.updateTime,_that.bookUrl,_that.coverUrl,_that.wordCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookListRule implements BookListRule {
  const _BookListRule({@JsonKey(name: 'bookList') this.bookList, @JsonKey(name: 'name') this.name, @JsonKey(name: 'author') this.author, @JsonKey(name: 'intro') this.intro, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'lastChapter') this.lastChapter, @JsonKey(name: 'updateTime') this.updateTime, @JsonKey(name: 'bookUrl') this.bookUrl, @JsonKey(name: 'coverUrl') this.coverUrl, @JsonKey(name: 'wordCount') this.wordCount});
  factory _BookListRule.fromJson(Map<String, dynamic> json) => _$BookListRuleFromJson(json);

@override@JsonKey(name: 'bookList') final  String? bookList;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'intro') final  String? intro;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'lastChapter') final  String? lastChapter;
@override@JsonKey(name: 'updateTime') final  String? updateTime;
@override@JsonKey(name: 'bookUrl') final  String? bookUrl;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;
@override@JsonKey(name: 'wordCount') final  String? wordCount;

/// Create a copy of BookListRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookListRuleCopyWith<_BookListRule> get copyWith => __$BookListRuleCopyWithImpl<_BookListRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookListRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookListRule&&(identical(other.bookList, bookList) || other.bookList == bookList)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.bookUrl, bookUrl) || other.bookUrl == bookUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookList,name,author,intro,kind,lastChapter,updateTime,bookUrl,coverUrl,wordCount);

@override
String toString() {
  return 'BookListRule(bookList: $bookList, name: $name, author: $author, intro: $intro, kind: $kind, lastChapter: $lastChapter, updateTime: $updateTime, bookUrl: $bookUrl, coverUrl: $coverUrl, wordCount: $wordCount)';
}


}

/// @nodoc
abstract mixin class _$BookListRuleCopyWith<$Res> implements $BookListRuleCopyWith<$Res> {
  factory _$BookListRuleCopyWith(_BookListRule value, $Res Function(_BookListRule) _then) = __$BookListRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bookList') String? bookList,@JsonKey(name: 'name') String? name,@JsonKey(name: 'author') String? author,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'lastChapter') String? lastChapter,@JsonKey(name: 'updateTime') String? updateTime,@JsonKey(name: 'bookUrl') String? bookUrl,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'wordCount') String? wordCount
});




}
/// @nodoc
class __$BookListRuleCopyWithImpl<$Res>
    implements _$BookListRuleCopyWith<$Res> {
  __$BookListRuleCopyWithImpl(this._self, this._then);

  final _BookListRule _self;
  final $Res Function(_BookListRule) _then;

/// Create a copy of BookListRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookList = freezed,Object? name = freezed,Object? author = freezed,Object? intro = freezed,Object? kind = freezed,Object? lastChapter = freezed,Object? updateTime = freezed,Object? bookUrl = freezed,Object? coverUrl = freezed,Object? wordCount = freezed,}) {
  return _then(_BookListRule(
bookList: freezed == bookList ? _self.bookList : bookList // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lastChapter: freezed == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,bookUrl: freezed == bookUrl ? _self.bookUrl : bookUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
