// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rss_star.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RssStar {

@JsonKey(name: 'origin') String get origin;@JsonKey(name: 'sort') String get sort;@JsonKey(name: 'title') String get title;@JsonKey(name: 'starTime') int get starTime;@JsonKey(name: 'link') String get link;@JsonKey(name: 'pubDate') String? get pubDate;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'content') String? get content;@JsonKey(name: 'image') String? get image;@JsonKey(name: 'group') String get group;@JsonKey(name: 'variable') String? get variable;@JsonKey(name: 'type') int get type;@JsonKey(name: 'durPos') int get durPos;
/// Create a copy of RssStar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RssStarCopyWith<RssStar> get copyWith => _$RssStarCopyWithImpl<RssStar>(this as RssStar, _$identity);

  /// Serializes this RssStar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RssStar&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.title, title) || other.title == title)&&(identical(other.starTime, starTime) || other.starTime == starTime)&&(identical(other.link, link) || other.link == link)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.group, group) || other.group == group)&&(identical(other.variable, variable) || other.variable == variable)&&(identical(other.type, type) || other.type == type)&&(identical(other.durPos, durPos) || other.durPos == durPos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,origin,sort,title,starTime,link,pubDate,description,content,image,group,variable,type,durPos);

@override
String toString() {
  return 'RssStar(origin: $origin, sort: $sort, title: $title, starTime: $starTime, link: $link, pubDate: $pubDate, description: $description, content: $content, image: $image, group: $group, variable: $variable, type: $type, durPos: $durPos)';
}


}

/// @nodoc
abstract mixin class $RssStarCopyWith<$Res>  {
  factory $RssStarCopyWith(RssStar value, $Res Function(RssStar) _then) = _$RssStarCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'origin') String origin,@JsonKey(name: 'sort') String sort,@JsonKey(name: 'title') String title,@JsonKey(name: 'starTime') int starTime,@JsonKey(name: 'link') String link,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'description') String? description,@JsonKey(name: 'content') String? content,@JsonKey(name: 'image') String? image,@JsonKey(name: 'group') String group,@JsonKey(name: 'variable') String? variable,@JsonKey(name: 'type') int type,@JsonKey(name: 'durPos') int durPos
});




}
/// @nodoc
class _$RssStarCopyWithImpl<$Res>
    implements $RssStarCopyWith<$Res> {
  _$RssStarCopyWithImpl(this._self, this._then);

  final RssStar _self;
  final $Res Function(RssStar) _then;

/// Create a copy of RssStar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? origin = null,Object? sort = null,Object? title = null,Object? starTime = null,Object? link = null,Object? pubDate = freezed,Object? description = freezed,Object? content = freezed,Object? image = freezed,Object? group = null,Object? variable = freezed,Object? type = null,Object? durPos = null,}) {
  return _then(_self.copyWith(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,starTime: null == starTime ? _self.starTime : starTime // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,durPos: null == durPos ? _self.durPos : durPos // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RssStar].
extension RssStarPatterns on RssStar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RssStar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RssStar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RssStar value)  $default,){
final _that = this;
switch (_that) {
case _RssStar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RssStar value)?  $default,){
final _that = this;
switch (_that) {
case _RssStar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'origin')  String origin, @JsonKey(name: 'sort')  String sort, @JsonKey(name: 'title')  String title, @JsonKey(name: 'starTime')  int starTime, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'content')  String? content, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'group')  String group, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'type')  int type, @JsonKey(name: 'durPos')  int durPos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RssStar() when $default != null:
return $default(_that.origin,_that.sort,_that.title,_that.starTime,_that.link,_that.pubDate,_that.description,_that.content,_that.image,_that.group,_that.variable,_that.type,_that.durPos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'origin')  String origin, @JsonKey(name: 'sort')  String sort, @JsonKey(name: 'title')  String title, @JsonKey(name: 'starTime')  int starTime, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'content')  String? content, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'group')  String group, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'type')  int type, @JsonKey(name: 'durPos')  int durPos)  $default,) {final _that = this;
switch (_that) {
case _RssStar():
return $default(_that.origin,_that.sort,_that.title,_that.starTime,_that.link,_that.pubDate,_that.description,_that.content,_that.image,_that.group,_that.variable,_that.type,_that.durPos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'origin')  String origin, @JsonKey(name: 'sort')  String sort, @JsonKey(name: 'title')  String title, @JsonKey(name: 'starTime')  int starTime, @JsonKey(name: 'link')  String link, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'content')  String? content, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'group')  String group, @JsonKey(name: 'variable')  String? variable, @JsonKey(name: 'type')  int type, @JsonKey(name: 'durPos')  int durPos)?  $default,) {final _that = this;
switch (_that) {
case _RssStar() when $default != null:
return $default(_that.origin,_that.sort,_that.title,_that.starTime,_that.link,_that.pubDate,_that.description,_that.content,_that.image,_that.group,_that.variable,_that.type,_that.durPos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RssStar implements RssStar {
  const _RssStar({@JsonKey(name: 'origin') required this.origin, @JsonKey(name: 'sort') required this.sort, @JsonKey(name: 'title') required this.title, @JsonKey(name: 'starTime') this.starTime = 0, @JsonKey(name: 'link') required this.link, @JsonKey(name: 'pubDate') this.pubDate, @JsonKey(name: 'description') this.description, @JsonKey(name: 'content') this.content, @JsonKey(name: 'image') this.image, @JsonKey(name: 'group') this.group = '默认分组', @JsonKey(name: 'variable') this.variable, @JsonKey(name: 'type') this.type = 0, @JsonKey(name: 'durPos') this.durPos = 0});
  factory _RssStar.fromJson(Map<String, dynamic> json) => _$RssStarFromJson(json);

@override@JsonKey(name: 'origin') final  String origin;
@override@JsonKey(name: 'sort') final  String sort;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'starTime') final  int starTime;
@override@JsonKey(name: 'link') final  String link;
@override@JsonKey(name: 'pubDate') final  String? pubDate;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'content') final  String? content;
@override@JsonKey(name: 'image') final  String? image;
@override@JsonKey(name: 'group') final  String group;
@override@JsonKey(name: 'variable') final  String? variable;
@override@JsonKey(name: 'type') final  int type;
@override@JsonKey(name: 'durPos') final  int durPos;

/// Create a copy of RssStar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RssStarCopyWith<_RssStar> get copyWith => __$RssStarCopyWithImpl<_RssStar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RssStarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RssStar&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.title, title) || other.title == title)&&(identical(other.starTime, starTime) || other.starTime == starTime)&&(identical(other.link, link) || other.link == link)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.group, group) || other.group == group)&&(identical(other.variable, variable) || other.variable == variable)&&(identical(other.type, type) || other.type == type)&&(identical(other.durPos, durPos) || other.durPos == durPos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,origin,sort,title,starTime,link,pubDate,description,content,image,group,variable,type,durPos);

@override
String toString() {
  return 'RssStar(origin: $origin, sort: $sort, title: $title, starTime: $starTime, link: $link, pubDate: $pubDate, description: $description, content: $content, image: $image, group: $group, variable: $variable, type: $type, durPos: $durPos)';
}


}

/// @nodoc
abstract mixin class _$RssStarCopyWith<$Res> implements $RssStarCopyWith<$Res> {
  factory _$RssStarCopyWith(_RssStar value, $Res Function(_RssStar) _then) = __$RssStarCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'origin') String origin,@JsonKey(name: 'sort') String sort,@JsonKey(name: 'title') String title,@JsonKey(name: 'starTime') int starTime,@JsonKey(name: 'link') String link,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'description') String? description,@JsonKey(name: 'content') String? content,@JsonKey(name: 'image') String? image,@JsonKey(name: 'group') String group,@JsonKey(name: 'variable') String? variable,@JsonKey(name: 'type') int type,@JsonKey(name: 'durPos') int durPos
});




}
/// @nodoc
class __$RssStarCopyWithImpl<$Res>
    implements _$RssStarCopyWith<$Res> {
  __$RssStarCopyWithImpl(this._self, this._then);

  final _RssStar _self;
  final $Res Function(_RssStar) _then;

/// Create a copy of RssStar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? origin = null,Object? sort = null,Object? title = null,Object? starTime = null,Object? link = null,Object? pubDate = freezed,Object? description = freezed,Object? content = freezed,Object? image = freezed,Object? group = null,Object? variable = freezed,Object? type = null,Object? durPos = null,}) {
  return _then(_RssStar(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,starTime: null == starTime ? _self.starTime : starTime // ignore: cast_nullable_to_non_nullable
as int,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,variable: freezed == variable ? _self.variable : variable // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,durPos: null == durPos ? _self.durPos : durPos // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
