// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'read_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadRecord {

@JsonKey(name: 'deviceId') String get deviceId;@JsonKey(name: 'bookName') String get bookName;@JsonKey(name: 'bookAuthor') String get bookAuthor;@JsonKey(name: 'readTime') int get readTime;@JsonKey(name: 'lastRead') int get lastRead;
/// Create a copy of ReadRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadRecordCopyWith<ReadRecord> get copyWith => _$ReadRecordCopyWithImpl<ReadRecord>(this as ReadRecord, _$identity);

  /// Serializes this ReadRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadRecord&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.bookName, bookName) || other.bookName == bookName)&&(identical(other.bookAuthor, bookAuthor) || other.bookAuthor == bookAuthor)&&(identical(other.readTime, readTime) || other.readTime == readTime)&&(identical(other.lastRead, lastRead) || other.lastRead == lastRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,bookName,bookAuthor,readTime,lastRead);

@override
String toString() {
  return 'ReadRecord(deviceId: $deviceId, bookName: $bookName, bookAuthor: $bookAuthor, readTime: $readTime, lastRead: $lastRead)';
}


}

/// @nodoc
abstract mixin class $ReadRecordCopyWith<$Res>  {
  factory $ReadRecordCopyWith(ReadRecord value, $Res Function(ReadRecord) _then) = _$ReadRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deviceId') String deviceId,@JsonKey(name: 'bookName') String bookName,@JsonKey(name: 'bookAuthor') String bookAuthor,@JsonKey(name: 'readTime') int readTime,@JsonKey(name: 'lastRead') int lastRead
});




}
/// @nodoc
class _$ReadRecordCopyWithImpl<$Res>
    implements $ReadRecordCopyWith<$Res> {
  _$ReadRecordCopyWithImpl(this._self, this._then);

  final ReadRecord _self;
  final $Res Function(ReadRecord) _then;

/// Create a copy of ReadRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? bookName = null,Object? bookAuthor = null,Object? readTime = null,Object? lastRead = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,bookName: null == bookName ? _self.bookName : bookName // ignore: cast_nullable_to_non_nullable
as String,bookAuthor: null == bookAuthor ? _self.bookAuthor : bookAuthor // ignore: cast_nullable_to_non_nullable
as String,readTime: null == readTime ? _self.readTime : readTime // ignore: cast_nullable_to_non_nullable
as int,lastRead: null == lastRead ? _self.lastRead : lastRead // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadRecord].
extension ReadRecordPatterns on ReadRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadRecord value)  $default,){
final _that = this;
switch (_that) {
case _ReadRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ReadRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'deviceId')  String deviceId, @JsonKey(name: 'bookName')  String bookName, @JsonKey(name: 'bookAuthor')  String bookAuthor, @JsonKey(name: 'readTime')  int readTime, @JsonKey(name: 'lastRead')  int lastRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadRecord() when $default != null:
return $default(_that.deviceId,_that.bookName,_that.bookAuthor,_that.readTime,_that.lastRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'deviceId')  String deviceId, @JsonKey(name: 'bookName')  String bookName, @JsonKey(name: 'bookAuthor')  String bookAuthor, @JsonKey(name: 'readTime')  int readTime, @JsonKey(name: 'lastRead')  int lastRead)  $default,) {final _that = this;
switch (_that) {
case _ReadRecord():
return $default(_that.deviceId,_that.bookName,_that.bookAuthor,_that.readTime,_that.lastRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'deviceId')  String deviceId, @JsonKey(name: 'bookName')  String bookName, @JsonKey(name: 'bookAuthor')  String bookAuthor, @JsonKey(name: 'readTime')  int readTime, @JsonKey(name: 'lastRead')  int lastRead)?  $default,) {final _that = this;
switch (_that) {
case _ReadRecord() when $default != null:
return $default(_that.deviceId,_that.bookName,_that.bookAuthor,_that.readTime,_that.lastRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadRecord implements ReadRecord {
  const _ReadRecord({@JsonKey(name: 'deviceId') required this.deviceId, @JsonKey(name: 'bookName') required this.bookName, @JsonKey(name: 'bookAuthor') this.bookAuthor = '', @JsonKey(name: 'readTime') this.readTime = 0, @JsonKey(name: 'lastRead') this.lastRead = 0});
  factory _ReadRecord.fromJson(Map<String, dynamic> json) => _$ReadRecordFromJson(json);

@override@JsonKey(name: 'deviceId') final  String deviceId;
@override@JsonKey(name: 'bookName') final  String bookName;
@override@JsonKey(name: 'bookAuthor') final  String bookAuthor;
@override@JsonKey(name: 'readTime') final  int readTime;
@override@JsonKey(name: 'lastRead') final  int lastRead;

/// Create a copy of ReadRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadRecordCopyWith<_ReadRecord> get copyWith => __$ReadRecordCopyWithImpl<_ReadRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadRecord&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.bookName, bookName) || other.bookName == bookName)&&(identical(other.bookAuthor, bookAuthor) || other.bookAuthor == bookAuthor)&&(identical(other.readTime, readTime) || other.readTime == readTime)&&(identical(other.lastRead, lastRead) || other.lastRead == lastRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,bookName,bookAuthor,readTime,lastRead);

@override
String toString() {
  return 'ReadRecord(deviceId: $deviceId, bookName: $bookName, bookAuthor: $bookAuthor, readTime: $readTime, lastRead: $lastRead)';
}


}

/// @nodoc
abstract mixin class _$ReadRecordCopyWith<$Res> implements $ReadRecordCopyWith<$Res> {
  factory _$ReadRecordCopyWith(_ReadRecord value, $Res Function(_ReadRecord) _then) = __$ReadRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deviceId') String deviceId,@JsonKey(name: 'bookName') String bookName,@JsonKey(name: 'bookAuthor') String bookAuthor,@JsonKey(name: 'readTime') int readTime,@JsonKey(name: 'lastRead') int lastRead
});




}
/// @nodoc
class __$ReadRecordCopyWithImpl<$Res>
    implements _$ReadRecordCopyWith<$Res> {
  __$ReadRecordCopyWithImpl(this._self, this._then);

  final _ReadRecord _self;
  final $Res Function(_ReadRecord) _then;

/// Create a copy of ReadRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? bookName = null,Object? bookAuthor = null,Object? readTime = null,Object? lastRead = null,}) {
  return _then(_ReadRecord(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,bookName: null == bookName ? _self.bookName : bookName // ignore: cast_nullable_to_non_nullable
as String,bookAuthor: null == bookAuthor ? _self.bookAuthor : bookAuthor // ignore: cast_nullable_to_non_nullable
as String,readTime: null == readTime ? _self.readTime : readTime // ignore: cast_nullable_to_non_nullable
as int,lastRead: null == lastRead ? _self.lastRead : lastRead // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
