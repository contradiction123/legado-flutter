// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dict_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DictRule {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'urlRule') String get urlRule;@JsonKey(name: 'showRule') String get showRule;@JsonKey(name: 'enabled') bool get enabled;@JsonKey(name: 'sortNumber') int get sortNumber;
/// Create a copy of DictRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictRuleCopyWith<DictRule> get copyWith => _$DictRuleCopyWithImpl<DictRule>(this as DictRule, _$identity);

  /// Serializes this DictRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictRule&&(identical(other.name, name) || other.name == name)&&(identical(other.urlRule, urlRule) || other.urlRule == urlRule)&&(identical(other.showRule, showRule) || other.showRule == showRule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.sortNumber, sortNumber) || other.sortNumber == sortNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,urlRule,showRule,enabled,sortNumber);

@override
String toString() {
  return 'DictRule(name: $name, urlRule: $urlRule, showRule: $showRule, enabled: $enabled, sortNumber: $sortNumber)';
}


}

/// @nodoc
abstract mixin class $DictRuleCopyWith<$Res>  {
  factory $DictRuleCopyWith(DictRule value, $Res Function(DictRule) _then) = _$DictRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'urlRule') String urlRule,@JsonKey(name: 'showRule') String showRule,@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'sortNumber') int sortNumber
});




}
/// @nodoc
class _$DictRuleCopyWithImpl<$Res>
    implements $DictRuleCopyWith<$Res> {
  _$DictRuleCopyWithImpl(this._self, this._then);

  final DictRule _self;
  final $Res Function(DictRule) _then;

/// Create a copy of DictRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? urlRule = null,Object? showRule = null,Object? enabled = null,Object? sortNumber = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,urlRule: null == urlRule ? _self.urlRule : urlRule // ignore: cast_nullable_to_non_nullable
as String,showRule: null == showRule ? _self.showRule : showRule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,sortNumber: null == sortNumber ? _self.sortNumber : sortNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DictRule].
extension DictRulePatterns on DictRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictRule value)  $default,){
final _that = this;
switch (_that) {
case _DictRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictRule value)?  $default,){
final _that = this;
switch (_that) {
case _DictRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'urlRule')  String urlRule, @JsonKey(name: 'showRule')  String showRule, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'sortNumber')  int sortNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictRule() when $default != null:
return $default(_that.name,_that.urlRule,_that.showRule,_that.enabled,_that.sortNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'urlRule')  String urlRule, @JsonKey(name: 'showRule')  String showRule, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'sortNumber')  int sortNumber)  $default,) {final _that = this;
switch (_that) {
case _DictRule():
return $default(_that.name,_that.urlRule,_that.showRule,_that.enabled,_that.sortNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'urlRule')  String urlRule, @JsonKey(name: 'showRule')  String showRule, @JsonKey(name: 'enabled')  bool enabled, @JsonKey(name: 'sortNumber')  int sortNumber)?  $default,) {final _that = this;
switch (_that) {
case _DictRule() when $default != null:
return $default(_that.name,_that.urlRule,_that.showRule,_that.enabled,_that.sortNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DictRule implements DictRule {
  const _DictRule({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'urlRule') this.urlRule = '', @JsonKey(name: 'showRule') this.showRule = '', @JsonKey(name: 'enabled') this.enabled = true, @JsonKey(name: 'sortNumber') this.sortNumber = 0});
  factory _DictRule.fromJson(Map<String, dynamic> json) => _$DictRuleFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'urlRule') final  String urlRule;
@override@JsonKey(name: 'showRule') final  String showRule;
@override@JsonKey(name: 'enabled') final  bool enabled;
@override@JsonKey(name: 'sortNumber') final  int sortNumber;

/// Create a copy of DictRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictRuleCopyWith<_DictRule> get copyWith => __$DictRuleCopyWithImpl<_DictRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DictRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictRule&&(identical(other.name, name) || other.name == name)&&(identical(other.urlRule, urlRule) || other.urlRule == urlRule)&&(identical(other.showRule, showRule) || other.showRule == showRule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.sortNumber, sortNumber) || other.sortNumber == sortNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,urlRule,showRule,enabled,sortNumber);

@override
String toString() {
  return 'DictRule(name: $name, urlRule: $urlRule, showRule: $showRule, enabled: $enabled, sortNumber: $sortNumber)';
}


}

/// @nodoc
abstract mixin class _$DictRuleCopyWith<$Res> implements $DictRuleCopyWith<$Res> {
  factory _$DictRuleCopyWith(_DictRule value, $Res Function(_DictRule) _then) = __$DictRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'urlRule') String urlRule,@JsonKey(name: 'showRule') String showRule,@JsonKey(name: 'enabled') bool enabled,@JsonKey(name: 'sortNumber') int sortNumber
});




}
/// @nodoc
class __$DictRuleCopyWithImpl<$Res>
    implements _$DictRuleCopyWith<$Res> {
  __$DictRuleCopyWithImpl(this._self, this._then);

  final _DictRule _self;
  final $Res Function(_DictRule) _then;

/// Create a copy of DictRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? urlRule = null,Object? showRule = null,Object? enabled = null,Object? sortNumber = null,}) {
  return _then(_DictRule(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,urlRule: null == urlRule ? _self.urlRule : urlRule // ignore: cast_nullable_to_non_nullable
as String,showRule: null == showRule ? _self.showRule : showRule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,sortNumber: null == sortNumber ? _self.sortNumber : sortNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
