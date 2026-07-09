// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HighlightRule {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'pattern') String get pattern;@JsonKey(name: 'sampleText') String get sampleText;@JsonKey(name: 'targetScope') int get targetScope;@JsonKey(name: 'enabled') bool get enabled;@JsonKey(name: 'position') int get position;@JsonKey(name: 'textColor') int? get textColor;@JsonKey(name: 'bgColor') int? get bgColor;@JsonKey(name: 'underlineMode') int get underlineMode;@JsonKey(name: 'underlineColor') int? get underlineColor;@JsonKey(name: 'underlineWidth') double get underlineWidth;@JsonKey(name: 'underlineOffset') double get underlineOffset;
/// Create a copy of HighlightRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HighlightRuleCopyWith<HighlightRule> get copyWith => _$HighlightRuleCopyWithImpl<HighlightRule>(this as HighlightRule, _$identity);

  /// Serializes this HighlightRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HighlightRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.sampleText, sampleText) || other.sampleText == sampleText)&&(identical(other.targetScope, targetScope) || other.targetScope == targetScope)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.position, position) || other.position == position)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.underlineMode, underlineMode) || other.underlineMode == underlineMode)&&(identical(other.underlineColor, underlineColor) || other.underlineColor == underlineColor)&&(identical(other.underlineWidth, underlineWidth) || other.underlineWidth == underlineWidth)&&(identical(other.underlineOffset, underlineOffset) || other.underlineOffset == underlineOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pattern,sampleText,targetScope,enabled,position,textColor,bgColor,underlineMode,underlineColor,underlineWidth,underlineOffset);

@override
String toString() {
  return 'HighlightRule(id: $id, name: $name, pattern: $pattern, sampleText: $sampleText, targetScope: $targetScope, enabled: $enabled, position: $position, textColor: $textColor, bgColor: $bgColor, underlineMode: $underlineMode, underlineColor: $underlineColor, underlineWidth: $underlineWidth, underlineOffset: $underlineOffset)';
}


}

/// @nodoc
abstract mixin class $HighlightRuleCopyWith<$Res>  {
  factory $HighlightRuleCopyWith(HighlightRule value, $Res Function(HighlightRule) _then) = _$HighlightRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'pattern') String pattern,@JsonKey(name: 'sampleText') String sampleText,@JsonKey(name: 'targetScope') int targetScope,@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'position') int position,@JsonKey(name: 'textColor') int? textColor,@JsonKey(name: 'bgColor') int? bgColor,@JsonKey(name: 'underlineMode') int underlineMode,@JsonKey(name: 'underlineColor') int? underlineColor,@JsonKey(name: 'underlineWidth') double underlineWidth,@JsonKey(name: 'underlineOffset') double underlineOffset
});




}
/// @nodoc
class _$HighlightRuleCopyWithImpl<$Res>
    implements $HighlightRuleCopyWith<$Res> {
  _$HighlightRuleCopyWithImpl(this._self, this._then);

  final HighlightRule _self;
  final $Res Function(HighlightRule) _then;

/// Create a copy of HighlightRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pattern = null,Object? sampleText = null,Object? targetScope = null,Object? enabled = null,Object? position = null,Object? textColor = freezed,Object? bgColor = freezed,Object? underlineMode = null,Object? underlineColor = freezed,Object? underlineWidth = null,Object? underlineOffset = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,sampleText: null == sampleText ? _self.sampleText : sampleText // ignore: cast_nullable_to_non_nullable
as String,targetScope: null == targetScope ? _self.targetScope : targetScope // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as int?,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as int?,underlineMode: null == underlineMode ? _self.underlineMode : underlineMode // ignore: cast_nullable_to_non_nullable
as int,underlineColor: freezed == underlineColor ? _self.underlineColor : underlineColor // ignore: cast_nullable_to_non_nullable
as int?,underlineWidth: null == underlineWidth ? _self.underlineWidth : underlineWidth // ignore: cast_nullable_to_non_nullable
as double,underlineOffset: null == underlineOffset ? _self.underlineOffset : underlineOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [HighlightRule].
extension HighlightRulePatterns on HighlightRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HighlightRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HighlightRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HighlightRule value)  $default,){
final _that = this;
switch (_that) {
case _HighlightRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HighlightRule value)?  $default,){
final _that = this;
switch (_that) {
case _HighlightRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'pattern')  String pattern, @JsonKey(name: 'sampleText')  String sampleText, @JsonKey(name: 'targetScope')  int targetScope, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'position')  int position, @JsonKey(name: 'textColor')  int? textColor, @JsonKey(name: 'bgColor')  int? bgColor, @JsonKey(name: 'underlineMode')  int underlineMode, @JsonKey(name: 'underlineColor')  int? underlineColor, @JsonKey(name: 'underlineWidth')  double underlineWidth, @JsonKey(name: 'underlineOffset')  double underlineOffset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HighlightRule() when $default != null:
return $default(_that.id,_that.name,_that.pattern,_that.sampleText,_that.targetScope,_that.enabled,_that.position,_that.textColor,_that.bgColor,_that.underlineMode,_that.underlineColor,_that.underlineWidth,_that.underlineOffset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'pattern')  String pattern, @JsonKey(name: 'sampleText')  String sampleText, @JsonKey(name: 'targetScope')  int targetScope, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'position')  int position, @JsonKey(name: 'textColor')  int? textColor, @JsonKey(name: 'bgColor')  int? bgColor, @JsonKey(name: 'underlineMode')  int underlineMode, @JsonKey(name: 'underlineColor')  int? underlineColor, @JsonKey(name: 'underlineWidth')  double underlineWidth, @JsonKey(name: 'underlineOffset')  double underlineOffset)  $default,) {final _that = this;
switch (_that) {
case _HighlightRule():
return $default(_that.id,_that.name,_that.pattern,_that.sampleText,_that.targetScope,_that.enabled,_that.position,_that.textColor,_that.bgColor,_that.underlineMode,_that.underlineColor,_that.underlineWidth,_that.underlineOffset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'pattern')  String pattern, @JsonKey(name: 'sampleText')  String sampleText, @JsonKey(name: 'targetScope')  int targetScope, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'position')  int position, @JsonKey(name: 'textColor')  int? textColor, @JsonKey(name: 'bgColor')  int? bgColor, @JsonKey(name: 'underlineMode')  int underlineMode, @JsonKey(name: 'underlineColor')  int? underlineColor, @JsonKey(name: 'underlineWidth')  double underlineWidth, @JsonKey(name: 'underlineOffset')  double underlineOffset)?  $default,) {final _that = this;
switch (_that) {
case _HighlightRule() when $default != null:
return $default(_that.id,_that.name,_that.pattern,_that.sampleText,_that.targetScope,_that.enabled,_that.position,_that.textColor,_that.bgColor,_that.underlineMode,_that.underlineColor,_that.underlineWidth,_that.underlineOffset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HighlightRule implements HighlightRule {
  const _HighlightRule({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'pattern') required this.pattern, @JsonKey(name: 'sampleText') this.sampleText = '', @JsonKey(name: 'targetScope') this.targetScope = 0, @JsonKey(name: 'enabled') this.enabled = true, @JsonKey(name: 'position') this.position = 0, @JsonKey(name: 'textColor') this.textColor, @JsonKey(name: 'bgColor') this.bgColor, @JsonKey(name: 'underlineMode') this.underlineMode = 0, @JsonKey(name: 'underlineColor') this.underlineColor, @JsonKey(name: 'underlineWidth') this.underlineWidth = 1.0, @JsonKey(name: 'underlineOffset') this.underlineOffset = 2.0});
  factory _HighlightRule.fromJson(Map<String, dynamic> json) => _$HighlightRuleFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'pattern') final  String pattern;
@override@JsonKey(name: 'sampleText') final  String sampleText;
@override@JsonKey(name: 'targetScope') final  int targetScope;
@override@JsonKey(name: 'enabled') final  bool enabled;
@override@JsonKey(name: 'position') final  int position;
@override@JsonKey(name: 'textColor') final  int? textColor;
@override@JsonKey(name: 'bgColor') final  int? bgColor;
@override@JsonKey(name: 'underlineMode') final  int underlineMode;
@override@JsonKey(name: 'underlineColor') final  int? underlineColor;
@override@JsonKey(name: 'underlineWidth') final  double underlineWidth;
@override@JsonKey(name: 'underlineOffset') final  double underlineOffset;

/// Create a copy of HighlightRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HighlightRuleCopyWith<_HighlightRule> get copyWith => __$HighlightRuleCopyWithImpl<_HighlightRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HighlightRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HighlightRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.sampleText, sampleText) || other.sampleText == sampleText)&&(identical(other.targetScope, targetScope) || other.targetScope == targetScope)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.position, position) || other.position == position)&&(identical(other.textColor, textColor) || other.textColor == textColor)&&(identical(other.bgColor, bgColor) || other.bgColor == bgColor)&&(identical(other.underlineMode, underlineMode) || other.underlineMode == underlineMode)&&(identical(other.underlineColor, underlineColor) || other.underlineColor == underlineColor)&&(identical(other.underlineWidth, underlineWidth) || other.underlineWidth == underlineWidth)&&(identical(other.underlineOffset, underlineOffset) || other.underlineOffset == underlineOffset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pattern,sampleText,targetScope,enabled,position,textColor,bgColor,underlineMode,underlineColor,underlineWidth,underlineOffset);

@override
String toString() {
  return 'HighlightRule(id: $id, name: $name, pattern: $pattern, sampleText: $sampleText, targetScope: $targetScope, enabled: $enabled, position: $position, textColor: $textColor, bgColor: $bgColor, underlineMode: $underlineMode, underlineColor: $underlineColor, underlineWidth: $underlineWidth, underlineOffset: $underlineOffset)';
}


}

/// @nodoc
abstract mixin class _$HighlightRuleCopyWith<$Res> implements $HighlightRuleCopyWith<$Res> {
  factory _$HighlightRuleCopyWith(_HighlightRule value, $Res Function(_HighlightRule) _then) = __$HighlightRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'pattern') String pattern,@JsonKey(name: 'sampleText') String sampleText,@JsonKey(name: 'targetScope') int targetScope,@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'position') int position,@JsonKey(name: 'textColor') int? textColor,@JsonKey(name: 'bgColor') int? bgColor,@JsonKey(name: 'underlineMode') int underlineMode,@JsonKey(name: 'underlineColor') int? underlineColor,@JsonKey(name: 'underlineWidth') double underlineWidth,@JsonKey(name: 'underlineOffset') double underlineOffset
});




}
/// @nodoc
class __$HighlightRuleCopyWithImpl<$Res>
    implements _$HighlightRuleCopyWith<$Res> {
  __$HighlightRuleCopyWithImpl(this._self, this._then);

  final _HighlightRule _self;
  final $Res Function(_HighlightRule) _then;

/// Create a copy of HighlightRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pattern = null,Object? sampleText = null,Object? targetScope = null,Object? enabled = null,Object? position = null,Object? textColor = freezed,Object? bgColor = freezed,Object? underlineMode = null,Object? underlineColor = freezed,Object? underlineWidth = null,Object? underlineOffset = null,}) {
  return _then(_HighlightRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,sampleText: null == sampleText ? _self.sampleText : sampleText // ignore: cast_nullable_to_non_nullable
as String,targetScope: null == targetScope ? _self.targetScope : targetScope // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,textColor: freezed == textColor ? _self.textColor : textColor // ignore: cast_nullable_to_non_nullable
as int?,bgColor: freezed == bgColor ? _self.bgColor : bgColor // ignore: cast_nullable_to_non_nullable
as int?,underlineMode: null == underlineMode ? _self.underlineMode : underlineMode // ignore: cast_nullable_to_non_nullable
as int,underlineColor: freezed == underlineColor ? _self.underlineColor : underlineColor // ignore: cast_nullable_to_non_nullable
as int?,underlineWidth: null == underlineWidth ? _self.underlineWidth : underlineWidth // ignore: cast_nullable_to_non_nullable
as double,underlineOffset: null == underlineOffset ? _self.underlineOffset : underlineOffset // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
