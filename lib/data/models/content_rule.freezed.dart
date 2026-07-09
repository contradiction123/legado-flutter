// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentRule {

@JsonKey(name: 'content') String? get content;@JsonKey(name: 'subContent') String? get subContent;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'nextContentUrl') String? get nextContentUrl;@JsonKey(name: 'webJs') String? get webJs;@JsonKey(name: 'sourceRegex') String? get sourceRegex;@JsonKey(name: 'replaceRegex') String? get replaceRegex;@JsonKey(name: 'imageStyle') String? get imageStyle;@JsonKey(name: 'imageDecode') String? get imageDecode;@JsonKey(name: 'payAction') String? get payAction;@JsonKey(name: 'callBackJs') String? get callBackJs;
/// Create a copy of ContentRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentRuleCopyWith<ContentRule> get copyWith => _$ContentRuleCopyWithImpl<ContentRule>(this as ContentRule, _$identity);

  /// Serializes this ContentRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentRule&&(identical(other.content, content) || other.content == content)&&(identical(other.subContent, subContent) || other.subContent == subContent)&&(identical(other.title, title) || other.title == title)&&(identical(other.nextContentUrl, nextContentUrl) || other.nextContentUrl == nextContentUrl)&&(identical(other.webJs, webJs) || other.webJs == webJs)&&(identical(other.sourceRegex, sourceRegex) || other.sourceRegex == sourceRegex)&&(identical(other.replaceRegex, replaceRegex) || other.replaceRegex == replaceRegex)&&(identical(other.imageStyle, imageStyle) || other.imageStyle == imageStyle)&&(identical(other.imageDecode, imageDecode) || other.imageDecode == imageDecode)&&(identical(other.payAction, payAction) || other.payAction == payAction)&&(identical(other.callBackJs, callBackJs) || other.callBackJs == callBackJs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,subContent,title,nextContentUrl,webJs,sourceRegex,replaceRegex,imageStyle,imageDecode,payAction,callBackJs);

@override
String toString() {
  return 'ContentRule(content: $content, subContent: $subContent, title: $title, nextContentUrl: $nextContentUrl, webJs: $webJs, sourceRegex: $sourceRegex, replaceRegex: $replaceRegex, imageStyle: $imageStyle, imageDecode: $imageDecode, payAction: $payAction, callBackJs: $callBackJs)';
}


}

/// @nodoc
abstract mixin class $ContentRuleCopyWith<$Res>  {
  factory $ContentRuleCopyWith(ContentRule value, $Res Function(ContentRule) _then) = _$ContentRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'content') String? content,@JsonKey(name: 'subContent') String? subContent,@JsonKey(name: 'title') String? title,@JsonKey(name: 'nextContentUrl') String? nextContentUrl,@JsonKey(name: 'webJs') String? webJs,@JsonKey(name: 'sourceRegex') String? sourceRegex,@JsonKey(name: 'replaceRegex') String? replaceRegex,@JsonKey(name: 'imageStyle') String? imageStyle,@JsonKey(name: 'imageDecode') String? imageDecode,@JsonKey(name: 'payAction') String? payAction,@JsonKey(name: 'callBackJs') String? callBackJs
});




}
/// @nodoc
class _$ContentRuleCopyWithImpl<$Res>
    implements $ContentRuleCopyWith<$Res> {
  _$ContentRuleCopyWithImpl(this._self, this._then);

  final ContentRule _self;
  final $Res Function(ContentRule) _then;

/// Create a copy of ContentRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? subContent = freezed,Object? title = freezed,Object? nextContentUrl = freezed,Object? webJs = freezed,Object? sourceRegex = freezed,Object? replaceRegex = freezed,Object? imageStyle = freezed,Object? imageDecode = freezed,Object? payAction = freezed,Object? callBackJs = freezed,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,subContent: freezed == subContent ? _self.subContent : subContent // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,nextContentUrl: freezed == nextContentUrl ? _self.nextContentUrl : nextContentUrl // ignore: cast_nullable_to_non_nullable
as String?,webJs: freezed == webJs ? _self.webJs : webJs // ignore: cast_nullable_to_non_nullable
as String?,sourceRegex: freezed == sourceRegex ? _self.sourceRegex : sourceRegex // ignore: cast_nullable_to_non_nullable
as String?,replaceRegex: freezed == replaceRegex ? _self.replaceRegex : replaceRegex // ignore: cast_nullable_to_non_nullable
as String?,imageStyle: freezed == imageStyle ? _self.imageStyle : imageStyle // ignore: cast_nullable_to_non_nullable
as String?,imageDecode: freezed == imageDecode ? _self.imageDecode : imageDecode // ignore: cast_nullable_to_non_nullable
as String?,payAction: freezed == payAction ? _self.payAction : payAction // ignore: cast_nullable_to_non_nullable
as String?,callBackJs: freezed == callBackJs ? _self.callBackJs : callBackJs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentRule].
extension ContentRulePatterns on ContentRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentRule value)  $default,){
final _that = this;
switch (_that) {
case _ContentRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentRule value)?  $default,){
final _that = this;
switch (_that) {
case _ContentRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'content')  String? content, @JsonKey(name: 'subContent')  String? subContent, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'nextContentUrl')  String? nextContentUrl, @JsonKey(name: 'webJs')  String? webJs, @JsonKey(name: 'sourceRegex')  String? sourceRegex, @JsonKey(name: 'replaceRegex')  String? replaceRegex, @JsonKey(name: 'imageStyle')  String? imageStyle, @JsonKey(name: 'imageDecode')  String? imageDecode, @JsonKey(name: 'payAction')  String? payAction, @JsonKey(name: 'callBackJs')  String? callBackJs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentRule() when $default != null:
return $default(_that.content,_that.subContent,_that.title,_that.nextContentUrl,_that.webJs,_that.sourceRegex,_that.replaceRegex,_that.imageStyle,_that.imageDecode,_that.payAction,_that.callBackJs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'content')  String? content, @JsonKey(name: 'subContent')  String? subContent, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'nextContentUrl')  String? nextContentUrl, @JsonKey(name: 'webJs')  String? webJs, @JsonKey(name: 'sourceRegex')  String? sourceRegex, @JsonKey(name: 'replaceRegex')  String? replaceRegex, @JsonKey(name: 'imageStyle')  String? imageStyle, @JsonKey(name: 'imageDecode')  String? imageDecode, @JsonKey(name: 'payAction')  String? payAction, @JsonKey(name: 'callBackJs')  String? callBackJs)  $default,) {final _that = this;
switch (_that) {
case _ContentRule():
return $default(_that.content,_that.subContent,_that.title,_that.nextContentUrl,_that.webJs,_that.sourceRegex,_that.replaceRegex,_that.imageStyle,_that.imageDecode,_that.payAction,_that.callBackJs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'content')  String? content, @JsonKey(name: 'subContent')  String? subContent, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'nextContentUrl')  String? nextContentUrl, @JsonKey(name: 'webJs')  String? webJs, @JsonKey(name: 'sourceRegex')  String? sourceRegex, @JsonKey(name: 'replaceRegex')  String? replaceRegex, @JsonKey(name: 'imageStyle')  String? imageStyle, @JsonKey(name: 'imageDecode')  String? imageDecode, @JsonKey(name: 'payAction')  String? payAction, @JsonKey(name: 'callBackJs')  String? callBackJs)?  $default,) {final _that = this;
switch (_that) {
case _ContentRule() when $default != null:
return $default(_that.content,_that.subContent,_that.title,_that.nextContentUrl,_that.webJs,_that.sourceRegex,_that.replaceRegex,_that.imageStyle,_that.imageDecode,_that.payAction,_that.callBackJs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContentRule implements ContentRule {
  const _ContentRule({@JsonKey(name: 'content') this.content, @JsonKey(name: 'subContent') this.subContent, @JsonKey(name: 'title') this.title, @JsonKey(name: 'nextContentUrl') this.nextContentUrl, @JsonKey(name: 'webJs') this.webJs, @JsonKey(name: 'sourceRegex') this.sourceRegex, @JsonKey(name: 'replaceRegex') this.replaceRegex, @JsonKey(name: 'imageStyle') this.imageStyle, @JsonKey(name: 'imageDecode') this.imageDecode, @JsonKey(name: 'payAction') this.payAction, @JsonKey(name: 'callBackJs') this.callBackJs});
  factory _ContentRule.fromJson(Map<String, dynamic> json) => _$ContentRuleFromJson(json);

@override@JsonKey(name: 'content') final  String? content;
@override@JsonKey(name: 'subContent') final  String? subContent;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'nextContentUrl') final  String? nextContentUrl;
@override@JsonKey(name: 'webJs') final  String? webJs;
@override@JsonKey(name: 'sourceRegex') final  String? sourceRegex;
@override@JsonKey(name: 'replaceRegex') final  String? replaceRegex;
@override@JsonKey(name: 'imageStyle') final  String? imageStyle;
@override@JsonKey(name: 'imageDecode') final  String? imageDecode;
@override@JsonKey(name: 'payAction') final  String? payAction;
@override@JsonKey(name: 'callBackJs') final  String? callBackJs;

/// Create a copy of ContentRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentRuleCopyWith<_ContentRule> get copyWith => __$ContentRuleCopyWithImpl<_ContentRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContentRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentRule&&(identical(other.content, content) || other.content == content)&&(identical(other.subContent, subContent) || other.subContent == subContent)&&(identical(other.title, title) || other.title == title)&&(identical(other.nextContentUrl, nextContentUrl) || other.nextContentUrl == nextContentUrl)&&(identical(other.webJs, webJs) || other.webJs == webJs)&&(identical(other.sourceRegex, sourceRegex) || other.sourceRegex == sourceRegex)&&(identical(other.replaceRegex, replaceRegex) || other.replaceRegex == replaceRegex)&&(identical(other.imageStyle, imageStyle) || other.imageStyle == imageStyle)&&(identical(other.imageDecode, imageDecode) || other.imageDecode == imageDecode)&&(identical(other.payAction, payAction) || other.payAction == payAction)&&(identical(other.callBackJs, callBackJs) || other.callBackJs == callBackJs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,subContent,title,nextContentUrl,webJs,sourceRegex,replaceRegex,imageStyle,imageDecode,payAction,callBackJs);

@override
String toString() {
  return 'ContentRule(content: $content, subContent: $subContent, title: $title, nextContentUrl: $nextContentUrl, webJs: $webJs, sourceRegex: $sourceRegex, replaceRegex: $replaceRegex, imageStyle: $imageStyle, imageDecode: $imageDecode, payAction: $payAction, callBackJs: $callBackJs)';
}


}

/// @nodoc
abstract mixin class _$ContentRuleCopyWith<$Res> implements $ContentRuleCopyWith<$Res> {
  factory _$ContentRuleCopyWith(_ContentRule value, $Res Function(_ContentRule) _then) = __$ContentRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'content') String? content,@JsonKey(name: 'subContent') String? subContent,@JsonKey(name: 'title') String? title,@JsonKey(name: 'nextContentUrl') String? nextContentUrl,@JsonKey(name: 'webJs') String? webJs,@JsonKey(name: 'sourceRegex') String? sourceRegex,@JsonKey(name: 'replaceRegex') String? replaceRegex,@JsonKey(name: 'imageStyle') String? imageStyle,@JsonKey(name: 'imageDecode') String? imageDecode,@JsonKey(name: 'payAction') String? payAction,@JsonKey(name: 'callBackJs') String? callBackJs
});




}
/// @nodoc
class __$ContentRuleCopyWithImpl<$Res>
    implements _$ContentRuleCopyWith<$Res> {
  __$ContentRuleCopyWithImpl(this._self, this._then);

  final _ContentRule _self;
  final $Res Function(_ContentRule) _then;

/// Create a copy of ContentRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? subContent = freezed,Object? title = freezed,Object? nextContentUrl = freezed,Object? webJs = freezed,Object? sourceRegex = freezed,Object? replaceRegex = freezed,Object? imageStyle = freezed,Object? imageDecode = freezed,Object? payAction = freezed,Object? callBackJs = freezed,}) {
  return _then(_ContentRule(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,subContent: freezed == subContent ? _self.subContent : subContent // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,nextContentUrl: freezed == nextContentUrl ? _self.nextContentUrl : nextContentUrl // ignore: cast_nullable_to_non_nullable
as String?,webJs: freezed == webJs ? _self.webJs : webJs // ignore: cast_nullable_to_non_nullable
as String?,sourceRegex: freezed == sourceRegex ? _self.sourceRegex : sourceRegex // ignore: cast_nullable_to_non_nullable
as String?,replaceRegex: freezed == replaceRegex ? _self.replaceRegex : replaceRegex // ignore: cast_nullable_to_non_nullable
as String?,imageStyle: freezed == imageStyle ? _self.imageStyle : imageStyle // ignore: cast_nullable_to_non_nullable
as String?,imageDecode: freezed == imageDecode ? _self.imageDecode : imageDecode // ignore: cast_nullable_to_non_nullable
as String?,payAction: freezed == payAction ? _self.payAction : payAction // ignore: cast_nullable_to_non_nullable
as String?,callBackJs: freezed == callBackJs ? _self.callBackJs : callBackJs // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
