// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rss_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RssSource {

@JsonKey(name: 'sourceUrl') String get sourceUrl;@JsonKey(name: 'sourceName') String get sourceName;@JsonKey(name: 'sourceIcon') String get sourceIcon;@JsonKey(name: 'sourceGroup') String? get sourceGroup;@JsonKey(name: 'sourceComment') String? get sourceComment;@JsonKey(name: 'enabled') bool get enabled;@JsonKey(name: 'jsLib') String? get jsLib;@JsonKey(name: 'header') Map<String, String>? get header;// 规则字段
@JsonKey(name: 'ruleArticles') String? get ruleArticles;@JsonKey(name: 'ruleTitle') String? get ruleTitle;@JsonKey(name: 'ruleLink') String? get ruleLink;@JsonKey(name: 'rulePubDate') String? get rulePubDate;@JsonKey(name: 'ruleDescription') String? get ruleDescription;@JsonKey(name: 'ruleImage') String? get ruleImage;@JsonKey(name: 'ruleContent') String? get ruleContent;@JsonKey(name: 'type') int get type;@JsonKey(name: 'sortUrl') String? get sortUrl;@JsonKey(name: 'articleStyle') int get articleStyle;
/// Create a copy of RssSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RssSourceCopyWith<RssSource> get copyWith => _$RssSourceCopyWithImpl<RssSource>(this as RssSource, _$identity);

  /// Serializes this RssSource to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RssSource&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceIcon, sourceIcon) || other.sourceIcon == sourceIcon)&&(identical(other.sourceGroup, sourceGroup) || other.sourceGroup == sourceGroup)&&(identical(other.sourceComment, sourceComment) || other.sourceComment == sourceComment)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.jsLib, jsLib) || other.jsLib == jsLib)&&const DeepCollectionEquality().equals(other.header, header)&&(identical(other.ruleArticles, ruleArticles) || other.ruleArticles == ruleArticles)&&(identical(other.ruleTitle, ruleTitle) || other.ruleTitle == ruleTitle)&&(identical(other.ruleLink, ruleLink) || other.ruleLink == ruleLink)&&(identical(other.rulePubDate, rulePubDate) || other.rulePubDate == rulePubDate)&&(identical(other.ruleDescription, ruleDescription) || other.ruleDescription == ruleDescription)&&(identical(other.ruleImage, ruleImage) || other.ruleImage == ruleImage)&&(identical(other.ruleContent, ruleContent) || other.ruleContent == ruleContent)&&(identical(other.type, type) || other.type == type)&&(identical(other.sortUrl, sortUrl) || other.sortUrl == sortUrl)&&(identical(other.articleStyle, articleStyle) || other.articleStyle == articleStyle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceUrl,sourceName,sourceIcon,sourceGroup,sourceComment,enabled,jsLib,const DeepCollectionEquality().hash(header),ruleArticles,ruleTitle,ruleLink,rulePubDate,ruleDescription,ruleImage,ruleContent,type,sortUrl,articleStyle);

@override
String toString() {
  return 'RssSource(sourceUrl: $sourceUrl, sourceName: $sourceName, sourceIcon: $sourceIcon, sourceGroup: $sourceGroup, sourceComment: $sourceComment, enabled: $enabled, jsLib: $jsLib, header: $header, ruleArticles: $ruleArticles, ruleTitle: $ruleTitle, ruleLink: $ruleLink, rulePubDate: $rulePubDate, ruleDescription: $ruleDescription, ruleImage: $ruleImage, ruleContent: $ruleContent, type: $type, sortUrl: $sortUrl, articleStyle: $articleStyle)';
}


}

/// @nodoc
abstract mixin class $RssSourceCopyWith<$Res>  {
  factory $RssSourceCopyWith(RssSource value, $Res Function(RssSource) _then) = _$RssSourceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'sourceUrl') String sourceUrl,@JsonKey(name: 'sourceName') String sourceName,@JsonKey(name: 'sourceIcon') String sourceIcon,@JsonKey(name: 'sourceGroup') String? sourceGroup,@JsonKey(name: 'sourceComment') String? sourceComment,@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'jsLib') String? jsLib,@JsonKey(name: 'header') Map<String, String>? header,@JsonKey(name: 'ruleArticles') String? ruleArticles,@JsonKey(name: 'ruleTitle') String? ruleTitle,@JsonKey(name: 'ruleLink') String? ruleLink,@JsonKey(name: 'rulePubDate') String? rulePubDate,@JsonKey(name: 'ruleDescription') String? ruleDescription,@JsonKey(name: 'ruleImage') String? ruleImage,@JsonKey(name: 'ruleContent') String? ruleContent,@JsonKey(name: 'type') int type,@JsonKey(name: 'sortUrl') String? sortUrl,@JsonKey(name: 'articleStyle') int articleStyle
});




}
/// @nodoc
class _$RssSourceCopyWithImpl<$Res>
    implements $RssSourceCopyWith<$Res> {
  _$RssSourceCopyWithImpl(this._self, this._then);

  final RssSource _self;
  final $Res Function(RssSource) _then;

/// Create a copy of RssSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceUrl = null,Object? sourceName = null,Object? sourceIcon = null,Object? sourceGroup = freezed,Object? sourceComment = freezed,Object? enabled = null,Object? jsLib = freezed,Object? header = freezed,Object? ruleArticles = freezed,Object? ruleTitle = freezed,Object? ruleLink = freezed,Object? rulePubDate = freezed,Object? ruleDescription = freezed,Object? ruleImage = freezed,Object? ruleContent = freezed,Object? type = null,Object? sortUrl = freezed,Object? articleStyle = null,}) {
  return _then(_self.copyWith(
sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceIcon: null == sourceIcon ? _self.sourceIcon : sourceIcon // ignore: cast_nullable_to_non_nullable
as String,sourceGroup: freezed == sourceGroup ? _self.sourceGroup : sourceGroup // ignore: cast_nullable_to_non_nullable
as String?,sourceComment: freezed == sourceComment ? _self.sourceComment : sourceComment // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,jsLib: freezed == jsLib ? _self.jsLib : jsLib // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self.header : header // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,ruleArticles: freezed == ruleArticles ? _self.ruleArticles : ruleArticles // ignore: cast_nullable_to_non_nullable
as String?,ruleTitle: freezed == ruleTitle ? _self.ruleTitle : ruleTitle // ignore: cast_nullable_to_non_nullable
as String?,ruleLink: freezed == ruleLink ? _self.ruleLink : ruleLink // ignore: cast_nullable_to_non_nullable
as String?,rulePubDate: freezed == rulePubDate ? _self.rulePubDate : rulePubDate // ignore: cast_nullable_to_non_nullable
as String?,ruleDescription: freezed == ruleDescription ? _self.ruleDescription : ruleDescription // ignore: cast_nullable_to_non_nullable
as String?,ruleImage: freezed == ruleImage ? _self.ruleImage : ruleImage // ignore: cast_nullable_to_non_nullable
as String?,ruleContent: freezed == ruleContent ? _self.ruleContent : ruleContent // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,sortUrl: freezed == sortUrl ? _self.sortUrl : sortUrl // ignore: cast_nullable_to_non_nullable
as String?,articleStyle: null == articleStyle ? _self.articleStyle : articleStyle // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RssSource].
extension RssSourcePatterns on RssSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RssSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RssSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RssSource value)  $default,){
final _that = this;
switch (_that) {
case _RssSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RssSource value)?  $default,){
final _that = this;
switch (_that) {
case _RssSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'sourceUrl')  String sourceUrl, @JsonKey(name: 'sourceName')  String sourceName, @JsonKey(name: 'sourceIcon')  String sourceIcon, @JsonKey(name: 'sourceGroup')  String? sourceGroup, @JsonKey(name: 'sourceComment')  String? sourceComment, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'jsLib')  String? jsLib, @JsonKey(name: 'header')  Map<String, String>? header, @JsonKey(name: 'ruleArticles')  String? ruleArticles, @JsonKey(name: 'ruleTitle')  String? ruleTitle, @JsonKey(name: 'ruleLink')  String? ruleLink, @JsonKey(name: 'rulePubDate')  String? rulePubDate, @JsonKey(name: 'ruleDescription')  String? ruleDescription, @JsonKey(name: 'ruleImage')  String? ruleImage, @JsonKey(name: 'ruleContent')  String? ruleContent, @JsonKey(name: 'type')  int type, @JsonKey(name: 'sortUrl')  String? sortUrl, @JsonKey(name: 'articleStyle')  int articleStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RssSource() when $default != null:
return $default(_that.sourceUrl,_that.sourceName,_that.sourceIcon,_that.sourceGroup,_that.sourceComment,_that.enabled,_that.jsLib,_that.header,_that.ruleArticles,_that.ruleTitle,_that.ruleLink,_that.rulePubDate,_that.ruleDescription,_that.ruleImage,_that.ruleContent,_that.type,_that.sortUrl,_that.articleStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'sourceUrl')  String sourceUrl, @JsonKey(name: 'sourceName')  String sourceName, @JsonKey(name: 'sourceIcon')  String sourceIcon, @JsonKey(name: 'sourceGroup')  String? sourceGroup, @JsonKey(name: 'sourceComment')  String? sourceComment, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'jsLib')  String? jsLib, @JsonKey(name: 'header')  Map<String, String>? header, @JsonKey(name: 'ruleArticles')  String? ruleArticles, @JsonKey(name: 'ruleTitle')  String? ruleTitle, @JsonKey(name: 'ruleLink')  String? ruleLink, @JsonKey(name: 'rulePubDate')  String? rulePubDate, @JsonKey(name: 'ruleDescription')  String? ruleDescription, @JsonKey(name: 'ruleImage')  String? ruleImage, @JsonKey(name: 'ruleContent')  String? ruleContent, @JsonKey(name: 'type')  int type, @JsonKey(name: 'sortUrl')  String? sortUrl, @JsonKey(name: 'articleStyle')  int articleStyle)  $default,) {final _that = this;
switch (_that) {
case _RssSource():
return $default(_that.sourceUrl,_that.sourceName,_that.sourceIcon,_that.sourceGroup,_that.sourceComment,_that.enabled,_that.jsLib,_that.header,_that.ruleArticles,_that.ruleTitle,_that.ruleLink,_that.rulePubDate,_that.ruleDescription,_that.ruleImage,_that.ruleContent,_that.type,_that.sortUrl,_that.articleStyle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'sourceUrl')  String sourceUrl, @JsonKey(name: 'sourceName')  String sourceName, @JsonKey(name: 'sourceIcon')  String sourceIcon, @JsonKey(name: 'sourceGroup')  String? sourceGroup, @JsonKey(name: 'sourceComment')  String? sourceComment, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'jsLib')  String? jsLib, @JsonKey(name: 'header')  Map<String, String>? header, @JsonKey(name: 'ruleArticles')  String? ruleArticles, @JsonKey(name: 'ruleTitle')  String? ruleTitle, @JsonKey(name: 'ruleLink')  String? ruleLink, @JsonKey(name: 'rulePubDate')  String? rulePubDate, @JsonKey(name: 'ruleDescription')  String? ruleDescription, @JsonKey(name: 'ruleImage')  String? ruleImage, @JsonKey(name: 'ruleContent')  String? ruleContent, @JsonKey(name: 'type')  int type, @JsonKey(name: 'sortUrl')  String? sortUrl, @JsonKey(name: 'articleStyle')  int articleStyle)?  $default,) {final _that = this;
switch (_that) {
case _RssSource() when $default != null:
return $default(_that.sourceUrl,_that.sourceName,_that.sourceIcon,_that.sourceGroup,_that.sourceComment,_that.enabled,_that.jsLib,_that.header,_that.ruleArticles,_that.ruleTitle,_that.ruleLink,_that.rulePubDate,_that.ruleDescription,_that.ruleImage,_that.ruleContent,_that.type,_that.sortUrl,_that.articleStyle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RssSource implements RssSource {
  const _RssSource({@JsonKey(name: 'sourceUrl') required this.sourceUrl, @JsonKey(name: 'sourceName') required this.sourceName, @JsonKey(name: 'sourceIcon') this.sourceIcon = '', @JsonKey(name: 'sourceGroup') this.sourceGroup, @JsonKey(name: 'sourceComment') this.sourceComment, @JsonKey(name: 'enabled') this.enabled = true, @JsonKey(name: 'jsLib') this.jsLib, @JsonKey(name: 'header') final  Map<String, String>? header, @JsonKey(name: 'ruleArticles') this.ruleArticles, @JsonKey(name: 'ruleTitle') this.ruleTitle, @JsonKey(name: 'ruleLink') this.ruleLink, @JsonKey(name: 'rulePubDate') this.rulePubDate, @JsonKey(name: 'ruleDescription') this.ruleDescription, @JsonKey(name: 'ruleImage') this.ruleImage, @JsonKey(name: 'ruleContent') this.ruleContent, @JsonKey(name: 'type') this.type = 0, @JsonKey(name: 'sortUrl') this.sortUrl, @JsonKey(name: 'articleStyle') this.articleStyle = 0}): _header = header;
  factory _RssSource.fromJson(Map<String, dynamic> json) => _$RssSourceFromJson(json);

@override@JsonKey(name: 'sourceUrl') final  String sourceUrl;
@override@JsonKey(name: 'sourceName') final  String sourceName;
@override@JsonKey(name: 'sourceIcon') final  String sourceIcon;
@override@JsonKey(name: 'sourceGroup') final  String? sourceGroup;
@override@JsonKey(name: 'sourceComment') final  String? sourceComment;
@override@JsonKey(name: 'enabled') final  bool enabled;
@override@JsonKey(name: 'jsLib') final  String? jsLib;
 final  Map<String, String>? _header;
@override@JsonKey(name: 'header') Map<String, String>? get header {
  final value = _header;
  if (value == null) return null;
  if (_header is EqualUnmodifiableMapView) return _header;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// 规则字段
@override@JsonKey(name: 'ruleArticles') final  String? ruleArticles;
@override@JsonKey(name: 'ruleTitle') final  String? ruleTitle;
@override@JsonKey(name: 'ruleLink') final  String? ruleLink;
@override@JsonKey(name: 'rulePubDate') final  String? rulePubDate;
@override@JsonKey(name: 'ruleDescription') final  String? ruleDescription;
@override@JsonKey(name: 'ruleImage') final  String? ruleImage;
@override@JsonKey(name: 'ruleContent') final  String? ruleContent;
@override@JsonKey(name: 'type') final  int type;
@override@JsonKey(name: 'sortUrl') final  String? sortUrl;
@override@JsonKey(name: 'articleStyle') final  int articleStyle;

/// Create a copy of RssSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RssSourceCopyWith<_RssSource> get copyWith => __$RssSourceCopyWithImpl<_RssSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RssSourceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RssSource&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceIcon, sourceIcon) || other.sourceIcon == sourceIcon)&&(identical(other.sourceGroup, sourceGroup) || other.sourceGroup == sourceGroup)&&(identical(other.sourceComment, sourceComment) || other.sourceComment == sourceComment)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.jsLib, jsLib) || other.jsLib == jsLib)&&const DeepCollectionEquality().equals(other._header, _header)&&(identical(other.ruleArticles, ruleArticles) || other.ruleArticles == ruleArticles)&&(identical(other.ruleTitle, ruleTitle) || other.ruleTitle == ruleTitle)&&(identical(other.ruleLink, ruleLink) || other.ruleLink == ruleLink)&&(identical(other.rulePubDate, rulePubDate) || other.rulePubDate == rulePubDate)&&(identical(other.ruleDescription, ruleDescription) || other.ruleDescription == ruleDescription)&&(identical(other.ruleImage, ruleImage) || other.ruleImage == ruleImage)&&(identical(other.ruleContent, ruleContent) || other.ruleContent == ruleContent)&&(identical(other.type, type) || other.type == type)&&(identical(other.sortUrl, sortUrl) || other.sortUrl == sortUrl)&&(identical(other.articleStyle, articleStyle) || other.articleStyle == articleStyle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceUrl,sourceName,sourceIcon,sourceGroup,sourceComment,enabled,jsLib,const DeepCollectionEquality().hash(_header),ruleArticles,ruleTitle,ruleLink,rulePubDate,ruleDescription,ruleImage,ruleContent,type,sortUrl,articleStyle);

@override
String toString() {
  return 'RssSource(sourceUrl: $sourceUrl, sourceName: $sourceName, sourceIcon: $sourceIcon, sourceGroup: $sourceGroup, sourceComment: $sourceComment, enabled: $enabled, jsLib: $jsLib, header: $header, ruleArticles: $ruleArticles, ruleTitle: $ruleTitle, ruleLink: $ruleLink, rulePubDate: $rulePubDate, ruleDescription: $ruleDescription, ruleImage: $ruleImage, ruleContent: $ruleContent, type: $type, sortUrl: $sortUrl, articleStyle: $articleStyle)';
}


}

/// @nodoc
abstract mixin class _$RssSourceCopyWith<$Res> implements $RssSourceCopyWith<$Res> {
  factory _$RssSourceCopyWith(_RssSource value, $Res Function(_RssSource) _then) = __$RssSourceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'sourceUrl') String sourceUrl,@JsonKey(name: 'sourceName') String sourceName,@JsonKey(name: 'sourceIcon') String sourceIcon,@JsonKey(name: 'sourceGroup') String? sourceGroup,@JsonKey(name: 'sourceComment') String? sourceComment,@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'jsLib') String? jsLib,@JsonKey(name: 'header') Map<String, String>? header,@JsonKey(name: 'ruleArticles') String? ruleArticles,@JsonKey(name: 'ruleTitle') String? ruleTitle,@JsonKey(name: 'ruleLink') String? ruleLink,@JsonKey(name: 'rulePubDate') String? rulePubDate,@JsonKey(name: 'ruleDescription') String? ruleDescription,@JsonKey(name: 'ruleImage') String? ruleImage,@JsonKey(name: 'ruleContent') String? ruleContent,@JsonKey(name: 'type') int type,@JsonKey(name: 'sortUrl') String? sortUrl,@JsonKey(name: 'articleStyle') int articleStyle
});




}
/// @nodoc
class __$RssSourceCopyWithImpl<$Res>
    implements _$RssSourceCopyWith<$Res> {
  __$RssSourceCopyWithImpl(this._self, this._then);

  final _RssSource _self;
  final $Res Function(_RssSource) _then;

/// Create a copy of RssSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceUrl = null,Object? sourceName = null,Object? sourceIcon = null,Object? sourceGroup = freezed,Object? sourceComment = freezed,Object? enabled = null,Object? jsLib = freezed,Object? header = freezed,Object? ruleArticles = freezed,Object? ruleTitle = freezed,Object? ruleLink = freezed,Object? rulePubDate = freezed,Object? ruleDescription = freezed,Object? ruleImage = freezed,Object? ruleContent = freezed,Object? type = null,Object? sortUrl = freezed,Object? articleStyle = null,}) {
  return _then(_RssSource(
sourceUrl: null == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceIcon: null == sourceIcon ? _self.sourceIcon : sourceIcon // ignore: cast_nullable_to_non_nullable
as String,sourceGroup: freezed == sourceGroup ? _self.sourceGroup : sourceGroup // ignore: cast_nullable_to_non_nullable
as String?,sourceComment: freezed == sourceComment ? _self.sourceComment : sourceComment // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,jsLib: freezed == jsLib ? _self.jsLib : jsLib // ignore: cast_nullable_to_non_nullable
as String?,header: freezed == header ? _self._header : header // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,ruleArticles: freezed == ruleArticles ? _self.ruleArticles : ruleArticles // ignore: cast_nullable_to_non_nullable
as String?,ruleTitle: freezed == ruleTitle ? _self.ruleTitle : ruleTitle // ignore: cast_nullable_to_non_nullable
as String?,ruleLink: freezed == ruleLink ? _self.ruleLink : ruleLink // ignore: cast_nullable_to_non_nullable
as String?,rulePubDate: freezed == rulePubDate ? _self.rulePubDate : rulePubDate // ignore: cast_nullable_to_non_nullable
as String?,ruleDescription: freezed == ruleDescription ? _self.ruleDescription : ruleDescription // ignore: cast_nullable_to_non_nullable
as String?,ruleImage: freezed == ruleImage ? _self.ruleImage : ruleImage // ignore: cast_nullable_to_non_nullable
as String?,ruleContent: freezed == ruleContent ? _self.ruleContent : ruleContent // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,sortUrl: freezed == sortUrl ? _self.sortUrl : sortUrl // ignore: cast_nullable_to_non_nullable
as String?,articleStyle: null == articleStyle ? _self.articleStyle : articleStyle // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
