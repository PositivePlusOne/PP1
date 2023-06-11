// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String get id =>
      throw _privateConstructorUsedError; //! You should not use this, instead use the uid from flMeta
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
  bool get locationSkipped => throw _privateConstructorUsedError;
  @JsonKey(fromJson: UserLocation.fromJsonSafe)
  UserLocation? get location => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get referenceImage => throw _privateConstructorUsedError;
  String get profileImage => throw _privateConstructorUsedError;
  String get biography => throw _privateConstructorUsedError;
  ProfileAnalytics? get analytics => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res, Profile>;
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
      bool locationSkipped,
      @JsonKey(fromJson: UserLocation.fromJsonSafe) UserLocation? location,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String referenceImage,
      String profileImage,
      String biography,
      ProfileAnalytics? analytics});

  $UserLocationCopyWith<$Res>? get location;
  $FlMetaCopyWith<$Res>? get flMeta;
  $ProfileAnalyticsCopyWith<$Res>? get analytics;
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res, $Val extends Profile>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

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
    Object? locationSkipped = null,
    Object? location = freezed,
    Object? flMeta = freezed,
    Object? referenceImage = null,
    Object? profileImage = null,
    Object? biography = null,
    Object? analytics = freezed,
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
      locationSkipped: null == locationSkipped
          ? _value.locationSkipped
          : locationSkipped // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation?,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      referenceImage: null == referenceImage
          ? _value.referenceImage
          : referenceImage // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: null == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      biography: null == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String,
      analytics: freezed == analytics
          ? _value.analytics
          : analytics // ignore: cast_nullable_to_non_nullable
              as ProfileAnalytics?,
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
  $ProfileAnalyticsCopyWith<$Res>? get analytics {
    if (_value.analytics == null) {
      return null;
    }

    return $ProfileAnalyticsCopyWith<$Res>(_value.analytics!, (value) {
      return _then(_value.copyWith(analytics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$_ProfileCopyWith(
          _$_Profile value, $Res Function(_$_Profile) then) =
      __$$_ProfileCopyWithImpl<$Res>;
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
      bool locationSkipped,
      @JsonKey(fromJson: UserLocation.fromJsonSafe) UserLocation? location,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String referenceImage,
      String profileImage,
      String biography,
      ProfileAnalytics? analytics});

  @override
  $UserLocationCopyWith<$Res>? get location;
  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $ProfileAnalyticsCopyWith<$Res>? get analytics;
}

/// @nodoc
class __$$_ProfileCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$_Profile>
    implements _$$_ProfileCopyWith<$Res> {
  __$$_ProfileCopyWithImpl(_$_Profile _value, $Res Function(_$_Profile) _then)
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
    Object? locationSkipped = null,
    Object? location = freezed,
    Object? flMeta = freezed,
    Object? referenceImage = null,
    Object? profileImage = null,
    Object? biography = null,
    Object? analytics = freezed,
  }) {
    return _then(_$_Profile(
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
      locationSkipped: null == locationSkipped
          ? _value.locationSkipped
          : locationSkipped // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as UserLocation?,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      referenceImage: null == referenceImage
          ? _value.referenceImage
          : referenceImage // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: null == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String,
      biography: null == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String,
      analytics: freezed == analytics
          ? _value.analytics
          : analytics // ignore: cast_nullable_to_non_nullable
              as ProfileAnalytics?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Profile implements _Profile {
  const _$_Profile(
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
      this.locationSkipped = false,
      @JsonKey(fromJson: UserLocation.fromJsonSafe)
          this.location,
      @JsonKey(name: '_fl_meta_')
          this.flMeta,
      this.referenceImage = '',
      this.profileImage = '',
      this.biography = '',
      this.analytics})
      : _genders = genders,
        _interests = interests,
        _visibilityFlags = visibilityFlags,
        _featureFlags = featureFlags;

  factory _$_Profile.fromJson(Map<String, dynamic> json) =>
      _$$_ProfileFromJson(json);

  @override
  @JsonKey()
  final String id;
//! You should not use this, instead use the uid from flMeta
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
  final bool locationSkipped;
  @override
  @JsonKey(fromJson: UserLocation.fromJsonSafe)
  final UserLocation? location;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String referenceImage;
  @override
  @JsonKey()
  final String profileImage;
  @override
  @JsonKey()
  final String biography;
  @override
  final ProfileAnalytics? analytics;

  @override
  String toString() {
    return 'Profile(id: $id, email: $email, phoneNumber: $phoneNumber, locale: $locale, fcmToken: $fcmToken, name: $name, displayName: $displayName, birthday: $birthday, accentColor: $accentColor, hivStatus: $hivStatus, genders: $genders, interests: $interests, visibilityFlags: $visibilityFlags, featureFlags: $featureFlags, locationSkipped: $locationSkipped, location: $location, flMeta: $flMeta, referenceImage: $referenceImage, profileImage: $profileImage, biography: $biography, analytics: $analytics)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Profile &&
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
            (identical(other.locationSkipped, locationSkipped) ||
                other.locationSkipped == locationSkipped) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.referenceImage, referenceImage) ||
                other.referenceImage == referenceImage) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.biography, biography) ||
                other.biography == biography) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics));
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
        locationSkipped,
        location,
        flMeta,
        referenceImage,
        profileImage,
        biography,
        analytics
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileCopyWith<_$_Profile> get copyWith =>
      __$$_ProfileCopyWithImpl<_$_Profile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProfileToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
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
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> genders,
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> interests,
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson)
          final Set<String> featureFlags,
      final bool locationSkipped,
      @JsonKey(fromJson: UserLocation.fromJsonSafe)
          final UserLocation? location,
      @JsonKey(name: '_fl_meta_')
          final FlMeta? flMeta,
      final String referenceImage,
      final String profileImage,
      final String biography,
      final ProfileAnalytics? analytics}) = _$_Profile;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$_Profile.fromJson;

  @override
  String get id;
  @override //! You should not use this, instead use the uid from flMeta
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
  bool get locationSkipped;
  @override
  @JsonKey(fromJson: UserLocation.fromJsonSafe)
  UserLocation? get location;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get referenceImage;
  @override
  String get profileImage;
  @override
  String get biography;
  @override
  ProfileAnalytics? get analytics;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileCopyWith<_$_Profile> get copyWith =>
      throw _privateConstructorUsedError;
}

ProfileAnalytics _$ProfileAnalyticsFromJson(Map<String, dynamic> json) {
  return _ProfileAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ProfileAnalytics {
  int get connectionCount => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get postCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileAnalyticsCopyWith<ProfileAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileAnalyticsCopyWith<$Res> {
  factory $ProfileAnalyticsCopyWith(
          ProfileAnalytics value, $Res Function(ProfileAnalytics) then) =
      _$ProfileAnalyticsCopyWithImpl<$Res, ProfileAnalytics>;
  @useResult
  $Res call({int connectionCount, int followerCount, int postCount});
}

/// @nodoc
class _$ProfileAnalyticsCopyWithImpl<$Res, $Val extends ProfileAnalytics>
    implements $ProfileAnalyticsCopyWith<$Res> {
  _$ProfileAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionCount = null,
    Object? followerCount = null,
    Object? postCount = null,
  }) {
    return _then(_value.copyWith(
      connectionCount: null == connectionCount
          ? _value.connectionCount
          : connectionCount // ignore: cast_nullable_to_non_nullable
              as int,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      postCount: null == postCount
          ? _value.postCount
          : postCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileAnalyticsCopyWith<$Res>
    implements $ProfileAnalyticsCopyWith<$Res> {
  factory _$$_ProfileAnalyticsCopyWith(
          _$_ProfileAnalytics value, $Res Function(_$_ProfileAnalytics) then) =
      __$$_ProfileAnalyticsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int connectionCount, int followerCount, int postCount});
}

/// @nodoc
class __$$_ProfileAnalyticsCopyWithImpl<$Res>
    extends _$ProfileAnalyticsCopyWithImpl<$Res, _$_ProfileAnalytics>
    implements _$$_ProfileAnalyticsCopyWith<$Res> {
  __$$_ProfileAnalyticsCopyWithImpl(
      _$_ProfileAnalytics _value, $Res Function(_$_ProfileAnalytics) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionCount = null,
    Object? followerCount = null,
    Object? postCount = null,
  }) {
    return _then(_$_ProfileAnalytics(
      connectionCount: null == connectionCount
          ? _value.connectionCount
          : connectionCount // ignore: cast_nullable_to_non_nullable
              as int,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      postCount: null == postCount
          ? _value.postCount
          : postCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ProfileAnalytics implements _ProfileAnalytics {
  const _$_ProfileAnalytics(
      {this.connectionCount = 0, this.followerCount = 0, this.postCount = 0});

  factory _$_ProfileAnalytics.fromJson(Map<String, dynamic> json) =>
      _$$_ProfileAnalyticsFromJson(json);

  @override
  @JsonKey()
  final int connectionCount;
  @override
  @JsonKey()
  final int followerCount;
  @override
  @JsonKey()
  final int postCount;

  @override
  String toString() {
    return 'ProfileAnalytics(connectionCount: $connectionCount, followerCount: $followerCount, postCount: $postCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileAnalytics &&
            (identical(other.connectionCount, connectionCount) ||
                other.connectionCount == connectionCount) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.postCount, postCount) ||
                other.postCount == postCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, connectionCount, followerCount, postCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileAnalyticsCopyWith<_$_ProfileAnalytics> get copyWith =>
      __$$_ProfileAnalyticsCopyWithImpl<_$_ProfileAnalytics>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProfileAnalyticsToJson(
      this,
    );
  }
}

abstract class _ProfileAnalytics implements ProfileAnalytics {
  const factory _ProfileAnalytics(
      {final int connectionCount,
      final int followerCount,
      final int postCount}) = _$_ProfileAnalytics;

  factory _ProfileAnalytics.fromJson(Map<String, dynamic> json) =
      _$_ProfileAnalytics.fromJson;

  @override
  int get connectionCount;
  @override
  int get followerCount;
  @override
  int get postCount;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileAnalyticsCopyWith<_$_ProfileAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}
