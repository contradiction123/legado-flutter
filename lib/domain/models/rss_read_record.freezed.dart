// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rss_read_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RssReadRecord {

@JsonKey(name: 'record') String get record;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'readTime') int? get readTime;@JsonKey(name: 'read') bool get read;@JsonKey(name: 'origin') String get origin;@JsonKey(name: 'sort') String get sort;@JsonKey(name: 'image') String? get image;@JsonKey(name: 'type') int get type;@JsonKey(name: 'durPos') int get durPos;@JsonKey(name: 'pubDate') String? get pubDate;
/// Create a copy of RssReadRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RssReadRecordCopyWith<RssReadRecord> get copyWith => _$RssReadRecordCopyWithImpl<RssReadRecord>(this as RssReadRecord, _$identity);

  /// Serializes this RssReadRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RssReadRecord&&(identical(other.record, record) || other.record == record)&&(identical(other.title, title) || other.title == title)&&(identical(other.readTime, readTime) || other.readTime == readTime)&&(identical(other.read, read) || other.read == read)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.image, image) || other.image == image)&&(identical(other.type, type) || other.type == type)&&(identical(other.durPos, durPos) || other.durPos == durPos)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,record,title,readTime,read,origin,sort,image,type,durPos,pubDate);

@override
String toString() {
  return 'RssReadRecord(record: $record, title: $title, readTime: $readTime, read: $read, origin: $origin, sort: $sort, image: $image, type: $type, durPos: $durPos, pubDate: $pubDate)';
}


}

/// @nodoc
abstract mixin class $RssReadRecordCopyWith<$Res>  {
  factory $RssReadRecordCopyWith(RssReadRecord value, $Res Function(RssReadRecord) _then) = _$RssReadRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'record') String record,@JsonKey(name: 'title') String? title,@JsonKey(name: 'readTime') int? readTime,@JsonKey(name: 'read') bool read,@JsonKey(name: 'origin') String origin,@JsonKey(name: 'sort') String sort,@JsonKey(name: 'image') String? image,@JsonKey(name: 'type') int type,@JsonKey(name: 'durPos') int durPos,@JsonKey(name: 'pubDate') String? pubDate
});




}
/// @nodoc
class _$RssReadRecordCopyWithImpl<$Res>
    implements $RssReadRecordCopyWith<$Res> {
  _$RssReadRecordCopyWithImpl(this._self, this._then);

  final RssReadRecord _self;
  final $Res Function(RssReadRecord) _then;

/// Create a copy of RssReadRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? record = null,Object? title = freezed,Object? readTime = freezed,Object? read = null,Object? origin = null,Object? sort = null,Object? image = freezed,Object? type = null,Object? durPos = null,Object? pubDate = freezed,}) {
  return _then(_self.copyWith(
record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,readTime: freezed == readTime ? _self.readTime : readTime // ignore: cast_nullable_to_non_nullable
as int?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,durPos: null == durPos ? _self.durPos : durPos // ignore: cast_nullable_to_non_nullable
as int,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RssReadRecord].
extension RssReadRecordPatterns on RssReadRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RssReadRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RssReadRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RssReadRecord value)  $default,){
final _that = this;
switch (_that) {
case _RssReadRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RssReadRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RssReadRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'record')  String record, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'readTime')  int? readTime, @JsonKey(name: 'read')  bool read, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'sort')  String sort, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'type')  int type, @JsonKey(name: 'durPos')  int durPos, @JsonKey(name: 'pubDate')  String? pubDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RssReadRecord() when $default != null:
return $default(_that.record,_that.title,_that.readTime,_that.read,_that.origin,_that.sort,_that.image,_that.type,_that.durPos,_that.pubDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'record')  String record, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'readTime')  int? readTime, @JsonKey(name: 'read')  bool read, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'sort')  String sort, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'type')  int type, @JsonKey(name: 'durPos')  int durPos, @JsonKey(name: 'pubDate')  String? pubDate)  $default,) {final _that = this;
switch (_that) {
case _RssReadRecord():
return $default(_that.record,_that.title,_that.readTime,_that.read,_that.origin,_that.sort,_that.image,_that.type,_that.durPos,_that.pubDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'record')  String record, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'readTime')  int? readTime, @JsonKey(name: 'read')  bool read, @JsonKey(name: 'origin')  String origin, @JsonKey(name: 'sort')  String sort, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'type')  int type, @JsonKey(name: 'durPos')  int durPos, @JsonKey(name: 'pubDate')  String? pubDate)?  $default,) {final _that = this;
switch (_that) {
case _RssReadRecord() when $default != null:
return $default(_that.record,_that.title,_that.readTime,_that.read,_that.origin,_that.sort,_that.image,_that.type,_that.durPos,_that.pubDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RssReadRecord implements RssReadRecord {
  const _RssReadRecord({@JsonKey(name: 'record') required this.record, @JsonKey(name: 'title') this.title, @JsonKey(name: 'readTime') this.readTime, @JsonKey(name: 'read') this.read = true, @JsonKey(name: 'origin') this.origin = '', @JsonKey(name: 'sort') this.sort = '', @JsonKey(name: 'image') this.image, @JsonKey(name: 'type') this.type = 0, @JsonKey(name: 'durPos') this.durPos = 0, @JsonKey(name: 'pubDate') this.pubDate});
  factory _RssReadRecord.fromJson(Map<String, dynamic> json) => _$RssReadRecordFromJson(json);

@override@JsonKey(name: 'record') final  String record;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'readTime') final  int? readTime;
@override@JsonKey(name: 'read') final  bool read;
@override@JsonKey(name: 'origin') final  String origin;
@override@JsonKey(name: 'sort') final  String sort;
@override@JsonKey(name: 'image') final  String? image;
@override@JsonKey(name: 'type') final  int type;
@override@JsonKey(name: 'durPos') final  int durPos;
@override@JsonKey(name: 'pubDate') final  String? pubDate;

/// Create a copy of RssReadRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RssReadRecordCopyWith<_RssReadRecord> get copyWith => __$RssReadRecordCopyWithImpl<_RssReadRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RssReadRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RssReadRecord&&(identical(other.record, record) || other.record == record)&&(identical(other.title, title) || other.title == title)&&(identical(other.readTime, readTime) || other.readTime == readTime)&&(identical(other.read, read) || other.read == read)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.image, image) || other.image == image)&&(identical(other.type, type) || other.type == type)&&(identical(other.durPos, durPos) || other.durPos == durPos)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,record,title,readTime,read,origin,sort,image,type,durPos,pubDate);

@override
String toString() {
  return 'RssReadRecord(record: $record, title: $title, readTime: $readTime, read: $read, origin: $origin, sort: $sort, image: $image, type: $type, durPos: $durPos, pubDate: $pubDate)';
}


}

/// @nodoc
abstract mixin class _$RssReadRecordCopyWith<$Res> implements $RssReadRecordCopyWith<$Res> {
  factory _$RssReadRecordCopyWith(_RssReadRecord value, $Res Function(_RssReadRecord) _then) = __$RssReadRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'record') String record,@JsonKey(name: 'title') String? title,@JsonKey(name: 'readTime') int? readTime,@JsonKey(name: 'read') bool read,@JsonKey(name: 'origin') String origin,@JsonKey(name: 'sort') String sort,@JsonKey(name: 'image') String? image,@JsonKey(name: 'type') int type,@JsonKey(name: 'durPos') int durPos,@JsonKey(name: 'pubDate') String? pubDate
});




}
/// @nodoc
class __$RssReadRecordCopyWithImpl<$Res>
    implements _$RssReadRecordCopyWith<$Res> {
  __$RssReadRecordCopyWithImpl(this._self, this._then);

  final _RssReadRecord _self;
  final $Res Function(_RssReadRecord) _then;

/// Create a copy of RssReadRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? record = null,Object? title = freezed,Object? readTime = freezed,Object? read = null,Object? origin = null,Object? sort = null,Object? image = freezed,Object? type = null,Object? durPos = null,Object? pubDate = freezed,}) {
  return _then(_RssReadRecord(
record: null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,readTime: freezed == readTime ? _self.readTime : readTime // ignore: cast_nullable_to_non_nullable
as int?,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,durPos: null == durPos ? _self.durPos : durPos // ignore: cast_nullable_to_non_nullable
as int,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
