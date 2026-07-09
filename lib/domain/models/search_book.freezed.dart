// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchBook {

@JsonKey(name: 'bookUrl') String get bookUrl;@JsonKey(name: 'origin') String get origin;@JsonKey(name: 'originName') String get originName;@JsonKey(name: 'type') int get type;@JsonKey(name: 'name') String get name;@JsonKey(name: 'author') String get author;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'coverUrl') String? get coverUrl;@JsonKey(name: 'intro') String? get intro;@JsonKey(name: 'wordCount') String? get wordCount;@JsonKey(name: 'latestChapterTitle') String? get latestChapterTitle;@JsonKey(name: 'tocUrl') String get tocUrl;@JsonKey(name: 'time') int? get time;@JsonKey(name: 'variable') String? get variable;@JsonKey(name: 'originOrder') int get originOrder;@JsonKey(name: 'chapterWordCountText') String? get chapterWordCountText;@JsonKey(name: 'chapterWordCount') int get chapterWordCount;@JsonKey(name: 'respondTime') int get respondTime;
/// Create a copy of SearchBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchBookCopyWith<SearchBook> get copyWith => _$SearchBookCopyWithImpl<SearchBook>(this as SearchBook, _$identity);

  /// Serializes this SearchBook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchBook&&(identical(other.bookUrl, bookUrl) || other.bookUrl == bookUrl)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.originName, originName) || other.originName == originName)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.latestChapterTitle, latestChapterTitle) || other.latestChapterTitle == latestChapterTitle)&&(identical(other.tocUrl, tocUrl) || other.tocUrl == tocUrl)&&(identical(other.time, time) || other.time == time)&&(identical(other.variable, variable) || other.variable == variable)&&(identical(other.originOrder, originOrder) || other.originOrder == originOrder)&&(identical(other.chapterWordCountText, chapterWordCountText) || other.chapterWordCountText == chapterWordCountText)&&(identical(other.chapterWordCount, chapterWordCount) || other.chapterWordCount == chapterWordCount)&&(identical(other.respondTime, respondTime) || other.respondTime == respondTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookUrl,origin,originName,type,name,author,kind,coverUrl,intro,wordCount,latestChapterTitle,tocUrl,time,variable,originOrder,chapterWordCountText,chapterWordCount,respondTime);

@override
String toString() {
  return 'SearchBook(bookUrl: $bookUrl, origin: $origin, originName: $originName, type: $type, name: $name, author: $author, kind: $kind, coverUrl: $coverUrl, intro: $intro, wordCount: $wordCount, latestChapterTitle: $latestChapterTitle, tocUrl: $tocUrl, time: $time, variable: $variable, originOrder: $originOrder, chapterWordCountText: $chapterWordCountText, chapterWordCount: $chapterWordCount, respondTime: $respondTime)';
}


}

/// @nodoc
abstract mixin class $SearchBookCopyWith<$Res>  {
  factory $SearchBookCopyWith(SearchBook value, $Res Function(SearchBook) _then) = _$SearchBookCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bookUrl') String bookUrl,@JsonKey(name: 'origin') String origin,@JsonKey(name: 'originName') String originName,@JsonKey(name: 'type') int type,@JsonKey(name: 'name') String name,@JsonKey(name: 'author') String author,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'wordCount') String? wordCount,@JsonKey(name: 'latestChapterTitle') String? latestChapterTitle,@JsonKey(name: 'tocUrl') String tocUrl,@JsonKey(name: 'time') int? time,@JsonKey(name: 'variable') String? variable,@JsonKey(name: 'originOrder') int originOrder,@JsonKey(name: 'chapterWordCountText') String? chapterWordCountText,@JsonKey(name: 'chapterWordCount') int chapterWordCount,@JsonKey(name: 'respondTime') int respondTime
});




}
/// @nodoc
class _$SearchBookCopyWithImpl<$Res>
    implements $SearchBookCopyWith<$Res> {
  _$SearchBookCopyWithImpl(this._self, this._then);

  final SearchBook _self;
  final $Res Function(SearchBook) _then;

/// Create a copy of SearchBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookUrl = null,Object? origin = null,Object? originName = null,Object? type = null,Object? name = null,Object? author = null,Object? kind = freezed,Object? coverUrl = freezed,Object? intro = freezed,Object? wordCount = freezed,Object? latestChapterTitle = freezed,Object? tocUrl = null,Object? time = freezed,Object? variable = freezed,Object? originOrder = null,Object? chapterWordCountText = freezed,Object? chapterWordCount = null,Object? respondTime = null,}) {
  return _then(_self.copyWith(
bookUrl: null == bookUrl ? _self.bookUrl : bookUrl // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,originName: null == originName ? _self.originName : originName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,latestChapterTitle: freezed == latestChapterTitle ? _self.latestChapterTitle : latestChapterTitle // ignore: cast_nullable_to_non_nullable
as String?,tocUrl: null == tocUrl ? _self.tocUrl : tocUrl // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as String?,originOrder: null == originOrder ? _self.originOrder : originOrder // ignore: cast_nullable_to_non_nullable
as int,chapterWordCountText: freezed == chapterWordCountText ? _self.chapterWordCountText : chapterWordCountText // ignore: cast_nullable_to_non_nullable
as String?,chapterWordCount: null == chapterWordCount ? _self.chapterWordCount : chapterWordCount // ignore: cast_nullable_to_non_nullable
as int,respondTime: null == respondTime ? _self.respondTime : respondTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchBook].
extension SearchBookPatterns on SearchBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchBook value)  $default,){
final _that = this;
switch (_that) {
case _SearchBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchBook value)?  $default,){
final _that = this;
switch (_that) {
case _SearchBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookUrl')  String bookUrl, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'originName')  String originName, @JsonKey(name: 'type')  int type, @JsonKey(name: 'name')  String name, @JsonKey(name: 'author')  String author, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'latestChapterTitle')  String? latestChapterTitle, @JsonKey(name: 'tocUrl')  String tocUrl, @JsonKey(name: 'time')  int? time, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'originOrder')  int originOrder, @JsonKey(name: 'chapterWordCountText')  String? chapterWordCountText, @JsonKey(name: 'chapterWordCount')  int chapterWordCount, @JsonKey(name: 'respondTime')  int respondTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchBook() when $default != null:
return $default(_that.bookUrl,_that.origin,_that.originName,_that.type,_that.name,_that.author,_that.kind,_that.coverUrl,_that.intro,_that.wordCount,_that.latestChapterTitle,_that.tocUrl,_that.time,_that.variable,_that.originOrder,_that.chapterWordCountText,_that.chapterWordCount,_that.respondTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookUrl')  String bookUrl, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'originName')  String originName, @JsonKey(name: 'type')  int type, @JsonKey(name: 'name')  String name, @JsonKey(name: 'author')  String author, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'latestChapterTitle')  String? latestChapterTitle, @JsonKey(name: 'tocUrl')  String tocUrl, @JsonKey(name: 'time')  int? time, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'originOrder')  int originOrder, @JsonKey(name: 'chapterWordCountText')  String? chapterWordCountText, @JsonKey(name: 'chapterWordCount')  int chapterWordCount, @JsonKey(name: 'respondTime')  int respondTime)  $default,) {final _that = this;
switch (_that) {
case _SearchBook():
return $default(_that.bookUrl,_that.origin,_that.originName,_that.type,_that.name,_that.author,_that.kind,_that.coverUrl,_that.intro,_that.wordCount,_that.latestChapterTitle,_that.tocUrl,_that.time,_that.variable,_that.originOrder,_that.chapterWordCountText,_that.chapterWordCount,_that.respondTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bookUrl')  String bookUrl, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'originName')  String originName, @JsonKey(name: 'type')  int type, @JsonKey(name: 'name')  String name, @JsonKey(name: 'author')  String author, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'latestChapterTitle')  String? latestChapterTitle, @JsonKey(name: 'tocUrl')  String tocUrl, @JsonKey(name: 'time')  int? time, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'originOrder')  int originOrder, @JsonKey(name: 'chapterWordCountText')  String? chapterWordCountText, @JsonKey(name: 'chapterWordCount')  int chapterWordCount, @JsonKey(name: 'respondTime')  int respondTime)?  $default,) {final _that = this;
switch (_that) {
case _SearchBook() when $default != null:
return $default(_that.bookUrl,_that.origin,_that.originName,_that.type,_that.name,_that.author,_that.kind,_that.coverUrl,_that.intro,_that.wordCount,_that.latestChapterTitle,_that.tocUrl,_that.time,_that.variable,_that.originOrder,_that.chapterWordCountText,_that.chapterWordCount,_that.respondTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchBook implements SearchBook {
  const _SearchBook({@JsonKey(name: 'bookUrl') required this.bookUrl, @JsonKey(name: 'origin') required this.origin, @JsonKey(name: 'originName') required this.originName, @JsonKey(name: 'type') this.type = 8, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'author') required this.author, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'coverUrl') this.coverUrl, @JsonKey(name: 'intro') this.intro, @JsonKey(name: 'wordCount') this.wordCount, @JsonKey(name: 'latestChapterTitle') this.latestChapterTitle, @JsonKey(name: 'tocUrl') required this.tocUrl, @JsonKey(name: 'time') this.time, @JsonKey(name: 'variable') this.variable, @JsonKey(name: 'originOrder') this.originOrder = 0, @JsonKey(name: 'chapterWordCountText') this.chapterWordCountText, @JsonKey(name: 'chapterWordCount') this.chapterWordCount = -1, @JsonKey(name: 'respondTime') this.respondTime = -1});
  factory _SearchBook.fromJson(Map<String, dynamic> json) => _$SearchBookFromJson(json);

@override@JsonKey(name: 'bookUrl') final  String bookUrl;
@override@JsonKey(name: 'origin') final  String origin;
@override@JsonKey(name: 'originName') final  String originName;
@override@JsonKey(name: 'type') final  int type;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'author') final  String author;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;
@override@JsonKey(name: 'intro') final  String? intro;
@override@JsonKey(name: 'wordCount') final  String? wordCount;
@override@JsonKey(name: 'latestChapterTitle') final  String? latestChapterTitle;
@override@JsonKey(name: 'tocUrl') final  String tocUrl;
@override@JsonKey(name: 'time') final  int? time;
@override@JsonKey(name: 'variable') final  String? variable;
@override@JsonKey(name: 'originOrder') final  int originOrder;
@override@JsonKey(name: 'chapterWordCountText') final  String? chapterWordCountText;
@override@JsonKey(name: 'chapterWordCount') final  int chapterWordCount;
@override@JsonKey(name: 'respondTime') final  int respondTime;

/// Create a copy of SearchBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchBookCopyWith<_SearchBook> get copyWith => __$SearchBookCopyWithImpl<_SearchBook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchBookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchBook&&(identical(other.bookUrl, bookUrl) || other.bookUrl == bookUrl)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.originName, originName) || other.originName == originName)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.latestChapterTitle, latestChapterTitle) || other.latestChapterTitle == latestChapterTitle)&&(identical(other.tocUrl, tocUrl) || other.tocUrl == tocUrl)&&(identical(other.time, time) || other.time == time)&&(identical(other.variable, variable) || other.variable == variable)&&(identical(other.originOrder, originOrder) || other.originOrder == originOrder)&&(identical(other.chapterWordCountText, chapterWordCountText) || other.chapterWordCountText == chapterWordCountText)&&(identical(other.chapterWordCount, chapterWordCount) || other.chapterWordCount == chapterWordCount)&&(identical(other.respondTime, respondTime) || other.respondTime == respondTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bookUrl,origin,originName,type,name,author,kind,coverUrl,intro,wordCount,latestChapterTitle,tocUrl,time,variable,originOrder,chapterWordCountText,chapterWordCount,respondTime);

@override
String toString() {
  return 'SearchBook(bookUrl: $bookUrl, origin: $origin, originName: $originName, type: $type, name: $name, author: $author, kind: $kind, coverUrl: $coverUrl, intro: $intro, wordCount: $wordCount, latestChapterTitle: $latestChapterTitle, tocUrl: $tocUrl, time: $time, variable: $variable, originOrder: $originOrder, chapterWordCountText: $chapterWordCountText, chapterWordCount: $chapterWordCount, respondTime: $respondTime)';
}


}

/// @nodoc
abstract mixin class _$SearchBookCopyWith<$Res> implements $SearchBookCopyWith<$Res> {
  factory _$SearchBookCopyWith(_SearchBook value, $Res Function(_SearchBook) _then) = __$SearchBookCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bookUrl') String bookUrl,@JsonKey(name: 'origin') String origin,@JsonKey(name: 'originName') String originName,@JsonKey(name: 'type') int type,@JsonKey(name: 'name') String name,@JsonKey(name: 'author') String author,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'wordCount') String? wordCount,@JsonKey(name: 'latestChapterTitle') String? latestChapterTitle,@JsonKey(name: 'tocUrl') String tocUrl,@JsonKey(name: 'time') int? time,@JsonKey(name: 'variable') String? variable,@JsonKey(name: 'originOrder') int originOrder,@JsonKey(name: 'chapterWordCountText') String? chapterWordCountText,@JsonKey(name: 'chapterWordCount') int chapterWordCount,@JsonKey(name: 'respondTime') int respondTime
});




}
/// @nodoc
class __$SearchBookCopyWithImpl<$Res>
    implements _$SearchBookCopyWith<$Res> {
  __$SearchBookCopyWithImpl(this._self, this._then);

  final _SearchBook _self;
  final $Res Function(_SearchBook) _then;

/// Create a copy of SearchBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookUrl = null,Object? origin = null,Object? originName = null,Object? type = null,Object? name = null,Object? author = null,Object? kind = freezed,Object? coverUrl = freezed,Object? intro = freezed,Object? wordCount = freezed,Object? latestChapterTitle = freezed,Object? tocUrl = null,Object? time = freezed,Object? variable = freezed,Object? originOrder = null,Object? chapterWordCountText = freezed,Object? chapterWordCount = null,Object? respondTime = null,}) {
  return _then(_SearchBook(
bookUrl: null == bookUrl ? _self.bookUrl : bookUrl // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,originName: null == originName ? _self.originName : originName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,latestChapterTitle: freezed == latestChapterTitle ? _self.latestChapterTitle : latestChapterTitle // ignore: cast_nullable_to_non_nullable
as String?,tocUrl: null == tocUrl ? _self.tocUrl : tocUrl // ignore: cast_nullable_to_non_nullable
as String,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int?,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as String?,originOrder: null == originOrder ? _self.originOrder : originOrder // ignore: cast_nullable_to_non_nullable
as int,chapterWordCountText: freezed == chapterWordCountText ? _self.chapterWordCountText : chapterWordCountText // ignore: cast_nullable_to_non_nullable
as String?,chapterWordCount: null == chapterWordCount ? _self.chapterWordCount : chapterWordCount // ignore: cast_nullable_to_non_nullable
as int,respondTime: null == respondTime ? _self.respondTime : respondTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
