// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toc_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TocRule {

@JsonKey(name: 'preUpdateJs') String? get preUpdateJs;@JsonKey(name: 'chapterList') String? get chapterList;@JsonKey(name: 'chapterName') String? get chapterName;@JsonKey(name: 'chapterUrl') String? get chapterUrl;@JsonKey(name: 'formatJs') String? get formatJs;@JsonKey(name: 'isVolume') String? get isVolume;@JsonKey(name: 'isVip') String? get isVip;@JsonKey(name: 'isPay') String? get isPay;@JsonKey(name: 'updateTime') String? get updateTime;@JsonKey(name: 'nextTocUrl') String? get nextTocUrl;
/// Create a copy of TocRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TocRuleCopyWith<TocRule> get copyWith => _$TocRuleCopyWithImpl<TocRule>(this as TocRule, _$identity);

  /// Serializes this TocRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TocRule&&(identical(other.preUpdateJs, preUpdateJs) || other.preUpdateJs == preUpdateJs)&&(identical(other.chapterList, chapterList) || other.chapterList == chapterList)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.chapterUrl, chapterUrl) || other.chapterUrl == chapterUrl)&&(identical(other.formatJs, formatJs) || other.formatJs == formatJs)&&(identical(other.isVolume, isVolume) || other.isVolume == isVolume)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.isPay, isPay) || other.isPay == isPay)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.nextTocUrl, nextTocUrl) || other.nextTocUrl == nextTocUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preUpdateJs,chapterList,chapterName,chapterUrl,formatJs,isVolume,isVip,isPay,updateTime,nextTocUrl);

@override
String toString() {
  return 'TocRule(preUpdateJs: $preUpdateJs, chapterList: $chapterList, chapterName: $chapterName, chapterUrl: $chapterUrl, formatJs: $formatJs, isVolume: $isVolume, isVip: $isVip, isPay: $isPay, updateTime: $updateTime, nextTocUrl: $nextTocUrl)';
}


}

/// @nodoc
abstract mixin class $TocRuleCopyWith<$Res>  {
  factory $TocRuleCopyWith(TocRule value, $Res Function(TocRule) _then) = _$TocRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'preUpdateJs') String? preUpdateJs,@JsonKey(name: 'chapterList') String? chapterList,@JsonKey(name: 'chapterName') String? chapterName,@JsonKey(name: 'chapterUrl') String? chapterUrl,@JsonKey(name: 'formatJs') String? formatJs,@JsonKey(name: 'isVolume') String? isVolume,@JsonKey(name: 'isVip') String? isVip,@JsonKey(name: 'isPay') String? isPay,@JsonKey(name: 'updateTime') String? updateTime,@JsonKey(name: 'nextTocUrl') String? nextTocUrl
});




}
/// @nodoc
class _$TocRuleCopyWithImpl<$Res>
    implements $TocRuleCopyWith<$Res> {
  _$TocRuleCopyWithImpl(this._self, this._then);

  final TocRule _self;
  final $Res Function(TocRule) _then;

/// Create a copy of TocRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preUpdateJs = freezed,Object? chapterList = freezed,Object? chapterName = freezed,Object? chapterUrl = freezed,Object? formatJs = freezed,Object? isVolume = freezed,Object? isVip = freezed,Object? isPay = freezed,Object? updateTime = freezed,Object? nextTocUrl = freezed,}) {
  return _then(_self.copyWith(
preUpdateJs: freezed == preUpdateJs ? _self.preUpdateJs : preUpdateJs // ignore: cast_nullable_to_non_nullable
as String?,chapterList: freezed == chapterList ? _self.chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as String?,chapterName: freezed == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String?,chapterUrl: freezed == chapterUrl ? _self.chapterUrl : chapterUrl // ignore: cast_nullable_to_non_nullable
as String?,formatJs: freezed == formatJs ? _self.formatJs : formatJs // ignore: cast_nullable_to_non_nullable
as String?,isVolume: freezed == isVolume ? _self.isVolume : isVolume // ignore: cast_nullable_to_non_nullable
as String?,isVip: freezed == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as String?,isPay: freezed == isPay ? _self.isPay : isPay // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,nextTocUrl: freezed == nextTocUrl ? _self.nextTocUrl : nextTocUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TocRule].
extension TocRulePatterns on TocRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TocRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TocRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TocRule value)  $default,){
final _that = this;
switch (_that) {
case _TocRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TocRule value)?  $default,){
final _that = this;
switch (_that) {
case _TocRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'preUpdateJs')  String? preUpdateJs, @JsonKey(name: 'chapterList')  String? chapterList, @JsonKey(name: 'chapterName')  String? chapterName, @JsonKey(name: 'chapterUrl')  String? chapterUrl, @JsonKey(name: 'formatJs')  String? formatJs, @JsonKey(name: 'isVolume')  String? isVolume, @JsonKey(name: 'isVip')  String? isVip, @JsonKey(name: 'isPay')  String? isPay, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'nextTocUrl')  String? nextTocUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TocRule() when $default != null:
return $default(_that.preUpdateJs,_that.chapterList,_that.chapterName,_that.chapterUrl,_that.formatJs,_that.isVolume,_that.isVip,_that.isPay,_that.updateTime,_that.nextTocUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'preUpdateJs')  String? preUpdateJs, @JsonKey(name: 'chapterList')  String? chapterList, @JsonKey(name: 'chapterName')  String? chapterName, @JsonKey(name: 'chapterUrl')  String? chapterUrl, @JsonKey(name: 'formatJs')  String? formatJs, @JsonKey(name: 'isVolume')  String? isVolume, @JsonKey(name: 'isVip')  String? isVip, @JsonKey(name: 'isPay')  String? isPay, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'nextTocUrl')  String? nextTocUrl)  $default,) {final _that = this;
switch (_that) {
case _TocRule():
return $default(_that.preUpdateJs,_that.chapterList,_that.chapterName,_that.chapterUrl,_that.formatJs,_that.isVolume,_that.isVip,_that.isPay,_that.updateTime,_that.nextTocUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'preUpdateJs')  String? preUpdateJs, @JsonKey(name: 'chapterList')  String? chapterList, @JsonKey(name: 'chapterName')  String? chapterName, @JsonKey(name: 'chapterUrl')  String? chapterUrl, @JsonKey(name: 'formatJs')  String? formatJs, @JsonKey(name: 'isVolume')  String? isVolume, @JsonKey(name: 'isVip')  String? isVip, @JsonKey(name: 'isPay')  String? isPay, @JsonKey(name: 'updateTime')  String? updateTime, @JsonKey(name: 'nextTocUrl')  String? nextTocUrl)?  $default,) {final _that = this;
switch (_that) {
case _TocRule() when $default != null:
return $default(_that.preUpdateJs,_that.chapterList,_that.chapterName,_that.chapterUrl,_that.formatJs,_that.isVolume,_that.isVip,_that.isPay,_that.updateTime,_that.nextTocUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TocRule implements TocRule {
  const _TocRule({@JsonKey(name: 'preUpdateJs') this.preUpdateJs, @JsonKey(name: 'chapterList') this.chapterList, @JsonKey(name: 'chapterName') this.chapterName, @JsonKey(name: 'chapterUrl') this.chapterUrl, @JsonKey(name: 'formatJs') this.formatJs, @JsonKey(name: 'isVolume') this.isVolume, @JsonKey(name: 'isVip') this.isVip, @JsonKey(name: 'isPay') this.isPay, @JsonKey(name: 'updateTime') this.updateTime, @JsonKey(name: 'nextTocUrl') this.nextTocUrl});
  factory _TocRule.fromJson(Map<String, dynamic> json) => _$TocRuleFromJson(json);

@override@JsonKey(name: 'preUpdateJs') final  String? preUpdateJs;
@override@JsonKey(name: 'chapterList') final  String? chapterList;
@override@JsonKey(name: 'chapterName') final  String? chapterName;
@override@JsonKey(name: 'chapterUrl') final  String? chapterUrl;
@override@JsonKey(name: 'formatJs') final  String? formatJs;
@override@JsonKey(name: 'isVolume') final  String? isVolume;
@override@JsonKey(name: 'isVip') final  String? isVip;
@override@JsonKey(name: 'isPay') final  String? isPay;
@override@JsonKey(name: 'updateTime') final  String? updateTime;
@override@JsonKey(name: 'nextTocUrl') final  String? nextTocUrl;

/// Create a copy of TocRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TocRuleCopyWith<_TocRule> get copyWith => __$TocRuleCopyWithImpl<_TocRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TocRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TocRule&&(identical(other.preUpdateJs, preUpdateJs) || other.preUpdateJs == preUpdateJs)&&(identical(other.chapterList, chapterList) || other.chapterList == chapterList)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.chapterUrl, chapterUrl) || other.chapterUrl == chapterUrl)&&(identical(other.formatJs, formatJs) || other.formatJs == formatJs)&&(identical(other.isVolume, isVolume) || other.isVolume == isVolume)&&(identical(other.isVip, isVip) || other.isVip == isVip)&&(identical(other.isPay, isPay) || other.isPay == isPay)&&(identical(other.updateTime, updateTime) || other.updateTime == updateTime)&&(identical(other.nextTocUrl, nextTocUrl) || other.nextTocUrl == nextTocUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,preUpdateJs,chapterList,chapterName,chapterUrl,formatJs,isVolume,isVip,isPay,updateTime,nextTocUrl);

@override
String toString() {
  return 'TocRule(preUpdateJs: $preUpdateJs, chapterList: $chapterList, chapterName: $chapterName, chapterUrl: $chapterUrl, formatJs: $formatJs, isVolume: $isVolume, isVip: $isVip, isPay: $isPay, updateTime: $updateTime, nextTocUrl: $nextTocUrl)';
}


}

/// @nodoc
abstract mixin class _$TocRuleCopyWith<$Res> implements $TocRuleCopyWith<$Res> {
  factory _$TocRuleCopyWith(_TocRule value, $Res Function(_TocRule) _then) = __$TocRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'preUpdateJs') String? preUpdateJs,@JsonKey(name: 'chapterList') String? chapterList,@JsonKey(name: 'chapterName') String? chapterName,@JsonKey(name: 'chapterUrl') String? chapterUrl,@JsonKey(name: 'formatJs') String? formatJs,@JsonKey(name: 'isVolume') String? isVolume,@JsonKey(name: 'isVip') String? isVip,@JsonKey(name: 'isPay') String? isPay,@JsonKey(name: 'updateTime') String? updateTime,@JsonKey(name: 'nextTocUrl') String? nextTocUrl
});




}
/// @nodoc
class __$TocRuleCopyWithImpl<$Res>
    implements _$TocRuleCopyWith<$Res> {
  __$TocRuleCopyWithImpl(this._self, this._then);

  final _TocRule _self;
  final $Res Function(_TocRule) _then;

/// Create a copy of TocRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preUpdateJs = freezed,Object? chapterList = freezed,Object? chapterName = freezed,Object? chapterUrl = freezed,Object? formatJs = freezed,Object? isVolume = freezed,Object? isVip = freezed,Object? isPay = freezed,Object? updateTime = freezed,Object? nextTocUrl = freezed,}) {
  return _then(_TocRule(
preUpdateJs: freezed == preUpdateJs ? _self.preUpdateJs : preUpdateJs // ignore: cast_nullable_to_non_nullable
as String?,chapterList: freezed == chapterList ? _self.chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as String?,chapterName: freezed == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String?,chapterUrl: freezed == chapterUrl ? _self.chapterUrl : chapterUrl // ignore: cast_nullable_to_non_nullable
as String?,formatJs: freezed == formatJs ? _self.formatJs : formatJs // ignore: cast_nullable_to_non_nullable
as String?,isVolume: freezed == isVolume ? _self.isVolume : isVolume // ignore: cast_nullable_to_non_nullable
as String?,isVip: freezed == isVip ? _self.isVip : isVip // ignore: cast_nullable_to_non_nullable
as String?,isPay: freezed == isPay ? _self.isPay : isPay // ignore: cast_nullable_to_non_nullable
as String?,updateTime: freezed == updateTime ? _self.updateTime : updateTime // ignore: cast_nullable_to_non_nullable
as String?,nextTocUrl: freezed == nextTocUrl ? _self.nextTocUrl : nextTocUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
