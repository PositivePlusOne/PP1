// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get fcmToken => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get birthday => throw _privateConstructorUsedError;
  String get accentColor => throw _privateConstructorUsedError;
  String get hivStatus => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get genders => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get interests => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get visibilityFlags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get featureFlags => throw _privateConstructorUsedError;
  int get connectionCount => throw _privateConstructorUsedError;
  bool get locationSkipped => throw _privateConstructorUsedError;
  ProfileGeoPoint? get location => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  @JsonKey(name: 'relationship')
  FlRelationship? get relationship => throw _privateConstructorUsedError;
  Object? get referenceImages =>
      throw _privateConstructorUsedError; //* This can be an unknown type, as we only use it as a flag for the current user.
  Object? get profileImages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String email,
      String phoneNumber,
      String locale,
      String fcmToken,
      String name,
      String displayName,
      String birthday,
      String accentColor,
      String hivStatus,
      @JsonKey(fromJson: stringSetFromJson) Set<String> genders,
      @JsonKey(fromJson: stringSetFromJson) Set<String> interests,
      @JsonKey(fromJson: stringSetFromJson) Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> featureFlags,
      int connectionCount,
      bool locationSkipped,
      ProfileGeoPoint? location,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'relationship') FlRelationship? relationship,
      Object? referenceImages,
      Object? profileImages});

  $ProfileGeoPointCopyWith<$Res>? get location;
  $FlMetaCopyWith<$Res>? get flMeta;
  $FlRelationshipCopyWith<$Res>? get relationship;
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? locale = null,
    Object? fcmToken = null,
    Object? name = null,
    Object? displayName = null,
    Object? birthday = null,
    Object? accentColor = null,
    Object? hivStatus = null,
    Object? genders = null,
    Object? interests = null,
    Object? visibilityFlags = null,
    Object? featureFlags = null,
    Object? connectionCount = null,
    Object? locationSkipped = null,
    Object? location = freezed,
    Object? flMeta = freezed,
    Object? relationship = freezed,
    Object? referenceImages = freezed,
    Object? profileImages = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: null == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String,
      hivStatus: null == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String,
      genders: null == genders
          ? _value.genders
          : genders // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      visibilityFlags: null == visibilityFlags
          ? _value.visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      featureFlags: null == featureFlags
          ? _value.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connectionCount: null == connectionCount
          ? _value.connectionCount
          : connectionCount // ignore: cast_nullable_to_non_nullable
              as int,
      locationSkipped: null == locationSkipped
          ? _value.locationSkipped
          : locationSkipped // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as ProfileGeoPoint?,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as FlRelationship?,
      referenceImages:
          freezed == referenceImages ? _value.referenceImages : referenceImages,
      profileImages:
          freezed == profileImages ? _value.profileImages : profileImages,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileGeoPointCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $ProfileGeoPointCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $FlRelationshipCopyWith<$Res>? get relationship {
    if (_value.relationship == null) {
      return null;
    }

    return $FlRelationshipCopyWith<$Res>(_value.relationship!, (value) {
      return _then(_value.copyWith(relationship: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$_UserProfileCopyWith(
          _$_UserProfile value, $Res Function(_$_UserProfile) then) =
      __$$_UserProfileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String phoneNumber,
      String locale,
      String fcmToken,
      String name,
      String displayName,
      String birthday,
      String accentColor,
      String hivStatus,
      @JsonKey(fromJson: stringSetFromJson) Set<String> genders,
      @JsonKey(fromJson: stringSetFromJson) Set<String> interests,
      @JsonKey(fromJson: stringSetFromJson) Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> featureFlags,
      int connectionCount,
      bool locationSkipped,
      ProfileGeoPoint? location,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'relationship') FlRelationship? relationship,
      Object? referenceImages,
      Object? profileImages});

  @override
  $ProfileGeoPointCopyWith<$Res>? get location;
  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $FlRelationshipCopyWith<$Res>? get relationship;
}

/// @nodoc
class __$$_UserProfileCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$_UserProfile>
    implements _$$_UserProfileCopyWith<$Res> {
  __$$_UserProfileCopyWithImpl(
      _$_UserProfile _value, $Res Function(_$_UserProfile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? locale = null,
    Object? fcmToken = null,
    Object? name = null,
    Object? displayName = null,
    Object? birthday = null,
    Object? accentColor = null,
    Object? hivStatus = null,
    Object? genders = null,
    Object? interests = null,
    Object? visibilityFlags = null,
    Object? featureFlags = null,
    Object? connectionCount = null,
    Object? locationSkipped = null,
    Object? location = freezed,
    Object? flMeta = freezed,
    Object? relationship = freezed,
    Object? referenceImages = freezed,
    Object? profileImages = freezed,
  }) {
    return _then(_$_UserProfile(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      birthday: null == birthday
          ? _value.birthday
          : birthday // ignore: cast_nullable_to_non_nullable
              as String,
      accentColor: null == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
              as String,
      hivStatus: null == hivStatus
          ? _value.hivStatus
          : hivStatus // ignore: cast_nullable_to_non_nullable
              as String,
      genders: null == genders
          ? _value._genders
          : genders // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      visibilityFlags: null == visibilityFlags
          ? _value._visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      featureFlags: null == featureFlags
          ? _value._featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connectionCount: null == connectionCount
          ? _value.connectionCount
          : connectionCount // ignore: cast_nullable_to_non_nullable
              as int,
      locationSkipped: null == locationSkipped
          ? _value.locationSkipped
          : locationSkipped // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as ProfileGeoPoint?,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as FlRelationship?,
      referenceImages:
          freezed == referenceImages ? _value.referenceImages : referenceImages,
      profileImages:
          freezed == profileImages ? _value.profileImages : profileImages,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserProfile implements _UserProfile {
  const _$_UserProfile(
      {this.id = '',
      this.email = '',
      this.phoneNumber = '',
      this.locale = 'en-GB',
      this.fcmToken = '',
      this.name = '',
      this.displayName = '',
      this.birthday = '',
      this.accentColor = '',
      this.hivStatus = '',
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> genders = const {},
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> interests = const {},
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> visibilityFlags = const {},
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> featureFlags = const {},
      this.connectionCount = 0,
      this.locationSkipped = false,
      this.location,
      @JsonKey(name: '_fl_meta_')
          this.flMeta,
      @JsonKey(name: 'relationship')
          this.relationship,
      this.referenceImages,
      this.profileImages})
      : _genders = genders,
        _interests = interests,
        _visibilityFlags = visibilityFlags,
        _featureFlags = featureFlags;

  factory _$_UserProfile.fromJson(Map<String, dynamic> json) =>
      _$$_UserProfileFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey()
  final String fcmToken;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String birthday;
  @override
  @JsonKey()
  final String accentColor;
  @override
  @JsonKey()
  final String hivStatus;
  final Set<String> _genders;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get genders {
    if (_genders is EqualUnmodifiableSetView) return _genders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_genders);
  }

  final Set<String> _interests;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get interests {
    if (_interests is EqualUnmodifiableSetView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_interests);
  }

  final Set<String> _visibilityFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get visibilityFlags {
    if (_visibilityFlags is EqualUnmodifiableSetView) return _visibilityFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_visibilityFlags);
  }

  final Set<String> _featureFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get featureFlags {
    if (_featureFlags is EqualUnmodifiableSetView) return _featureFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_featureFlags);
  }

  @override
  @JsonKey()
  final int connectionCount;
  @override
  @JsonKey()
  final bool locationSkipped;
  @override
  final ProfileGeoPoint? location;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey(name: 'relationship')
  final FlRelationship? relationship;
  @override
  final Object? referenceImages;
//* This can be an unknown type, as we only use it as a flag for the current user.
  @override
  final Object? profileImages;

  @override
  String toString() {
    return 'UserProfile(id: $id, email: $email, phoneNumber: $phoneNumber, locale: $locale, fcmToken: $fcmToken, name: $name, displayName: $displayName, birthday: $birthday, accentColor: $accentColor, hivStatus: $hivStatus, genders: $genders, interests: $interests, visibilityFlags: $visibilityFlags, featureFlags: $featureFlags, connectionCount: $connectionCount, locationSkipped: $locationSkipped, location: $location, flMeta: $flMeta, relationship: $relationship, referenceImages: $referenceImages, profileImages: $profileImages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.birthday, birthday) ||
                other.birthday == birthday) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.hivStatus, hivStatus) ||
                other.hivStatus == hivStatus) &&
            const DeepCollectionEquality().equals(other._genders, _genders) &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests) &&
            const DeepCollectionEquality()
                .equals(other._visibilityFlags, _visibilityFlags) &&
            const DeepCollectionEquality()
                .equals(other._featureFlags, _featureFlags) &&
            (identical(other.connectionCount, connectionCount) ||
                other.connectionCount == connectionCount) &&
            (identical(other.locationSkipped, locationSkipped) ||
                other.locationSkipped == locationSkipped) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            const DeepCollectionEquality()
                .equals(other.referenceImages, referenceImages) &&
            const DeepCollectionEquality()
                .equals(other.profileImages, profileImages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        email,
        phoneNumber,
        locale,
        fcmToken,
        name,
        displayName,
        birthday,
        accentColor,
        hivStatus,
        const DeepCollectionEquality().hash(_genders),
        const DeepCollectionEquality().hash(_interests),
        const DeepCollectionEquality().hash(_visibilityFlags),
        const DeepCollectionEquality().hash(_featureFlags),
        connectionCount,
        locationSkipped,
        location,
        flMeta,
        relationship,
        const DeepCollectionEquality().hash(referenceImages),
        const DeepCollectionEquality().hash(profileImages)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      __$$_UserProfileCopyWithImpl<_$_UserProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserProfileToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {final String id,
      final String email,
      final String phoneNumber,
      final String locale,
      final String fcmToken,
      final String name,
      final String displayName,
      final String birthday,
      final String accentColor,
      final String hivStatus,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> genders,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> interests,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> featureFlags,
      final int connectionCount,
      final bool locationSkipped,
      final ProfileGeoPoint? location,
      @JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      @JsonKey(name: 'relationship') final FlRelationship? relationship,
      final Object? referenceImages,
      final Object? profileImages}) = _$_UserProfile;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$_UserProfile.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  String get locale;
  @override
  String get fcmToken;
  @override
  String get name;
  @override
  String get displayName;
  @override
  String get birthday;
  @override
  String get accentColor;
  @override
  String get hivStatus;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get genders;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get interests;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get visibilityFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get featureFlags;
  @override
  int get connectionCount;
  @override
  bool get locationSkipped;
  @override
  ProfileGeoPoint? get location;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(name: 'relationship')
  FlRelationship? get relationship;
  @override
  Object? get referenceImages;
  @override //* This can be an unknown type, as we only use it as a flag for the current user.
  Object? get profileImages;
  @override
  @JsonKey(ignore: true)
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileGeoPoint _$ProfileGeoPointFromJson(Map<String, dynamic> json) {
  return _ProfileGeoPoint.fromJson(json);
}

/// @nodoc
mixin _$ProfileGeoPoint {
  @JsonKey(name: "latitude")
  double get latitude => throw _privateConstructorUsedError;
  @JsonKey(name: "longitude")
  double get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileGeoPointCopyWith<ProfileGeoPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileGeoPointCopyWith<$Res> {
  factory $ProfileGeoPointCopyWith(
          ProfileGeoPoint value, $Res Function(ProfileGeoPoint) then) =
      _$ProfileGeoPointCopyWithImpl<$Res, ProfileGeoPoint>;
  @useResult
  $Res call(
      {@JsonKey(name: "latitude") double latitude,
      @JsonKey(name: "longitude") double longitude});
}

/// @nodoc
class _$ProfileGeoPointCopyWithImpl<$Res, $Val extends ProfileGeoPoint>
    implements $ProfileGeoPointCopyWith<$Res> {
  _$ProfileGeoPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileGeoPointCopyWith<$Res>
    implements $ProfileGeoPointCopyWith<$Res> {
  factory _$$_ProfileGeoPointCopyWith(
          _$_ProfileGeoPoint value, $Res Function(_$_ProfileGeoPoint) then) =
      __$$_ProfileGeoPointCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "latitude") double latitude,
      @JsonKey(name: "longitude") double longitude});
}

/// @nodoc
class __$$_ProfileGeoPointCopyWithImpl<$Res>
    extends _$ProfileGeoPointCopyWithImpl<$Res, _$_ProfileGeoPoint>
    implements _$$_ProfileGeoPointCopyWith<$Res> {
  __$$_ProfileGeoPointCopyWithImpl(
      _$_ProfileGeoPoint _value, $Res Function(_$_ProfileGeoPoint) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$_ProfileGeoPoint(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProfileGeoPoint implements _ProfileGeoPoint {
  const _$_ProfileGeoPoint(
      {@JsonKey(name: "latitude") required this.latitude,
      @JsonKey(name: "longitude") required this.longitude});

  factory _$_ProfileGeoPoint.fromJson(Map<String, dynamic> json) =>
      _$$_ProfileGeoPointFromJson(json);

  @override
  @JsonKey(name: "latitude")
  final double latitude;
  @override
  @JsonKey(name: "longitude")
  final double longitude;

  @override
  String toString() {
    return 'ProfileGeoPoint(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileGeoPoint &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileGeoPointCopyWith<_$_ProfileGeoPoint> get copyWith =>
      __$$_ProfileGeoPointCopyWithImpl<_$_ProfileGeoPoint>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProfileGeoPointToJson(
      this,
    );
  }
}

abstract class _ProfileGeoPoint implements ProfileGeoPoint {
  const factory _ProfileGeoPoint(
          {@JsonKey(name: "latitude") required final double latitude,
          @JsonKey(name: "longitude") required final double longitude}) =
      _$_ProfileGeoPoint;

  factory _ProfileGeoPoint.fromJson(Map<String, dynamic> json) =
      _$_ProfileGeoPoint.fromJson;

  @override
  @JsonKey(name: "latitude")
  double get latitude;
  @override
  @JsonKey(name: "longitude")
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileGeoPointCopyWith<_$_ProfileGeoPoint> get copyWith =>
      throw _privateConstructorUsedError;
}
