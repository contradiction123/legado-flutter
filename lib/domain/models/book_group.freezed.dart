// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookGroup {

@JsonKey(name: 'groupId') int get groupId;@JsonKey(name: 'groupName') String get groupName;@JsonKey(name: 'cover') String? get cover;@JsonKey(name: 'order') int get order;@JsonKey(name: 'enableRefresh') bool get enableRefresh;@JsonKey(name: 'show') bool get show;@JsonKey(name: 'bookSort') int get bookSort;@JsonKey(name: 'isPrivate') bool get isPrivate;
/// Create a copy of BookGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookGroupCopyWith<BookGroup> get copyWith => _$BookGroupCopyWithImpl<BookGroup>(this as BookGroup, _$identity);

  /// Serializes this BookGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookGroup&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.order, order) || other.order == order)&&(identical(other.enableRefresh, enableRefresh) || other.enableRefresh == enableRefresh)&&(identical(other.show, show) || other.show == show)&&(identical(other.bookSort, bookSort) || other.bookSort == bookSort)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,cover,order,enableRefresh,show,bookSort,isPrivate);

@override
String toString() {
  return 'BookGroup(groupId: $groupId, groupName: $groupName, cover: $cover, order: $order, enableRefresh: $enableRefresh, show: $show, bookSort: $bookSort, isPrivate: $isPrivate)';
}


}

/// @nodoc
abstract mixin class $BookGroupCopyWith<$Res>  {
  factory $BookGroupCopyWith(BookGroup value, $Res Function(BookGroup) _then) = _$BookGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'groupId') int groupId,@JsonKey(name: 'groupName') String groupName,@JsonKey(name: 'cover') String? cover,@JsonKey(name: 'order') int order,@JsonKey(name: 'enableRefresh') bool enableRefresh,@JsonKey(name: 'show') bool show,@JsonKey(name: 'bookSort') int bookSort,@JsonKey(name: 'isPrivate') bool isPrivate
});




}
/// @nodoc
class _$BookGroupCopyWithImpl<$Res>
    implements $BookGroupCopyWith<$Res> {
  _$BookGroupCopyWithImpl(this._self, this._then);

  final BookGroup _self;
  final $Res Function(BookGroup) _then;

/// Create a copy of BookGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupId = null,Object? groupName = null,Object? cover = freezed,Object? order = null,Object? enableRefresh = null,Object? show = null,Object? bookSort = null,Object? isPrivate = null,}) {
  return _then(_self.copyWith(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,enableRefresh: null == enableRefresh ? _self.enableRefresh : enableRefresh // ignore: cast_nullable_to_non_nullable
as bool,show: null == show ? _self.show : show // ignore: cast_nullable_to_non_nullable
as bool,bookSort: null == bookSort ? _self.bookSort : bookSort // ignore: cast_nullable_to_non_nullable
as int,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BookGroup].
extension BookGroupPatterns on BookGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookGroup value)  $default,){
final _that = this;
switch (_that) {
case _BookGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookGroup value)?  $default,){
final _that = this;
switch (_that) {
case _BookGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'groupId')  int groupId, @JsonKey(name: 'groupName')  String groupName, @JsonKey(name: 'cover')  String? cover, @JsonKey(name: 'order')  int order, @JsonKey(name: 'enableRefresh')  bool enableRefresh, @JsonKey(name: 'show')  bool show, @JsonKey(name: 'bookSort')  int bookSort, @JsonKey(name: 'isPrivate')  bool isPrivate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookGroup() when $default != null:
return $default(_that.groupId,_that.groupName,_that.cover,_that.order,_that.enableRefresh,_that.show,_that.bookSort,_that.isPrivate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'groupId')  int groupId, @JsonKey(name: 'groupName')  String groupName, @JsonKey(name: 'cover')  String? cover, @JsonKey(name: 'order')  int order, @JsonKey(name: 'enableRefresh')  bool enableRefresh, @JsonKey(name: 'show')  bool show, @JsonKey(name: 'bookSort')  int bookSort, @JsonKey(name: 'isPrivate')  bool isPrivate)  $default,) {final _that = this;
switch (_that) {
case _BookGroup():
return $default(_that.groupId,_that.groupName,_that.cover,_that.order,_that.enableRefresh,_that.show,_that.bookSort,_that.isPrivate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'groupId')  int groupId, @JsonKey(name: 'groupName')  String groupName, @JsonKey(name: 'cover')  String? cover, @JsonKey(name: 'order')  int order, @JsonKey(name: 'enableRefresh')  bool enableRefresh, @JsonKey(name: 'show')  bool show, @JsonKey(name: 'bookSort')  int bookSort, @JsonKey(name: 'isPrivate')  bool isPrivate)?  $default,) {final _that = this;
switch (_that) {
case _BookGroup() when $default != null:
return $default(_that.groupId,_that.groupName,_that.cover,_that.order,_that.enableRefresh,_that.show,_that.bookSort,_that.isPrivate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookGroup implements BookGroup {
  const _BookGroup({@JsonKey(name: 'groupId') this.groupId = 1, @JsonKey(name: 'groupName') required this.groupName, @JsonKey(name: 'cover') this.cover, @JsonKey(name: 'order') this.order = 0, @JsonKey(name: 'enableRefresh') this.enableRefresh = true, @JsonKey(name: 'show') this.show = true, @JsonKey(name: 'bookSort') this.bookSort = -1, @JsonKey(name: 'isPrivate') this.isPrivate = false});
  factory _BookGroup.fromJson(Map<String, dynamic> json) => _$BookGroupFromJson(json);

@override@JsonKey(name: 'groupId') final  int groupId;
@override@JsonKey(name: 'groupName') final  String groupName;
@override@JsonKey(name: 'cover') final  String? cover;
@override@JsonKey(name: 'order') final  int order;
@override@JsonKey(name: 'enableRefresh') final  bool enableRefresh;
@override@JsonKey(name: 'show') final  bool show;
@override@JsonKey(name: 'bookSort') final  int bookSort;
@override@JsonKey(name: 'isPrivate') final  bool isPrivate;

/// Create a copy of BookGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookGroupCopyWith<_BookGroup> get copyWith => __$BookGroupCopyWithImpl<_BookGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookGroup&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.order, order) || other.order == order)&&(identical(other.enableRefresh, enableRefresh) || other.enableRefresh == enableRefresh)&&(identical(other.show, show) || other.show == show)&&(identical(other.bookSort, bookSort) || other.bookSort == bookSort)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,groupId,groupName,cover,order,enableRefresh,show,bookSort,isPrivate);

@override
String toString() {
  return 'BookGroup(groupId: $groupId, groupName: $groupName, cover: $cover, order: $order, enableRefresh: $enableRefresh, show: $show, bookSort: $bookSort, isPrivate: $isPrivate)';
}


}

/// @nodoc
abstract mixin class _$BookGroupCopyWith<$Res> implements $BookGroupCopyWith<$Res> {
  factory _$BookGroupCopyWith(_BookGroup value, $Res Function(_BookGroup) _then) = __$BookGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'groupId') int groupId,@JsonKey(name: 'groupName') String groupName,@JsonKey(name: 'cover') String? cover,@JsonKey(name: 'order') int order,@JsonKey(name: 'enableRefresh') bool enableRefresh,@JsonKey(name: 'show') bool show,@JsonKey(name: 'bookSort') int bookSort,@JsonKey(name: 'isPrivate') bool isPrivate
});




}
/// @nodoc
class __$BookGroupCopyWithImpl<$Res>
    implements _$BookGroupCopyWith<$Res> {
  __$BookGroupCopyWithImpl(this._self, this._then);

  final _BookGroup _self;
  final $Res Function(_BookGroup) _then;

/// Create a copy of BookGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupId = null,Object? groupName = null,Object? cover = freezed,Object? order = null,Object? enableRefresh = null,Object? show = null,Object? bookSort = null,Object? isPrivate = null,}) {
  return _then(_BookGroup(
groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as int,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,enableRefresh: null == enableRefresh ? _self.enableRefresh : enableRefresh // ignore: cast_nullable_to_non_nullable
as bool,show: null == show ? _self.show : show // ignore: cast_nullable_to_non_nullable
as bool,bookSort: null == bookSort ? _self.bookSort : bookSort // ignore: cast_nullable_to_non_nullable
as int,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
