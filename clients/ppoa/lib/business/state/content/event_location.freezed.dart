// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EventLocation _$EventLocationFromJson(Map<String, dynamic> json) {
  return _EventLocation.fromJson(json);
}

/// @nodoc
mixin _$EventLocation {
  double get eventLatitude => throw _privateConstructorUsedError;
  double get eventLongitude => throw _privateConstructorUsedError;
  String get locationFirstLine => throw _privateConstructorUsedError;
  String get locationCity => throw _privateConstructorUsedError;
  String get locationTown => throw _privateConstructorUsedError;
  String get locationCountry => throw _privateConstructorUsedError;
  String get locationZipCode => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventLocationCopyWith<EventLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventLocationCopyWith<$Res> {
  factory $EventLocationCopyWith(
          EventLocation value, $Res Function(EventLocation) then) =
      _$EventLocationCopyWithImpl<$Res, EventLocation>;
  @useResult
  $Res call(
      {double eventLatitude,
      double eventLongitude,
      String locationFirstLine,
      String locationCity,
      String locationTown,
      String locationCountry,
      String locationZipCode});
}

/// @nodoc
class _$EventLocationCopyWithImpl<$Res, $Val extends EventLocation>
    implements $EventLocationCopyWith<$Res> {
  _$EventLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventLatitude = null,
    Object? eventLongitude = null,
    Object? locationFirstLine = null,
    Object? locationCity = null,
    Object? locationTown = null,
    Object? locationCountry = null,
    Object? locationZipCode = null,
  }) {
    return _then(_value.copyWith(
      eventLatitude: null == eventLatitude
          ? _value.eventLatitude
          : eventLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      eventLongitude: null == eventLongitude
          ? _value.eventLongitude
          : eventLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      locationFirstLine: null == locationFirstLine
          ? _value.locationFirstLine
          : locationFirstLine // ignore: cast_nullable_to_non_nullable
              as String,
      locationCity: null == locationCity
          ? _value.locationCity
          : locationCity // ignore: cast_nullable_to_non_nullable
              as String,
      locationTown: null == locationTown
          ? _value.locationTown
          : locationTown // ignore: cast_nullable_to_non_nullable
              as String,
      locationCountry: null == locationCountry
          ? _value.locationCountry
          : locationCountry // ignore: cast_nullable_to_non_nullable
              as String,
      locationZipCode: null == locationZipCode
          ? _value.locationZipCode
          : locationZipCode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EventLocationCopyWith<$Res>
    implements $EventLocationCopyWith<$Res> {
  factory _$$_EventLocationCopyWith(
          _$_EventLocation value, $Res Function(_$_EventLocation) then) =
      __$$_EventLocationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double eventLatitude,
      double eventLongitude,
      String locationFirstLine,
      String locationCity,
      String locationTown,
      String locationCountry,
      String locationZipCode});
}

/// @nodoc
class __$$_EventLocationCopyWithImpl<$Res>
    extends _$EventLocationCopyWithImpl<$Res, _$_EventLocation>
    implements _$$_EventLocationCopyWith<$Res> {
  __$$_EventLocationCopyWithImpl(
      _$_EventLocation _value, $Res Function(_$_EventLocation) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventLatitude = null,
    Object? eventLongitude = null,
    Object? locationFirstLine = null,
    Object? locationCity = null,
    Object? locationTown = null,
    Object? locationCountry = null,
    Object? locationZipCode = null,
  }) {
    return _then(_$_EventLocation(
      eventLatitude: null == eventLatitude
          ? _value.eventLatitude
          : eventLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      eventLongitude: null == eventLongitude
          ? _value.eventLongitude
          : eventLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      locationFirstLine: null == locationFirstLine
          ? _value.locationFirstLine
          : locationFirstLine // ignore: cast_nullable_to_non_nullable
              as String,
      locationCity: null == locationCity
          ? _value.locationCity
          : locationCity // ignore: cast_nullable_to_non_nullable
              as String,
      locationTown: null == locationTown
          ? _value.locationTown
          : locationTown // ignore: cast_nullable_to_non_nullable
              as String,
      locationCountry: null == locationCountry
          ? _value.locationCountry
          : locationCountry // ignore: cast_nullable_to_non_nullable
              as String,
      locationZipCode: null == locationZipCode
          ? _value.locationZipCode
          : locationZipCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_EventLocation implements _EventLocation {
  const _$_EventLocation(
      {this.eventLatitude = double.nan,
      this.eventLongitude = double.nan,
      this.locationFirstLine = '',
      this.locationCity = '',
      this.locationTown = '',
      this.locationCountry = '',
      this.locationZipCode = ''});

  factory _$_EventLocation.fromJson(Map<String, dynamic> json) =>
      _$$_EventLocationFromJson(json);

  @override
  @JsonKey()
  final double eventLatitude;
  @override
  @JsonKey()
  final double eventLongitude;
  @override
  @JsonKey()
  final String locationFirstLine;
  @override
  @JsonKey()
  final String locationCity;
  @override
  @JsonKey()
  final String locationTown;
  @override
  @JsonKey()
  final String locationCountry;
  @override
  @JsonKey()
  final String locationZipCode;

  @override
  String toString() {
    return 'EventLocation(eventLatitude: $eventLatitude, eventLongitude: $eventLongitude, locationFirstLine: $locationFirstLine, locationCity: $locationCity, locationTown: $locationTown, locationCountry: $locationCountry, locationZipCode: $locationZipCode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventLocation &&
            (identical(other.eventLatitude, eventLatitude) ||
                other.eventLatitude == eventLatitude) &&
            (identical(other.eventLongitude, eventLongitude) ||
                other.eventLongitude == eventLongitude) &&
            (identical(other.locationFirstLine, locationFirstLine) ||
                other.locationFirstLine == locationFirstLine) &&
            (identical(other.locationCity, locationCity) ||
                other.locationCity == locationCity) &&
            (identical(other.locationTown, locationTown) ||
                other.locationTown == locationTown) &&
            (identical(other.locationCountry, locationCountry) ||
                other.locationCountry == locationCountry) &&
            (identical(other.locationZipCode, locationZipCode) ||
                other.locationZipCode == locationZipCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      eventLatitude,
      eventLongitude,
      locationFirstLine,
      locationCity,
      locationTown,
      locationCountry,
      locationZipCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EventLocationCopyWith<_$_EventLocation> get copyWith =>
      __$$_EventLocationCopyWithImpl<_$_EventLocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventLocationToJson(
      this,
    );
  }
}

abstract class _EventLocation implements EventLocation {
  const factory _EventLocation(
      {final double eventLatitude,
      final double eventLongitude,
      final String locationFirstLine,
      final String locationCity,
      final String locationTown,
      final String locationCountry,
      final String locationZipCode}) = _$_EventLocation;

  factory _EventLocation.fromJson(Map<String, dynamic> json) =
      _$_EventLocation.fromJson;

  @override
  double get eventLatitude;
  @override
  double get eventLongitude;
  @override
  String get locationFirstLine;
  @override
  String get locationCity;
  @override
  String get locationTown;
  @override
  String get locationCountry;
  @override
  String get locationZipCode;
  @override
  @JsonKey(ignore: true)
  _$$_EventLocationCopyWith<_$_EventLocation> get copyWith =>
      throw _privateConstructorUsedError;
}
