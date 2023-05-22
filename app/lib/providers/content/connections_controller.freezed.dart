// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connections_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ConnectedUser _$ConnectedUserFromJson(Map<String, dynamic> json) {
  return _ConnectedUser.fromJson(json);
}

/// @nodoc
mixin _$ConnectedUser {
  String get displayName => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  String? get accentColor => throw _privateConstructorUsedError;
  @JsonKey(fromJson: UserLocation.fromJsonSafe)
  UserLocation? get location => throw _privateConstructorUsedError;
  String? get locationName => throw _privateConstructorUsedError;
  String? get hivStatus => throw _privateConstructorUsedError;
  List<String>? get interests => throw _privateConstructorUsedError;
  List<String>? get genders => throw _privateConstructorUsedError;
  String? get birthday => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConnectedUserCopyWith<ConnectedUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectedUserCopyWith<$Res> {
  factory $ConnectedUserCopyWith(
          ConnectedUser value, $Res Function(ConnectedUser) then) =
      _$ConnectedUserCopyWithImpl<$Res, ConnectedUser>;
  @useResult
  $Res call(
      {String displayName,
      String? profileImage,
      String? accentColor,
      @JsonKey(fromJson: UserLocation.fromJsonSafe) UserLocation? location,
      String? locationName,
      String? hivStatus,
      List<String>? interests,
      List<String>? genders,
      String? birthday});

  $UserLocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$ConnectedUserCopyWithImpl<$Res, $Val extends ConnectedUser>
    implements $ConnectedUserCopyWith<$Res> {
  _$ConnectedUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? profileImage = freezed,
    Object? accentColor = freezed,
    Object? location = freezed,
    Object? locationName = freezed,
    Object? hivStatus = freezed,
    Object? interests = freezed,
    Object? genders = freezed,
    Object? birthday = freezed,
  }) {
    return _then(_value.copyWith(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      hivStatus: freezed == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: freezed == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      genders: freezed == genders
          ? _value.genders
          : genders // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserLocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $UserLocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ConnectedUserCopyWith<$Res>
    implements $ConnectedUserCopyWith<$Res> {
  factory _$$_ConnectedUserCopyWith(
          _$_ConnectedUser value, $Res Function(_$_ConnectedUser) then) =
      __$$_ConnectedUserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String displayName,
      String? profileImage,
      String? accentColor,
      @JsonKey(fromJson: UserLocation.fromJsonSafe) UserLocation? location,
      String? locationName,
      String? hivStatus,
      List<String>? interests,
      List<String>? genders,
      String? birthday});

  @override
  $UserLocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$_ConnectedUserCopyWithImpl<$Res>
    extends _$ConnectedUserCopyWithImpl<$Res, _$_ConnectedUser>
    implements _$$_ConnectedUserCopyWith<$Res> {
  __$$_ConnectedUserCopyWithImpl(
      _$_ConnectedUser _value, $Res Function(_$_ConnectedUser) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayName = null,
    Object? profileImage = freezed,
    Object? accentColor = freezed,
    Object? location = freezed,
    Object? locationName = freezed,
    Object? hivStatus = freezed,
    Object? interests = freezed,
    Object? genders = freezed,
    Object? birthday = freezed,
  }) {
    return _then(_$_ConnectedUser(
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      hivStatus: freezed == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      interests: freezed == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      genders: freezed == genders
          ? _value._genders
          : genders // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      birthday: freezed == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConnectedUser implements _ConnectedUser {
  const _$_ConnectedUser(
      {required this.displayName,
      this.profileImage,
      this.accentColor,
      @JsonKey(fromJson: UserLocation.fromJsonSafe) this.location,
      this.locationName,
      this.hivStatus,
      final List<String>? interests,
      final List<String>? genders,
      this.birthday})
      : _interests = interests,
        _genders = genders;

  factory _$_ConnectedUser.fromJson(Map<String, dynamic> json) =>
      _$$_ConnectedUserFromJson(json);

  @override
  final String displayName;
  @override
  final String? profileImage;
  @override
  final String? accentColor;
  @override
  @JsonKey(fromJson: UserLocation.fromJsonSafe)
  final UserLocation? location;
  @override
  final String? locationName;
  @override
  final String? hivStatus;
  final List<String>? _interests;
  @override
  List<String>? get interests {
    final value = _interests;
    if (value == null) return null;
    if (_interests is EqualUnmodifiableListView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _genders;
  @override
  List<String>? get genders {
    final value = _genders;
    if (value == null) return null;
    if (_genders is EqualUnmodifiableListView) return _genders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? birthday;

  @override
  String toString() {
    return 'ConnectedUser(displayName: $displayName, profileImage: $profileImage, accentColor: $accentColor, location: $location, locationName: $locationName, hivStatus: $hivStatus, interests: $interests, genders: $genders, birthday: $birthday)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConnectedUser &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.hivStatus, hivStatus) ||
                other.hivStatus == hivStatus) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality().equals(other._genders, _genders) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      displayName,
      profileImage,
      accentColor,
      location,
      locationName,
      hivStatus,
      const DeepCollectionEquality().hash(_interests),
      const DeepCollectionEquality().hash(_genders),
      birthday);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConnectedUserCopyWith<_$_ConnectedUser> get copyWith =>
      __$$_ConnectedUserCopyWithImpl<_$_ConnectedUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConnectedUserToJson(
      this,
    );
  }
}

abstract class _ConnectedUser implements ConnectedUser {
  const factory _ConnectedUser(
      {required final String displayName,
      final String? profileImage,
      final String? accentColor,
      @JsonKey(fromJson: UserLocation.fromJsonSafe)
          final UserLocation? location,
      final String? locationName,
      final String? hivStatus,
      final List<String>? interests,
      final List<String>? genders,
      final String? birthday}) = _$_ConnectedUser;

  factory _ConnectedUser.fromJson(Map<String, dynamic> json) =
      _$_ConnectedUser.fromJson;

  @override
  String get displayName;
  @override
  String? get profileImage;
  @override
  String? get accentColor;
  @override
  @JsonKey(fromJson: UserLocation.fromJsonSafe)
  UserLocation? get location;
  @override
  String? get locationName;
  @override
  String? get hivStatus;
  @override
  List<String>? get interests;
  @override
  List<String>? get genders;
  @override
  String? get birthday;
  @override
  @JsonKey(ignore: true)
  _$$_ConnectedUserCopyWith<_$_ConnectedUser> get copyWith =>
      throw _privateConstructorUsedError;
}
