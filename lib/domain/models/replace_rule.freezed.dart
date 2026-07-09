// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'replace_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReplaceRule {

@JsonKey(name: 'id') int? get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'group') String? get group;@JsonKey(name: 'pattern') String get pattern;@JsonKey(name: 'replacement') String get replacement;@JsonKey(name: 'scope') String? get scope;@JsonKey(name: 'scopeTitle') bool get scopeTitle;@JsonKey(name: 'scopeContent') bool get scopeContent;@JsonKey(name: 'excludeScope') String? get excludeScope;@JsonKey(name: 'isEnabled') bool get isEnabled;@JsonKey(name: 'isRegex') bool get isRegex;@JsonKey(name: 'timeoutMillisecond') int get timeoutMillisecond;@JsonKey(name: 'order') int get order;
/// Create a copy of ReplaceRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplaceRuleCopyWith<ReplaceRule> get copyWith => _$ReplaceRuleCopyWithImpl<ReplaceRule>(this as ReplaceRule, _$identity);

  /// Serializes this ReplaceRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplaceRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.group, group) || other.group == group)&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.replacement, replacement) || other.replacement == replacement)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.scopeTitle, scopeTitle) || other.scopeTitle == scopeTitle)&&(identical(other.scopeContent, scopeContent) || other.scopeContent == scopeContent)&&(identical(other.excludeScope, excludeScope) || other.excludeScope == excludeScope)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.isRegex, isRegex) || other.isRegex == isRegex)&&(identical(other.timeoutMillisecond, timeoutMillisecond) || other.timeoutMillisecond == timeoutMillisecond)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,group,pattern,replacement,scope,scopeTitle,scopeContent,excludeScope,isEnabled,isRegex,timeoutMillisecond,order);

@override
String toString() {
  return 'ReplaceRule(id: $id, name: $name, group: $group, pattern: $pattern, replacement: $replacement, scope: $scope, scopeTitle: $scopeTitle, scopeContent: $scopeContent, excludeScope: $excludeScope, isEnabled: $isEnabled, isRegex: $isRegex, timeoutMillisecond: $timeoutMillisecond, order: $order)';
}


}

/// @nodoc
abstract mixin class $ReplaceRuleCopyWith<$Res>  {
  factory $ReplaceRuleCopyWith(ReplaceRule value, $Res Function(ReplaceRule) _then) = _$ReplaceRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'name') String name,@JsonKey(name: 'group') String? group,@JsonKey(name: 'pattern') String pattern,@JsonKey(name: 'replacement') String replacement,@JsonKey(name: 'scope') String? scope,@JsonKey(name: 'scopeTitle') bool scopeTitle,@JsonKey(name: 'scopeContent') bool scopeContent,@JsonKey(name: 'excludeScope') String? excludeScope,@JsonKey(name: 'isEnabled') bool isEnabled,@JsonKey(name: 'isRegex') bool isRegex,@JsonKey(name: 'timeoutMillisecond') int timeoutMillisecond,@JsonKey(name: 'order') int order
});




}
/// @nodoc
class _$ReplaceRuleCopyWithImpl<$Res>
    implements $ReplaceRuleCopyWith<$Res> {
  _$ReplaceRuleCopyWithImpl(this._self, this._then);

  final ReplaceRule _self;
  final $Res Function(ReplaceRule) _then;

/// Create a copy of ReplaceRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? group = freezed,Object? pattern = null,Object? replacement = null,Object? scope = freezed,Object? scopeTitle = null,Object? scopeContent = null,Object? excludeScope = freezed,Object? isEnabled = null,Object? isRegex = null,Object? timeoutMillisecond = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,replacement: null == replacement ? _self.replacement : replacement // ignore: cast_nullable_to_non_nullable
as String,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,scopeTitle: null == scopeTitle ? _self.scopeTitle : scopeTitle // ignore: cast_nullable_to_non_nullable
as bool,scopeContent: null == scopeContent ? _self.scopeContent : scopeContent // ignore: cast_nullable_to_non_nullable
as bool,excludeScope: freezed == excludeScope ? _self.excludeScope : excludeScope // ignore: cast_nullable_to_non_nullable
as String?,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,isRegex: null == isRegex ? _self.isRegex : isRegex // ignore: cast_nullable_to_non_nullable
as bool,timeoutMillisecond: null == timeoutMillisecond ? _self.timeoutMillisecond : timeoutMillisecond // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReplaceRule].
extension ReplaceRulePatterns on ReplaceRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReplaceRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReplaceRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReplaceRule value)  $default,){
final _that = this;
switch (_that) {
case _ReplaceRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReplaceRule value)?  $default,){
final _that = this;
switch (_that) {
case _ReplaceRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'group')  String? group, @JsonKey(name: 'pattern')  String pattern, @JsonKey(name: 'replacement')  String replacement, @JsonKey(name: 'scope')  String? scope, @JsonKey(name: 'scopeTitle')  bool scopeTitle, @JsonKey(name: 'scopeContent')  bool scopeContent, @JsonKey(name: 'excludeScope')  String? excludeScope, @JsonKey(name: 'isEnabled')  bool isEnabled, @JsonKey(name: 'isRegex')  bool isRegex, @JsonKey(name: 'timeoutMillisecond')  int timeoutMillisecond, @JsonKey(name: 'order')  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReplaceRule() when $default != null:
return $default(_that.id,_that.name,_that.group,_that.pattern,_that.replacement,_that.scope,_that.scopeTitle,_that.scopeContent,_that.excludeScope,_that.isEnabled,_that.isRegex,_that.timeoutMillisecond,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'group')  String? group, @JsonKey(name: 'pattern')  String pattern, @JsonKey(name: 'replacement')  String replacement, @JsonKey(name: 'scope')  String? scope, @JsonKey(name: 'scopeTitle')  bool scopeTitle, @JsonKey(name: 'scopeContent')  bool scopeContent, @JsonKey(name: 'excludeScope')  String? excludeScope, @JsonKey(name: 'isEnabled')  bool isEnabled, @JsonKey(name: 'isRegex')  bool isRegex, @JsonKey(name: 'timeoutMillisecond')  int timeoutMillisecond, @JsonKey(name: 'order')  int order)  $default,) {final _that = this;
switch (_that) {
case _ReplaceRule():
return $default(_that.id,_that.name,_that.group,_that.pattern,_that.replacement,_that.scope,_that.scopeTitle,_that.scopeContent,_that.excludeScope,_that.isEnabled,_that.isRegex,_that.timeoutMillisecond,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'group')  String? group, @JsonKey(name: 'pattern')  String pattern, @JsonKey(name: 'replacement')  String replacement, @JsonKey(name: 'scope')  String? scope, @JsonKey(name: 'scopeTitle')  bool scopeTitle, @JsonKey(name: 'scopeContent')  bool scopeContent, @JsonKey(name: 'excludeScope')  String? excludeScope, @JsonKey(name: 'isEnabled')  bool isEnabled, @JsonKey(name: 'isRegex')  bool isRegex, @JsonKey(name: 'timeoutMillisecond')  int timeoutMillisecond, @JsonKey(name: 'order')  int order)?  $default,) {final _that = this;
switch (_that) {
case _ReplaceRule() when $default != null:
return $default(_that.id,_that.name,_that.group,_that.pattern,_that.replacement,_that.scope,_that.scopeTitle,_that.scopeContent,_that.excludeScope,_that.isEnabled,_that.isRegex,_that.timeoutMillisecond,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReplaceRule implements ReplaceRule {
  const _ReplaceRule({@JsonKey(name: 'id') this.id, @JsonKey(name: 'name') this.name = '', @JsonKey(name: 'group') this.group, @JsonKey(name: 'pattern') this.pattern = '', @JsonKey(name: 'replacement') this.replacement = '', @JsonKey(name: 'scope') this.scope, @JsonKey(name: 'scopeTitle') this.scopeTitle = false, @JsonKey(name: 'scopeContent') this.scopeContent = true, @JsonKey(name: 'excludeScope') this.excludeScope, @JsonKey(name: 'isEnabled') this.isEnabled = true, @JsonKey(name: 'isRegex') this.isRegex = true, @JsonKey(name: 'timeoutMillisecond') this.timeoutMillisecond = 3000, @JsonKey(name: 'order') this.order = 0});
  factory _ReplaceRule.fromJson(Map<String, dynamic> json) => _$ReplaceRuleFromJson(json);

@override@JsonKey(name: 'id') final  int? id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'group') final  String? group;
@override@JsonKey(name: 'pattern') final  String pattern;
@override@JsonKey(name: 'replacement') final  String replacement;
@override@JsonKey(name: 'scope') final  String? scope;
@override@JsonKey(name: 'scopeTitle') final  bool scopeTitle;
@override@JsonKey(name: 'scopeContent') final  bool scopeContent;
@override@JsonKey(name: 'excludeScope') final  String? excludeScope;
@override@JsonKey(name: 'isEnabled') final  bool isEnabled;
@override@JsonKey(name: 'isRegex') final  bool isRegex;
@override@JsonKey(name: 'timeoutMillisecond') final  int timeoutMillisecond;
@override@JsonKey(name: 'order') final  int order;

/// Create a copy of ReplaceRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplaceRuleCopyWith<_ReplaceRule> get copyWith => __$ReplaceRuleCopyWithImpl<_ReplaceRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplaceRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplaceRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.group, group) || other.group == group)&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.replacement, replacement) || other.replacement == replacement)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.scopeTitle, scopeTitle) || other.scopeTitle == scopeTitle)&&(identical(other.scopeContent, scopeContent) || other.scopeContent == scopeContent)&&(identical(other.excludeScope, excludeScope) || other.excludeScope == excludeScope)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.isRegex, isRegex) || other.isRegex == isRegex)&&(identical(other.timeoutMillisecond, timeoutMillisecond) || other.timeoutMillisecond == timeoutMillisecond)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,group,pattern,replacement,scope,scopeTitle,scopeContent,excludeScope,isEnabled,isRegex,timeoutMillisecond,order);

@override
String toString() {
  return 'ReplaceRule(id: $id, name: $name, group: $group, pattern: $pattern, replacement: $replacement, scope: $scope, scopeTitle: $scopeTitle, scopeContent: $scopeContent, excludeScope: $excludeScope, isEnabled: $isEnabled, isRegex: $isRegex, timeoutMillisecond: $timeoutMillisecond, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ReplaceRuleCopyWith<$Res> implements $ReplaceRuleCopyWith<$Res> {
  factory _$ReplaceRuleCopyWith(_ReplaceRule value, $Res Function(_ReplaceRule) _then) = __$ReplaceRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'name') String name,@JsonKey(name: 'group') String? group,@JsonKey(name: 'pattern') String pattern,@JsonKey(name: 'replacement') String replacement,@JsonKey(name: 'scope') String? scope,@JsonKey(name: 'scopeTitle') bool scopeTitle,@JsonKey(name: 'scopeContent') bool scopeContent,@JsonKey(name: 'excludeScope') String? excludeScope,@JsonKey(name: 'isEnabled') bool isEnabled,@JsonKey(name: 'isRegex') bool isRegex,@JsonKey(name: 'timeoutMillisecond') int timeoutMillisecond,@JsonKey(name: 'order') int order
});




}
/// @nodoc
class __$ReplaceRuleCopyWithImpl<$Res>
    implements _$ReplaceRuleCopyWith<$Res> {
  __$ReplaceRuleCopyWithImpl(this._self, this._then);

  final _ReplaceRule _self;
  final $Res Function(_ReplaceRule) _then;

/// Create a copy of ReplaceRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? group = freezed,Object? pattern = null,Object? replacement = null,Object? scope = freezed,Object? scopeTitle = null,Object? scopeContent = null,Object? excludeScope = freezed,Object? isEnabled = null,Object? isRegex = null,Object? timeoutMillisecond = null,Object? order = null,}) {
  return _then(_ReplaceRule(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String?,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,replacement: null == replacement ? _self.replacement : replacement // ignore: cast_nullable_to_non_nullable
as String,scope: freezed == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String?,scopeTitle: null == scopeTitle ? _self.scopeTitle : scopeTitle // ignore: cast_nullable_to_non_nullable
as bool,scopeContent: null == scopeContent ? _self.scopeContent : scopeContent // ignore: cast_nullable_to_non_nullable
as bool,excludeScope: freezed == excludeScope ? _self.excludeScope : excludeScope // ignore: cast_nullable_to_non_nullable
as String?,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,isRegex: null == isRegex ? _self.isRegex : isRegex // ignore: cast_nullable_to_non_nullable
as bool,timeoutMillisecond: null == timeoutMillisecond ? _self.timeoutMillisecond : timeoutMillisecond // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
