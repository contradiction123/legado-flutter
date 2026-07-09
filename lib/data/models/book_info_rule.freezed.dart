// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_info_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookInfoRule {

@JsonKey(name: 'init') String? get init;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'intro') String? get intro;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'lastChapter') String? get lastChapter;@JsonKey(name: 'updateTime') String? get updateTime;@JsonKey(name: 'coverUrl') String? get coverUrl;@JsonKey(name: 'tocUrl') String? get tocUrl;@JsonKey(name: 'wordCount') String? get wordCount;@JsonKey(name: 'canReName') String? get canReName;@JsonKey(name: 'downloadUrls') String? get downloadUrls;@JsonKey(name: 'relatedBooks') String? get relatedBooks;
/// Create a copy of BookInfoRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookInfoRuleCopyWith<BookInfoRule> get copyWith => _$BookInfoRuleCopyWithImpl<BookInfoRule>(this as BookInfoRule, _$identity);

  /// Serializes this BookInfoRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookInfoRule&&(identical(other.init, init) || other.init == init)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.tocUrl, tocUrl) || other.tocUrl == tocUrl)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.canReName, canReName) || other.canReName == canReName)&&(identical(other.downloadUrls, downloadUrls) || other.downloadUrls == downloadUrls)&&(identical(other.relatedBooks, relatedBooks) || other.relatedBooks == relatedBooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,init,name,author,intro,kind,lastChapter,updateTime,coverUrl,tocUrl,wordCount,canReName,downloadUrls,relatedBooks);

@override
String toString() {
  return 'BookInfoRule(init: $init, name: $name, author: $author, intro: $intro, kind: $kind, lastChapter: $lastChapter, updateTime: $updateTime, coverUrl: $coverUrl, tocUrl: $tocUrl, wordCount: $wordCount, canReName: $canReName, downloadUrls: $downloadUrls, relatedBooks: $relatedBooks)';
}


}

/// @nodoc
abstract mixin class $BookInfoRuleCopyWith<$Res>  {
  factory $BookInfoRuleCopyWith(BookInfoRule value, $Res Function(BookInfoRule) _then) = _$BookInfoRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'init') String? init,@JsonKey(name: 'name') String? name,@JsonKey(name: 'author') String? author,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'lastChapter') String? lastChapter,@JsonKey(name: 'updateTime') String? updateTime,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'tocUrl') String? tocUrl,@JsonKey(name: 'wordCount') String? wordCount,@JsonKey(name: 'canReName') String? canReName,@JsonKey(name: 'downloadUrls') String? downloadUrls,@JsonKey(name: 'relatedBooks') String? relatedBooks
});




}
/// @nodoc
class _$BookInfoRuleCopyWithImpl<$Res>
    implements $BookInfoRuleCopyWith<$Res> {
  _$BookInfoRuleCopyWithImpl(this._self, this._then);

  final BookInfoRule _self;
  final $Res Function(BookInfoRule) _then;

/// Create a copy of BookInfoRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? init = freezed,Object? name = freezed,Object? author = freezed,Object? intro = freezed,Object? kind = freezed,Object? lastChapter = freezed,Object? updateTime = freezed,Object? coverUrl = freezed,Object? tocUrl = freezed,Object? wordCount = freezed,Object? canReName = freezed,Object? downloadUrls = freezed,Object? relatedBooks = freezed,}) {
  return _then(_self.copyWith(
init: freezed == init ? _self.init : init // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lastChapter: freezed == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,tocUrl: freezed == tocUrl ? _self.tocUrl : tocUrl // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,canReName: freezed == canReName ? _self.canReName : canReName // ignore: cast_nullable_to_non_nullable
as String?,downloadUrls: freezed == downloadUrls ? _self.downloadUrls : downloadUrls // ignore: cast_nullable_to_non_nullable
as String?,relatedBooks: freezed == relatedBooks ? _self.relatedBooks : relatedBooks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookInfoRule].
extension BookInfoRulePatterns on BookInfoRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookInfoRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookInfoRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookInfoRule value)  $default,){
final _that = this;
switch (_that) {
case _BookInfoRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookInfoRule value)?  $default,){
final _that = this;
switch (_that) {
case _BookInfoRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'init')  String? init, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'lastChapter')  String? lastChapter, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'tocUrl')  String? tocUrl, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'canReName')  String? canReName, @JsonKey(name: 'downloadUrls')  String? downloadUrls, @JsonKey(name: 'relatedBooks')  String? relatedBooks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookInfoRule() when $default != null:
return $default(_that.init,_that.name,_that.author,_that.intro,_that.kind,_that.lastChapter,_that.updateTime,_that.coverUrl,_that.tocUrl,_that.wordCount,_that.canReName,_that.downloadUrls,_that.relatedBooks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'init')  String? init, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'lastChapter')  String? lastChapter, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'tocUrl')  String? tocUrl, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'canReName')  String? canReName, @JsonKey(name: 'downloadUrls')  String? downloadUrls, @JsonKey(name: 'relatedBooks')  String? relatedBooks)  $default,) {final _that = this;
switch (_that) {
case _BookInfoRule():
return $default(_that.init,_that.name,_that.author,_that.intro,_that.kind,_that.lastChapter,_that.updateTime,_that.coverUrl,_that.tocUrl,_that.wordCount,_that.canReName,_that.downloadUrls,_that.relatedBooks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'init')  String? init, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'lastChapter')  String? lastChapter, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'tocUrl')  String? tocUrl, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'canReName')  String? canReName, @JsonKey(name: 'downloadUrls')  String? downloadUrls, @JsonKey(name: 'relatedBooks')  String? relatedBooks)?  $default,) {final _that = this;
switch (_that) {
case _BookInfoRule() when $default != null:
return $default(_that.init,_that.name,_that.author,_that.intro,_that.kind,_that.lastChapter,_that.updateTime,_that.coverUrl,_that.tocUrl,_that.wordCount,_that.canReName,_that.downloadUrls,_that.relatedBooks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookInfoRule implements BookInfoRule {
  const _BookInfoRule({@JsonKey(name: 'init') this.init, @JsonKey(name: 'name') this.name, @JsonKey(name: 'author') this.author, @JsonKey(name: 'intro') this.intro, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'lastChapter') this.lastChapter, @JsonKey(name: 'updateTime') this.updateTime, @JsonKey(name: 'coverUrl') this.coverUrl, @JsonKey(name: 'tocUrl') this.tocUrl, @JsonKey(name: 'wordCount') this.wordCount, @JsonKey(name: 'canReName') this.canReName, @JsonKey(name: 'downloadUrls') this.downloadUrls, @JsonKey(name: 'relatedBooks') this.relatedBooks});
  factory _BookInfoRule.fromJson(Map<String, dynamic> json) => _$BookInfoRuleFromJson(json);

@override@JsonKey(name: 'init') final  String? init;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'intro') final  String? intro;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'lastChapter') final  String? lastChapter;
@override@JsonKey(name: 'updateTime') final  String? updateTime;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;
@override@JsonKey(name: 'tocUrl') final  String? tocUrl;
@override@JsonKey(name: 'wordCount') final  String? wordCount;
@override@JsonKey(name: 'canReName') final  String? canReName;
@override@JsonKey(name: 'downloadUrls') final  String? downloadUrls;
@override@JsonKey(name: 'relatedBooks') final  String? relatedBooks;

/// Create a copy of BookInfoRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookInfoRuleCopyWith<_BookInfoRule> get copyWith => __$BookInfoRuleCopyWithImpl<_BookInfoRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookInfoRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookInfoRule&&(identical(other.init, init) || other.init == init)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lastChapter, lastChapter) || other.lastChapter == lastChapter)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.tocUrl, tocUrl) || other.tocUrl == tocUrl)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.canReName, canReName) || other.canReName == canReName)&&(identical(other.downloadUrls, downloadUrls) || other.downloadUrls == downloadUrls)&&(identical(other.relatedBooks, relatedBooks) || other.relatedBooks == relatedBooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,init,name,author,intro,kind,lastChapter,updateTime,coverUrl,tocUrl,wordCount,canReName,downloadUrls,relatedBooks);

@override
String toString() {
  return 'BookInfoRule(init: $init, name: $name, author: $author, intro: $intro, kind: $kind, lastChapter: $lastChapter, updateTime: $updateTime, coverUrl: $coverUrl, tocUrl: $tocUrl, wordCount: $wordCount, canReName: $canReName, downloadUrls: $downloadUrls, relatedBooks: $relatedBooks)';
}


}

/// @nodoc
abstract mixin class _$BookInfoRuleCopyWith<$Res> implements $BookInfoRuleCopyWith<$Res> {
  factory _$BookInfoRuleCopyWith(_BookInfoRule value, $Res Function(_BookInfoRule) _then) = __$BookInfoRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'init') String? init,@JsonKey(name: 'name') String? name,@JsonKey(name: 'author') String? author,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'lastChapter') String? lastChapter,@JsonKey(name: 'updateTime') String? updateTime,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'tocUrl') String? tocUrl,@JsonKey(name: 'wordCount') String? wordCount,@JsonKey(name: 'canReName') String? canReName,@JsonKey(name: 'downloadUrls') String? downloadUrls,@JsonKey(name: 'relatedBooks') String? relatedBooks
});




}
/// @nodoc
class __$BookInfoRuleCopyWithImpl<$Res>
    implements _$BookInfoRuleCopyWith<$Res> {
  __$BookInfoRuleCopyWithImpl(this._self, this._then);

  final _BookInfoRule _self;
  final $Res Function(_BookInfoRule) _then;

/// Create a copy of BookInfoRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? init = freezed,Object? name = freezed,Object? author = freezed,Object? intro = freezed,Object? kind = freezed,Object? lastChapter = freezed,Object? updateTime = freezed,Object? coverUrl = freezed,Object? tocUrl = freezed,Object? wordCount = freezed,Object? canReName = freezed,Object? downloadUrls = freezed,Object? relatedBooks = freezed,}) {
  return _then(_BookInfoRule(
init: freezed == init ? _self.init : init // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lastChapter: freezed == lastChapter ? _self.lastChapter : lastChapter // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,tocUrl: freezed == tocUrl ? _self.tocUrl : tocUrl // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,canReName: freezed == canReName ? _self.canReName : canReName // ignore: cast_nullable_to_non_nullable
as String?,downloadUrls: freezed == downloadUrls ? _self.downloadUrls : downloadUrls // ignore: cast_nullable_to_non_nullable
as String?,relatedBooks: freezed == relatedBooks ? _self.relatedBooks : relatedBooks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
