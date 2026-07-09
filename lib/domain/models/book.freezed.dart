// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Book {

@JsonKey(name: 'bookUrl') String get bookUrl;@JsonKey(name: 'tocUrl') String get tocUrl;@JsonKey(name: 'origin') String get origin;@JsonKey(name: 'originName') String get originName;@JsonKey(name: 'name') String get name;@JsonKey(name: 'author') String get author;@JsonKey(name: 'kind') String? get kind;@JsonKey(name: 'customTag') String? get customTag;@JsonKey(name: 'coverUrl') String? get coverUrl;@JsonKey(name: 'customCoverUrl') String? get customCoverUrl;@JsonKey(name: 'intro') String? get intro;@JsonKey(name: 'customIntro') String? get customIntro;@JsonKey(name: 'remark') String? get remark;@JsonKey(name: 'charset') String? get charset;@JsonKey(name: 'type') int get type;@JsonKey(name: 'group') int get group;@JsonKey(name: 'latestChapterTitle') String? get latestChapterTitle;@JsonKey(name: 'latestChapterTime') int get latestChapterTime;@JsonKey(name: 'lastCheckTime') int get lastCheckTime;@JsonKey(name: 'lastCheckCount') int get lastCheckCount;@JsonKey(name: 'totalChapterNum') int get totalChapterNum;@JsonKey(name: 'durChapterTitle') String? get durChapterTitle;@JsonKey(name: 'durChapterIndex') int get durChapterIndex;@JsonKey(name: 'durChapterPos') int get durChapterPos;@JsonKey(name: 'durChapterTime') int get durChapterTime;@JsonKey(name: 'wordCount') String? get wordCount;@JsonKey(name: 'canUpdate') bool get canUpdate;@JsonKey(name: 'order') int get order;@JsonKey(name: 'originOrder') int get originOrder;@JsonKey(name: 'variable') String? get variable;@JsonKey(name: 'readConfig') String? get readConfig;@JsonKey(name: 'syncTime') int get syncTime;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.bookUrl, bookUrl) || other.bookUrl == bookUrl)&&(identical(other.tocUrl, tocUrl) || other.tocUrl == tocUrl)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.originName, originName) || other.originName == originName)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.customTag, customTag) || other.customTag == customTag)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.customCoverUrl, customCoverUrl) || other.customCoverUrl == customCoverUrl)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.customIntro, customIntro) || other.customIntro == customIntro)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.charset, charset) || other.charset == charset)&&(identical(other.type, type) || other.type == type)&&(identical(other.group, group) || other.group == group)&&(identical(other.latestChapterTitle, latestChapterTitle) || other.latestChapterTitle == latestChapterTitle)&&(identical(other.latestChapterTime, latestChapterTime) || other.latestChapterTime == latestChapterTime)&&(identical(other.lastCheckTime, lastCheckTime) || other.lastCheckTime == lastCheckTime)&&(identical(other.lastCheckCount, lastCheckCount) || other.lastCheckCount == lastCheckCount)&&(identical(other.totalChapterNum, totalChapterNum) || other.totalChapterNum == totalChapterNum)&&(identical(other.durChapterTitle, durChapterTitle) || other.durChapterTitle == durChapterTitle)&&(identical(other.durChapterIndex, durChapterIndex) || other.durChapterIndex == durChapterIndex)&&(identical(other.durChapterPos, durChapterPos) || other.durChapterPos == durChapterPos)&&(identical(other.durChapterTime, durChapterTime) || other.durChapterTime == durChapterTime)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.canUpdate, canUpdate) || other.canUpdate == canUpdate)&&(identical(other.order, order) || other.order == order)&&(identical(other.originOrder, originOrder) || other.originOrder == originOrder)&&(identical(other.variable, variable) || other.variable == variable)&&(identical(other.readConfig, readConfig) || other.readConfig == readConfig)&&(identical(other.syncTime, syncTime) || other.syncTime == syncTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,bookUrl,tocUrl,origin,originName,name,author,kind,customTag,coverUrl,customCoverUrl,intro,customIntro,remark,charset,type,group,latestChapterTitle,latestChapterTime,lastCheckTime,lastCheckCount,totalChapterNum,durChapterTitle,durChapterIndex,durChapterPos,durChapterTime,wordCount,canUpdate,order,originOrder,variable,readConfig,syncTime]);

@override
String toString() {
  return 'Book(bookUrl: $bookUrl, tocUrl: $tocUrl, origin: $origin, originName: $originName, name: $name, author: $author, kind: $kind, customTag: $customTag, coverUrl: $coverUrl, customCoverUrl: $customCoverUrl, intro: $intro, customIntro: $customIntro, remark: $remark, charset: $charset, type: $type, group: $group, latestChapterTitle: $latestChapterTitle, latestChapterTime: $latestChapterTime, lastCheckTime: $lastCheckTime, lastCheckCount: $lastCheckCount, totalChapterNum: $totalChapterNum, durChapterTitle: $durChapterTitle, durChapterIndex: $durChapterIndex, durChapterPos: $durChapterPos, durChapterTime: $durChapterTime, wordCount: $wordCount, canUpdate: $canUpdate, order: $order, originOrder: $originOrder, variable: $variable, readConfig: $readConfig, syncTime: $syncTime)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bookUrl') String bookUrl,@JsonKey(name: 'tocUrl') String tocUrl,@JsonKey(name: 'origin') String origin,@JsonKey(name: 'originName') String originName,@JsonKey(name: 'name') String name,@JsonKey(name: 'author') String author,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'customTag') String? customTag,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'customCoverUrl') String? customCoverUrl,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'customIntro') String? customIntro,@JsonKey(name: 'remark') String? remark,@JsonKey(name: 'charset') String? charset,@JsonKey(name: 'type') int type,@JsonKey(name: 'group') int group,@JsonKey(name: 'latestChapterTitle') String? latestChapterTitle,@JsonKey(name: 'latestChapterTime') int latestChapterTime,@JsonKey(name: 'lastCheckTime') int lastCheckTime,@JsonKey(name: 'lastCheckCount') int lastCheckCount,@JsonKey(name: 'totalChapterNum') int totalChapterNum,@JsonKey(name: 'durChapterTitle') String? durChapterTitle,@JsonKey(name: 'durChapterIndex') int durChapterIndex,@JsonKey(name: 'durChapterPos') int durChapterPos,@JsonKey(name: 'durChapterTime') int durChapterTime,@JsonKey(name: 'wordCount') String? wordCount,@JsonKey(name: 'canUpdate') bool canUpdate,@JsonKey(name: 'order') int order,@JsonKey(name: 'originOrder') int originOrder,@JsonKey(name: 'variable') String? variable,@JsonKey(name: 'readConfig') String? readConfig,@JsonKey(name: 'syncTime') int syncTime
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookUrl = null,Object? tocUrl = null,Object? origin = null,Object? originName = null,Object? name = null,Object? author = null,Object? kind = freezed,Object? customTag = freezed,Object? coverUrl = freezed,Object? customCoverUrl = freezed,Object? intro = freezed,Object? customIntro = freezed,Object? remark = freezed,Object? charset = freezed,Object? type = null,Object? group = null,Object? latestChapterTitle = freezed,Object? latestChapterTime = null,Object? lastCheckTime = null,Object? lastCheckCount = null,Object? totalChapterNum = null,Object? durChapterTitle = freezed,Object? durChapterIndex = null,Object? durChapterPos = null,Object? durChapterTime = null,Object? wordCount = freezed,Object? canUpdate = null,Object? order = null,Object? originOrder = null,Object? variable = freezed,Object? readConfig = freezed,Object? syncTime = null,}) {
  return _then(_self.copyWith(
bookUrl: null == bookUrl ? _self.bookUrl : bookUrl // ignore: cast_nullable_to_non_nullable
as String,tocUrl: null == tocUrl ? _self.tocUrl : tocUrl // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,originName: null == originName ? _self.originName : originName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,customTag: freezed == customTag ? _self.customTag : customTag // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,customCoverUrl: freezed == customCoverUrl ? _self.customCoverUrl : customCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,customIntro: freezed == customIntro ? _self.customIntro : customIntro // ignore: cast_nullable_to_non_nullable
as String?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,charset: freezed == charset ? _self.charset : charset // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as int,latestChapterTitle: freezed == latestChapterTitle ? _self.latestChapterTitle : latestChapterTitle // ignore: cast_nullable_to_non_nullable
as String?,latestChapterTime: null == latestChapterTime ? _self.latestChapterTime : latestChapterTime // ignore: cast_nullable_to_non_nullable
as int,lastCheckTime: null == lastCheckTime ? _self.lastCheckTime : lastCheckTime // ignore: cast_nullable_to_non_nullable
as int,lastCheckCount: null == lastCheckCount ? _self.lastCheckCount : lastCheckCount // ignore: cast_nullable_to_non_nullable
as int,totalChapterNum: null == totalChapterNum ? _self.totalChapterNum : totalChapterNum // ignore: cast_nullable_to_non_nullable
as int,durChapterTitle: freezed == durChapterTitle ? _self.durChapterTitle : durChapterTitle // ignore: cast_nullable_to_non_nullable
as String?,durChapterIndex: null == durChapterIndex ? _self.durChapterIndex : durChapterIndex // ignore: cast_nullable_to_non_nullable
as int,durChapterPos: null == durChapterPos ? _self.durChapterPos : durChapterPos // ignore: cast_nullable_to_non_nullable
as int,durChapterTime: null == durChapterTime ? _self.durChapterTime : durChapterTime // ignore: cast_nullable_to_non_nullable
as int,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,canUpdate: null == canUpdate ? _self.canUpdate : canUpdate // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,originOrder: null == originOrder ? _self.originOrder : originOrder // ignore: cast_nullable_to_non_nullable
as int,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as String?,readConfig: freezed == readConfig ? _self.readConfig : readConfig // ignore: cast_nullable_to_non_nullable
as String?,syncTime: null == syncTime ? _self.syncTime : syncTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookUrl')  String bookUrl, @JsonKey(name: 'tocUrl')  String tocUrl, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'originName')  String originName, @JsonKey(name: 'name')  String name, @JsonKey(name: 'author')  String author, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'customTag')  String? customTag, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'customCoverUrl')  String? customCoverUrl, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'customIntro')  String? customIntro, @JsonKey(name: 'remark')  String? remark, @JsonKey(name: 'charset')  String? charset, @JsonKey(name: 'type')  int type, @JsonKey(name: 'group')  int group, @JsonKey(name: 'latestChapterTitle')  String? latestChapterTitle, @JsonKey(name: 'latestChapterTime')  int latestChapterTime, @JsonKey(name: 'lastCheckTime')  int lastCheckTime, @JsonKey(name: 'lastCheckCount')  int lastCheckCount, @JsonKey(name: 'totalChapterNum')  int totalChapterNum, @JsonKey(name: 'durChapterTitle')  String? durChapterTitle, @JsonKey(name: 'durChapterIndex')  int durChapterIndex, @JsonKey(name: 'durChapterPos')  int durChapterPos, @JsonKey(name: 'durChapterTime')  int durChapterTime, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'canUpdate')  bool canUpdate, @JsonKey(name: 'order')  int order, @JsonKey(name: 'originOrder')  int originOrder, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'readConfig')  String? readConfig, @JsonKey(name: 'syncTime')  int syncTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.bookUrl,_that.tocUrl,_that.origin,_that.originName,_that.name,_that.author,_that.kind,_that.customTag,_that.coverUrl,_that.customCoverUrl,_that.intro,_that.customIntro,_that.remark,_that.charset,_that.type,_that.group,_that.latestChapterTitle,_that.latestChapterTime,_that.lastCheckTime,_that.lastCheckCount,_that.totalChapterNum,_that.durChapterTitle,_that.durChapterIndex,_that.durChapterPos,_that.durChapterTime,_that.wordCount,_that.canUpdate,_that.order,_that.originOrder,_that.variable,_that.readConfig,_that.syncTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookUrl')  String bookUrl, @JsonKey(name: 'tocUrl')  String tocUrl, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'originName')  String originName, @JsonKey(name: 'name')  String name, @JsonKey(name: 'author')  String author, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'customTag')  String? customTag, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'customCoverUrl')  String? customCoverUrl, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'customIntro')  String? customIntro, @JsonKey(name: 'remark')  String? remark, @JsonKey(name: 'charset')  String? charset, @JsonKey(name: 'type')  int type, @JsonKey(name: 'group')  int group, @JsonKey(name: 'latestChapterTitle')  String? latestChapterTitle, @JsonKey(name: 'latestChapterTime')  int latestChapterTime, @JsonKey(name: 'lastCheckTime')  int lastCheckTime, @JsonKey(name: 'lastCheckCount')  int lastCheckCount, @JsonKey(name: 'totalChapterNum')  int totalChapterNum, @JsonKey(name: 'durChapterTitle')  String? durChapterTitle, @JsonKey(name: 'durChapterIndex')  int durChapterIndex, @JsonKey(name: 'durChapterPos')  int durChapterPos, @JsonKey(name: 'durChapterTime')  int durChapterTime, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'canUpdate')  bool canUpdate, @JsonKey(name: 'order')  int order, @JsonKey(name: 'originOrder')  int originOrder, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'readConfig')  String? readConfig, @JsonKey(name: 'syncTime')  int syncTime)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.bookUrl,_that.tocUrl,_that.origin,_that.originName,_that.name,_that.author,_that.kind,_that.customTag,_that.coverUrl,_that.customCoverUrl,_that.intro,_that.customIntro,_that.remark,_that.charset,_that.type,_that.group,_that.latestChapterTitle,_that.latestChapterTime,_that.lastCheckTime,_that.lastCheckCount,_that.totalChapterNum,_that.durChapterTitle,_that.durChapterIndex,_that.durChapterPos,_that.durChapterTime,_that.wordCount,_that.canUpdate,_that.order,_that.originOrder,_that.variable,_that.readConfig,_that.syncTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bookUrl')  String bookUrl, @JsonKey(name: 'tocUrl')  String tocUrl, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'originName')  String originName, @JsonKey(name: 'name')  String name, @JsonKey(name: 'author')  String author, @JsonKey(name: 'kind')  String? kind, @JsonKey(name: 'customTag')  String? customTag, @JsonKey(name: 'coverUrl')  String? coverUrl, @JsonKey(name: 'customCoverUrl')  String? customCoverUrl, @JsonKey(name: 'intro')  String? intro, @JsonKey(name: 'customIntro')  String? customIntro, @JsonKey(name: 'remark')  String? remark, @JsonKey(name: 'charset')  String? charset, @JsonKey(name: 'type')  int type, @JsonKey(name: 'group')  int group, @JsonKey(name: 'latestChapterTitle')  String? latestChapterTitle, @JsonKey(name: 'latestChapterTime')  int latestChapterTime, @JsonKey(name: 'lastCheckTime')  int lastCheckTime, @JsonKey(name: 'lastCheckCount')  int lastCheckCount, @JsonKey(name: 'totalChapterNum')  int totalChapterNum, @JsonKey(name: 'durChapterTitle')  String? durChapterTitle, @JsonKey(name: 'durChapterIndex')  int durChapterIndex, @JsonKey(name: 'durChapterPos')  int durChapterPos, @JsonKey(name: 'durChapterTime')  int durChapterTime, @JsonKey(name: 'wordCount')  String? wordCount, @JsonKey(name: 'canUpdate')  bool canUpdate, @JsonKey(name: 'order')  int order, @JsonKey(name: 'originOrder')  int originOrder, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'readConfig')  String? readConfig, @JsonKey(name: 'syncTime')  int syncTime)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.bookUrl,_that.tocUrl,_that.origin,_that.originName,_that.name,_that.author,_that.kind,_that.customTag,_that.coverUrl,_that.customCoverUrl,_that.intro,_that.customIntro,_that.remark,_that.charset,_that.type,_that.group,_that.latestChapterTitle,_that.latestChapterTime,_that.lastCheckTime,_that.lastCheckCount,_that.totalChapterNum,_that.durChapterTitle,_that.durChapterIndex,_that.durChapterPos,_that.durChapterTime,_that.wordCount,_that.canUpdate,_that.order,_that.originOrder,_that.variable,_that.readConfig,_that.syncTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Book implements Book {
  const _Book({@JsonKey(name: 'bookUrl') required this.bookUrl, @JsonKey(name: 'tocUrl') required this.tocUrl, @JsonKey(name: 'origin') this.origin = 'loc_book', @JsonKey(name: 'originName') required this.originName, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'author') required this.author, @JsonKey(name: 'kind') this.kind, @JsonKey(name: 'customTag') this.customTag, @JsonKey(name: 'coverUrl') this.coverUrl, @JsonKey(name: 'customCoverUrl') this.customCoverUrl, @JsonKey(name: 'intro') this.intro, @JsonKey(name: 'customIntro') this.customIntro, @JsonKey(name: 'remark') this.remark, @JsonKey(name: 'charset') this.charset, @JsonKey(name: 'type') this.type = 8, @JsonKey(name: 'group') this.group = 0, @JsonKey(name: 'latestChapterTitle') this.latestChapterTitle, @JsonKey(name: 'latestChapterTime') this.latestChapterTime = 0, @JsonKey(name: 'lastCheckTime') this.lastCheckTime = 0, @JsonKey(name: 'lastCheckCount') this.lastCheckCount = 0, @JsonKey(name: 'totalChapterNum') this.totalChapterNum = 0, @JsonKey(name: 'durChapterTitle') this.durChapterTitle, @JsonKey(name: 'durChapterIndex') this.durChapterIndex = 0, @JsonKey(name: 'durChapterPos') this.durChapterPos = 0, @JsonKey(name: 'durChapterTime') this.durChapterTime = 0, @JsonKey(name: 'wordCount') this.wordCount, @JsonKey(name: 'canUpdate') this.canUpdate = true, @JsonKey(name: 'order') this.order = 0, @JsonKey(name: 'originOrder') this.originOrder = 0, @JsonKey(name: 'variable') this.variable, @JsonKey(name: 'readConfig') this.readConfig, @JsonKey(name: 'syncTime') this.syncTime = 0});
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

@override@JsonKey(name: 'bookUrl') final  String bookUrl;
@override@JsonKey(name: 'tocUrl') final  String tocUrl;
@override@JsonKey(name: 'origin') final  String origin;
@override@JsonKey(name: 'originName') final  String originName;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'author') final  String author;
@override@JsonKey(name: 'kind') final  String? kind;
@override@JsonKey(name: 'customTag') final  String? customTag;
@override@JsonKey(name: 'coverUrl') final  String? coverUrl;
@override@JsonKey(name: 'customCoverUrl') final  String? customCoverUrl;
@override@JsonKey(name: 'intro') final  String? intro;
@override@JsonKey(name: 'customIntro') final  String? customIntro;
@override@JsonKey(name: 'remark') final  String? remark;
@override@JsonKey(name: 'charset') final  String? charset;
@override@JsonKey(name: 'type') final  int type;
@override@JsonKey(name: 'group') final  int group;
@override@JsonKey(name: 'latestChapterTitle') final  String? latestChapterTitle;
@override@JsonKey(name: 'latestChapterTime') final  int latestChapterTime;
@override@JsonKey(name: 'lastCheckTime') final  int lastCheckTime;
@override@JsonKey(name: 'lastCheckCount') final  int lastCheckCount;
@override@JsonKey(name: 'totalChapterNum') final  int totalChapterNum;
@override@JsonKey(name: 'durChapterTitle') final  String? durChapterTitle;
@override@JsonKey(name: 'durChapterIndex') final  int durChapterIndex;
@override@JsonKey(name: 'durChapterPos') final  int durChapterPos;
@override@JsonKey(name: 'durChapterTime') final  int durChapterTime;
@override@JsonKey(name: 'wordCount') final  String? wordCount;
@override@JsonKey(name: 'canUpdate') final  bool canUpdate;
@override@JsonKey(name: 'order') final  int order;
@override@JsonKey(name: 'originOrder') final  int originOrder;
@override@JsonKey(name: 'variable') final  String? variable;
@override@JsonKey(name: 'readConfig') final  String? readConfig;
@override@JsonKey(name: 'syncTime') final  int syncTime;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.bookUrl, bookUrl) || other.bookUrl == bookUrl)&&(identical(other.tocUrl, tocUrl) || other.tocUrl == tocUrl)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.originName, originName) || other.originName == originName)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.customTag, customTag) || other.customTag == customTag)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.customCoverUrl, customCoverUrl) || other.customCoverUrl == customCoverUrl)&&(identical(other.intro, intro) || other.intro == intro)&&(identical(other.customIntro, customIntro) || other.customIntro == customIntro)&&(identical(other.remark, remark) || other.remark == remark)&&(identical(other.charset, charset) || other.charset == charset)&&(identical(other.type, type) || other.type == type)&&(identical(other.group, group) || other.group == group)&&(identical(other.latestChapterTitle, latestChapterTitle) || other.latestChapterTitle == latestChapterTitle)&&(identical(other.latestChapterTime, latestChapterTime) || other.latestChapterTime == latestChapterTime)&&(identical(other.lastCheckTime, lastCheckTime) || other.lastCheckTime == lastCheckTime)&&(identical(other.lastCheckCount, lastCheckCount) || other.lastCheckCount == lastCheckCount)&&(identical(other.totalChapterNum, totalChapterNum) || other.totalChapterNum == totalChapterNum)&&(identical(other.durChapterTitle, durChapterTitle) || other.durChapterTitle == durChapterTitle)&&(identical(other.durChapterIndex, durChapterIndex) || other.durChapterIndex == durChapterIndex)&&(identical(other.durChapterPos, durChapterPos) || other.durChapterPos == durChapterPos)&&(identical(other.durChapterTime, durChapterTime) || other.durChapterTime == durChapterTime)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&(identical(other.canUpdate, canUpdate) || other.canUpdate == canUpdate)&&(identical(other.order, order) || other.order == order)&&(identical(other.originOrder, originOrder) || other.originOrder == originOrder)&&(identical(other.variable, variable) || other.variable == variable)&&(identical(other.readConfig, readConfig) || other.readConfig == readConfig)&&(identical(other.syncTime, syncTime) || other.syncTime == syncTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,bookUrl,tocUrl,origin,originName,name,author,kind,customTag,coverUrl,customCoverUrl,intro,customIntro,remark,charset,type,group,latestChapterTitle,latestChapterTime,lastCheckTime,lastCheckCount,totalChapterNum,durChapterTitle,durChapterIndex,durChapterPos,durChapterTime,wordCount,canUpdate,order,originOrder,variable,readConfig,syncTime]);

@override
String toString() {
  return 'Book(bookUrl: $bookUrl, tocUrl: $tocUrl, origin: $origin, originName: $originName, name: $name, author: $author, kind: $kind, customTag: $customTag, coverUrl: $coverUrl, customCoverUrl: $customCoverUrl, intro: $intro, customIntro: $customIntro, remark: $remark, charset: $charset, type: $type, group: $group, latestChapterTitle: $latestChapterTitle, latestChapterTime: $latestChapterTime, lastCheckTime: $lastCheckTime, lastCheckCount: $lastCheckCount, totalChapterNum: $totalChapterNum, durChapterTitle: $durChapterTitle, durChapterIndex: $durChapterIndex, durChapterPos: $durChapterPos, durChapterTime: $durChapterTime, wordCount: $wordCount, canUpdate: $canUpdate, order: $order, originOrder: $originOrder, variable: $variable, readConfig: $readConfig, syncTime: $syncTime)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bookUrl') String bookUrl,@JsonKey(name: 'tocUrl') String tocUrl,@JsonKey(name: 'origin') String origin,@JsonKey(name: 'originName') String originName,@JsonKey(name: 'name') String name,@JsonKey(name: 'author') String author,@JsonKey(name: 'kind') String? kind,@JsonKey(name: 'customTag') String? customTag,@JsonKey(name: 'coverUrl') String? coverUrl,@JsonKey(name: 'customCoverUrl') String? customCoverUrl,@JsonKey(name: 'intro') String? intro,@JsonKey(name: 'customIntro') String? customIntro,@JsonKey(name: 'remark') String? remark,@JsonKey(name: 'charset') String? charset,@JsonKey(name: 'type') int type,@JsonKey(name: 'group') int group,@JsonKey(name: 'latestChapterTitle') String? latestChapterTitle,@JsonKey(name: 'latestChapterTime') int latestChapterTime,@JsonKey(name: 'lastCheckTime') int lastCheckTime,@JsonKey(name: 'lastCheckCount') int lastCheckCount,@JsonKey(name: 'totalChapterNum') int totalChapterNum,@JsonKey(name: 'durChapterTitle') String? durChapterTitle,@JsonKey(name: 'durChapterIndex') int durChapterIndex,@JsonKey(name: 'durChapterPos') int durChapterPos,@JsonKey(name: 'durChapterTime') int durChapterTime,@JsonKey(name: 'wordCount') String? wordCount,@JsonKey(name: 'canUpdate') bool canUpdate,@JsonKey(name: 'order') int order,@JsonKey(name: 'originOrder') int originOrder,@JsonKey(name: 'variable') String? variable,@JsonKey(name: 'readConfig') String? readConfig,@JsonKey(name: 'syncTime') int syncTime
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookUrl = null,Object? tocUrl = null,Object? origin = null,Object? originName = null,Object? name = null,Object? author = null,Object? kind = freezed,Object? customTag = freezed,Object? coverUrl = freezed,Object? customCoverUrl = freezed,Object? intro = freezed,Object? customIntro = freezed,Object? remark = freezed,Object? charset = freezed,Object? type = null,Object? group = null,Object? latestChapterTitle = freezed,Object? latestChapterTime = null,Object? lastCheckTime = null,Object? lastCheckCount = null,Object? totalChapterNum = null,Object? durChapterTitle = freezed,Object? durChapterIndex = null,Object? durChapterPos = null,Object? durChapterTime = null,Object? wordCount = freezed,Object? canUpdate = null,Object? order = null,Object? originOrder = null,Object? variable = freezed,Object? readConfig = freezed,Object? syncTime = null,}) {
  return _then(_Book(
bookUrl: null == bookUrl ? _self.bookUrl : bookUrl // ignore: cast_nullable_to_non_nullable
as String,tocUrl: null == tocUrl ? _self.tocUrl : tocUrl // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,originName: null == originName ? _self.originName : originName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,customTag: freezed == customTag ? _self.customTag : customTag // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,customCoverUrl: freezed == customCoverUrl ? _self.customCoverUrl : customCoverUrl // ignore: cast_nullable_to_non_nullable
as String?,intro: freezed == intro ? _self.intro : intro // ignore: cast_nullable_to_non_nullable
as String?,customIntro: freezed == customIntro ? _self.customIntro : customIntro // ignore: cast_nullable_to_non_nullable
as String?,remark: freezed == remark ? _self.remark : remark // ignore: cast_nullable_to_non_nullable
as String?,charset: freezed == charset ? _self.charset : charset // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as int,latestChapterTitle: freezed == latestChapterTitle ? _self.latestChapterTitle : latestChapterTitle // ignore: cast_nullable_to_non_nullable
as String?,latestChapterTime: null == latestChapterTime ? _self.latestChapterTime : latestChapterTime // ignore: cast_nullable_to_non_nullable
as int,lastCheckTime: null == lastCheckTime ? _self.lastCheckTime : lastCheckTime // ignore: cast_nullable_to_non_nullable
as int,lastCheckCount: null == lastCheckCount ? _self.lastCheckCount : lastCheckCount // ignore: cast_nullable_to_non_nullable
as int,totalChapterNum: null == totalChapterNum ? _self.totalChapterNum : totalChapterNum // ignore: cast_nullable_to_non_nullable
as int,durChapterTitle: freezed == durChapterTitle ? _self.durChapterTitle : durChapterTitle // ignore: cast_nullable_to_non_nullable
as String?,durChapterIndex: null == durChapterIndex ? _self.durChapterIndex : durChapterIndex // ignore: cast_nullable_to_non_nullable
as int,durChapterPos: null == durChapterPos ? _self.durChapterPos : durChapterPos // ignore: cast_nullable_to_non_nullable
as int,durChapterTime: null == durChapterTime ? _self.durChapterTime : durChapterTime // ignore: cast_nullable_to_non_nullable
as int,wordCount: freezed == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as String?,canUpdate: null == canUpdate ? _self.canUpdate : canUpdate // ignore: cast_nullable_to_non_nullable
as bool,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,originOrder: null == originOrder ? _self.originOrder : originOrder // ignore: cast_nullable_to_non_nullable
as int,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as String?,readConfig: freezed == readConfig ? _self.readConfig : readConfig // ignore: cast_nullable_to_non_nullable
as String?,syncTime: null == syncTime ? _self.syncTime : syncTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
