// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewRule {

@JsonKey(name: 'reviewUrl') String? get reviewUrl;@JsonKey(name: 'avatarRule') String? get avatarRule;@JsonKey(name: 'contentRule') String? get contentRule;@JsonKey(name: 'postTimeRule') String? get postTimeRule;@JsonKey(name: 'reviewQuoteUrl') String? get reviewQuoteUrl;@JsonKey(name: 'voteUpUrl') String? get voteUpUrl;@JsonKey(name: 'voteDownUrl') String? get voteDownUrl;@JsonKey(name: 'postReviewUrl') String? get postReviewUrl;@JsonKey(name: 'postQuoteUrl') String? get postQuoteUrl;@JsonKey(name: 'deleteUrl') String? get deleteUrl;
/// Create a copy of ReviewRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewRuleCopyWith<ReviewRule> get copyWith => _$ReviewRuleCopyWithImpl<ReviewRule>(this as ReviewRule, _$identity);

  /// Serializes this ReviewRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewRule&&(identical(other.reviewUrl, reviewUrl) || other.reviewUrl == reviewUrl)&&(identical(other.avatarRule, avatarRule) || other.avatarRule == avatarRule)&&(identical(other.contentRule, contentRule) || other.contentRule == contentRule)&&(identical(other.postTimeRule, postTimeRule) || other.postTimeRule == postTimeRule)&&(identical(other.reviewQuoteUrl, reviewQuoteUrl) || other.reviewQuoteUrl == reviewQuoteUrl)&&(identical(other.voteUpUrl, voteUpUrl) || other.voteUpUrl == voteUpUrl)&&(identical(other.voteDownUrl, voteDownUrl) || other.voteDownUrl == voteDownUrl)&&(identical(other.postReviewUrl, postReviewUrl) || other.postReviewUrl == postReviewUrl)&&(identical(other.postQuoteUrl, postQuoteUrl) || other.postQuoteUrl == postQuoteUrl)&&(identical(other.deleteUrl, deleteUrl) || other.deleteUrl == deleteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewUrl,avatarRule,contentRule,postTimeRule,reviewQuoteUrl,voteUpUrl,voteDownUrl,postReviewUrl,postQuoteUrl,deleteUrl);

@override
String toString() {
  return 'ReviewRule(reviewUrl: $reviewUrl, avatarRule: $avatarRule, contentRule: $contentRule, postTimeRule: $postTimeRule, reviewQuoteUrl: $reviewQuoteUrl, voteUpUrl: $voteUpUrl, voteDownUrl: $voteDownUrl, postReviewUrl: $postReviewUrl, postQuoteUrl: $postQuoteUrl, deleteUrl: $deleteUrl)';
}


}

/// @nodoc
abstract mixin class $ReviewRuleCopyWith<$Res>  {
  factory $ReviewRuleCopyWith(ReviewRule value, $Res Function(ReviewRule) _then) = _$ReviewRuleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reviewUrl') String? reviewUrl,@JsonKey(name: 'avatarRule') String? avatarRule,@JsonKey(name: 'contentRule') String? contentRule,@JsonKey(name: 'postTimeRule') String? postTimeRule,@JsonKey(name: 'reviewQuoteUrl') String? reviewQuoteUrl,@JsonKey(name: 'voteUpUrl') String? voteUpUrl,@JsonKey(name: 'voteDownUrl') String? voteDownUrl,@JsonKey(name: 'postReviewUrl') String? postReviewUrl,@JsonKey(name: 'postQuoteUrl') String? postQuoteUrl,@JsonKey(name: 'deleteUrl') String? deleteUrl
});




}
/// @nodoc
class _$ReviewRuleCopyWithImpl<$Res>
    implements $ReviewRuleCopyWith<$Res> {
  _$ReviewRuleCopyWithImpl(this._self, this._then);

  final ReviewRule _self;
  final $Res Function(ReviewRule) _then;

/// Create a copy of ReviewRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reviewUrl = freezed,Object? avatarRule = freezed,Object? contentRule = freezed,Object? postTimeRule = freezed,Object? reviewQuoteUrl = freezed,Object? voteUpUrl = freezed,Object? voteDownUrl = freezed,Object? postReviewUrl = freezed,Object? postQuoteUrl = freezed,Object? deleteUrl = freezed,}) {
  return _then(_self.copyWith(
reviewUrl: freezed == reviewUrl ? _self.reviewUrl : reviewUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarRule: freezed == avatarRule ? _self.avatarRule : avatarRule // ignore: cast_nullable_to_non_nullable
as String?,contentRule: freezed == contentRule ? _self.contentRule : contentRule // ignore: cast_nullable_to_non_nullable
as String?,postTimeRule: freezed == postTimeRule ? _self.postTimeRule : postTimeRule // ignore: cast_nullable_to_non_nullable
as String?,reviewQuoteUrl: freezed == reviewQuoteUrl ? _self.reviewQuoteUrl : reviewQuoteUrl // ignore: cast_nullable_to_non_nullable
as String?,voteUpUrl: freezed == voteUpUrl ? _self.voteUpUrl : voteUpUrl // ignore: cast_nullable_to_non_nullable
as String?,voteDownUrl: freezed == voteDownUrl ? _self.voteDownUrl : voteDownUrl // ignore: cast_nullable_to_non_nullable
as String?,postReviewUrl: freezed == postReviewUrl ? _self.postReviewUrl : postReviewUrl // ignore: cast_nullable_to_non_nullable
as String?,postQuoteUrl: freezed == postQuoteUrl ? _self.postQuoteUrl : postQuoteUrl // ignore: cast_nullable_to_non_nullable
as String?,deleteUrl: freezed == deleteUrl ? _self.deleteUrl : deleteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewRule].
extension ReviewRulePatterns on ReviewRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewRule value)  $default,){
final _that = this;
switch (_that) {
case _ReviewRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewRule value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reviewUrl')  String? reviewUrl, @JsonKey(name: 'avatarRule')  String? avatarRule, @JsonKey(name: 'contentRule')  String? contentRule, @JsonKey(name: 'postTimeRule')  String? postTimeRule, @JsonKey(name: 'reviewQuoteUrl')  String? reviewQuoteUrl, @JsonKey(name: 'voteUpUrl')  String? voteUpUrl, @JsonKey(name: 'voteDownUrl')  String? voteDownUrl, @JsonKey(name: 'postReviewUrl')  String? postReviewUrl, @JsonKey(name: 'postQuoteUrl')  String? postQuoteUrl, @JsonKey(name: 'deleteUrl')  String? deleteUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewRule() when $default != null:
return $default(_that.reviewUrl,_that.avatarRule,_that.contentRule,_that.postTimeRule,_that.reviewQuoteUrl,_that.voteUpUrl,_that.voteDownUrl,_that.postReviewUrl,_that.postQuoteUrl,_that.deleteUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reviewUrl')  String? reviewUrl, @JsonKey(name: 'avatarRule')  String? avatarRule, @JsonKey(name: 'contentRule')  String? contentRule, @JsonKey(name: 'postTimeRule')  String? postTimeRule, @JsonKey(name: 'reviewQuoteUrl')  String? reviewQuoteUrl, @JsonKey(name: 'voteUpUrl')  String? voteUpUrl, @JsonKey(name: 'voteDownUrl')  String? voteDownUrl, @JsonKey(name: 'postReviewUrl')  String? postReviewUrl, @JsonKey(name: 'postQuoteUrl')  String? postQuoteUrl, @JsonKey(name: 'deleteUrl')  String? deleteUrl)  $default,) {final _that = this;
switch (_that) {
case _ReviewRule():
return $default(_that.reviewUrl,_that.avatarRule,_that.contentRule,_that.postTimeRule,_that.reviewQuoteUrl,_that.voteUpUrl,_that.voteDownUrl,_that.postReviewUrl,_that.postQuoteUrl,_that.deleteUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reviewUrl')  String? reviewUrl, @JsonKey(name: 'avatarRule')  String? avatarRule, @JsonKey(name: 'contentRule')  String? contentRule, @JsonKey(name: 'postTimeRule')  String? postTimeRule, @JsonKey(name: 'reviewQuoteUrl')  String? reviewQuoteUrl, @JsonKey(name: 'voteUpUrl')  String? voteUpUrl, @JsonKey(name: 'voteDownUrl')  String? voteDownUrl, @JsonKey(name: 'postReviewUrl')  String? postReviewUrl, @JsonKey(name: 'postQuoteUrl')  String? postQuoteUrl, @JsonKey(name: 'deleteUrl')  String? deleteUrl)?  $default,) {final _that = this;
switch (_that) {
case _ReviewRule() when $default != null:
return $default(_that.reviewUrl,_that.avatarRule,_that.contentRule,_that.postTimeRule,_that.reviewQuoteUrl,_that.voteUpUrl,_that.voteDownUrl,_that.postReviewUrl,_that.postQuoteUrl,_that.deleteUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewRule implements ReviewRule {
  const _ReviewRule({@JsonKey(name: 'reviewUrl') this.reviewUrl, @JsonKey(name: 'avatarRule') this.avatarRule, @JsonKey(name: 'contentRule') this.contentRule, @JsonKey(name: 'postTimeRule') this.postTimeRule, @JsonKey(name: 'reviewQuoteUrl') this.reviewQuoteUrl, @JsonKey(name: 'voteUpUrl') this.voteUpUrl, @JsonKey(name: 'voteDownUrl') this.voteDownUrl, @JsonKey(name: 'postReviewUrl') this.postReviewUrl, @JsonKey(name: 'postQuoteUrl') this.postQuoteUrl, @JsonKey(name: 'deleteUrl') this.deleteUrl});
  factory _ReviewRule.fromJson(Map<String, dynamic> json) => _$ReviewRuleFromJson(json);

@override@JsonKey(name: 'reviewUrl') final  String? reviewUrl;
@override@JsonKey(name: 'avatarRule') final  String? avatarRule;
@override@JsonKey(name: 'contentRule') final  String? contentRule;
@override@JsonKey(name: 'postTimeRule') final  String? postTimeRule;
@override@JsonKey(name: 'reviewQuoteUrl') final  String? reviewQuoteUrl;
@override@JsonKey(name: 'voteUpUrl') final  String? voteUpUrl;
@override@JsonKey(name: 'voteDownUrl') final  String? voteDownUrl;
@override@JsonKey(name: 'postReviewUrl') final  String? postReviewUrl;
@override@JsonKey(name: 'postQuoteUrl') final  String? postQuoteUrl;
@override@JsonKey(name: 'deleteUrl') final  String? deleteUrl;

/// Create a copy of ReviewRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewRuleCopyWith<_ReviewRule> get copyWith => __$ReviewRuleCopyWithImpl<_ReviewRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewRule&&(identical(other.reviewUrl, reviewUrl) || other.reviewUrl == reviewUrl)&&(identical(other.avatarRule, avatarRule) || other.avatarRule == avatarRule)&&(identical(other.contentRule, contentRule) || other.contentRule == contentRule)&&(identical(other.postTimeRule, postTimeRule) || other.postTimeRule == postTimeRule)&&(identical(other.reviewQuoteUrl, reviewQuoteUrl) || other.reviewQuoteUrl == reviewQuoteUrl)&&(identical(other.voteUpUrl, voteUpUrl) || other.voteUpUrl == voteUpUrl)&&(identical(other.voteDownUrl, voteDownUrl) || other.voteDownUrl == voteDownUrl)&&(identical(other.postReviewUrl, postReviewUrl) || other.postReviewUrl == postReviewUrl)&&(identical(other.postQuoteUrl, postQuoteUrl) || other.postQuoteUrl == postQuoteUrl)&&(identical(other.deleteUrl, deleteUrl) || other.deleteUrl == deleteUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewUrl,avatarRule,contentRule,postTimeRule,reviewQuoteUrl,voteUpUrl,voteDownUrl,postReviewUrl,postQuoteUrl,deleteUrl);

@override
String toString() {
  return 'ReviewRule(reviewUrl: $reviewUrl, avatarRule: $avatarRule, contentRule: $contentRule, postTimeRule: $postTimeRule, reviewQuoteUrl: $reviewQuoteUrl, voteUpUrl: $voteUpUrl, voteDownUrl: $voteDownUrl, postReviewUrl: $postReviewUrl, postQuoteUrl: $postQuoteUrl, deleteUrl: $deleteUrl)';
}


}

/// @nodoc
abstract mixin class _$ReviewRuleCopyWith<$Res> implements $ReviewRuleCopyWith<$Res> {
  factory _$ReviewRuleCopyWith(_ReviewRule value, $Res Function(_ReviewRule) _then) = __$ReviewRuleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reviewUrl') String? reviewUrl,@JsonKey(name: 'avatarRule') String? avatarRule,@JsonKey(name: 'contentRule') String? contentRule,@JsonKey(name: 'postTimeRule') String? postTimeRule,@JsonKey(name: 'reviewQuoteUrl') String? reviewQuoteUrl,@JsonKey(name: 'voteUpUrl') String? voteUpUrl,@JsonKey(name: 'voteDownUrl') String? voteDownUrl,@JsonKey(name: 'postReviewUrl') String? postReviewUrl,@JsonKey(name: 'postQuoteUrl') String? postQuoteUrl,@JsonKey(name: 'deleteUrl') String? deleteUrl
});




}
/// @nodoc
class __$ReviewRuleCopyWithImpl<$Res>
    implements _$ReviewRuleCopyWith<$Res> {
  __$ReviewRuleCopyWithImpl(this._self, this._then);

  final _ReviewRule _self;
  final $Res Function(_ReviewRule) _then;

/// Create a copy of ReviewRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reviewUrl = freezed,Object? avatarRule = freezed,Object? contentRule = freezed,Object? postTimeRule = freezed,Object? reviewQuoteUrl = freezed,Object? voteUpUrl = freezed,Object? voteDownUrl = freezed,Object? postReviewUrl = freezed,Object? postQuoteUrl = freezed,Object? deleteUrl = freezed,}) {
  return _then(_ReviewRule(
reviewUrl: freezed == reviewUrl ? _self.reviewUrl : reviewUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarRule: freezed == avatarRule ? _self.avatarRule : avatarRule // ignore: cast_nullable_to_non_nullable
as String?,contentRule: freezed == contentRule ? _self.contentRule : contentRule // ignore: cast_nullable_to_non_nullable
as String?,postTimeRule: freezed == postTimeRule ? _self.postTimeRule : postTimeRule // ignore: cast_nullable_to_non_nullable
as String?,reviewQuoteUrl: freezed == reviewQuoteUrl ? _self.reviewQuoteUrl : reviewQuoteUrl // ignore: cast_nullable_to_non_nullable
as String?,voteUpUrl: freezed == voteUpUrl ? _self.voteUpUrl : voteUpUrl // ignore: cast_nullable_to_non_nullable
as String?,voteDownUrl: freezed == voteDownUrl ? _self.voteDownUrl : voteDownUrl // ignore: cast_nullable_to_non_nullable
as String?,postReviewUrl: freezed == postReviewUrl ? _self.postReviewUrl : postReviewUrl // ignore: cast_nullable_to_non_nullable
as String?,postQuoteUrl: freezed == postQuoteUrl ? _self.postQuoteUrl : postQuoteUrl // ignore: cast_nullable_to_non_nullable
as String?,deleteUrl: freezed == deleteUrl ? _self.deleteUrl : deleteUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
