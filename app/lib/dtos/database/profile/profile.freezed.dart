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
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
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
  Set<String> get tags => throw _privateConstructorUsedError;
  bool get placeSkipped => throw _privateConstructorUsedError;
  bool get suppressEmailNotifications => throw _privateConstructorUsedError;
  PositivePlace? get place => throw _privateConstructorUsedError;
  String get biography => throw _privateConstructorUsedError;
  List<Media> get media => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get accountFlags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get visibilityFlags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get featureFlags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get companySectors => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: ProfileCompanySize.fromJson,
      toJson: ProfileCompanySize.toJson,
      name: 'companySize')
  ProfileCompanySize get companySize => throw _privateConstructorUsedError;
  int get availablePromotionsCount => throw _privateConstructorUsedError;
  int get activePromotionsCount => throw _privateConstructorUsedError;

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
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
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
      @JsonKey(fromJson: stringSetFromJson) Set<String> tags,
      bool placeSkipped,
      bool suppressEmailNotifications,
      PositivePlace? place,
      String biography,
      List<Media> media,
      @JsonKey(fromJson: stringSetFromJson) Set<String> accountFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> featureFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> companySectors,
      @JsonKey(
          fromJson: ProfileCompanySize.fromJson,
          toJson: ProfileCompanySize.toJson,
          name: 'companySize')
      ProfileCompanySize companySize,
      int availablePromotionsCount,
      int activePromotionsCount});

  $FlMetaCopyWith<$Res>? get flMeta;
  $PositivePlaceCopyWith<$Res>? get place;
  $ProfileCompanySizeCopyWith<$Res> get companySize;
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
    Object? flMeta = freezed,
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
    Object? tags = null,
    Object? placeSkipped = null,
    Object? suppressEmailNotifications = null,
    Object? place = freezed,
    Object? biography = null,
    Object? media = null,
    Object? accountFlags = null,
    Object? visibilityFlags = null,
    Object? featureFlags = null,
    Object? companySectors = null,
    Object? companySize = null,
    Object? availablePromotionsCount = null,
    Object? activePromotionsCount = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
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
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      placeSkipped: null == placeSkipped
          ? _value.placeSkipped
          : placeSkipped // ignore: cast_nullable_to_non_nullable
              as bool,
      suppressEmailNotifications: null == suppressEmailNotifications
          ? _value.suppressEmailNotifications
          : suppressEmailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      biography: null == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
      accountFlags: null == accountFlags
          ? _value.accountFlags
          : accountFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      visibilityFlags: null == visibilityFlags
          ? _value.visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      featureFlags: null == featureFlags
          ? _value.featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      companySectors: null == companySectors
          ? _value.companySectors
          : companySectors // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      companySize: null == companySize
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as ProfileCompanySize,
      availablePromotionsCount: null == availablePromotionsCount
          ? _value.availablePromotionsCount
          : availablePromotionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      activePromotionsCount: null == activePromotionsCount
          ? _value.activePromotionsCount
          : activePromotionsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
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
  $PositivePlaceCopyWith<$Res>? get place {
    if (_value.place == null) {
      return null;
    }

    return $PositivePlaceCopyWith<$Res>(_value.place!, (value) {
      return _then(_value.copyWith(place: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCompanySizeCopyWith<$Res> get companySize {
    return $ProfileCompanySizeCopyWith<$Res>(_value.companySize, (value) {
      return _then(_value.copyWith(companySize: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileImplCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$ProfileImplCopyWith(
          _$ProfileImpl value, $Res Function(_$ProfileImpl) then) =
      __$$ProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
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
      @JsonKey(fromJson: stringSetFromJson) Set<String> tags,
      bool placeSkipped,
      bool suppressEmailNotifications,
      PositivePlace? place,
      String biography,
      List<Media> media,
      @JsonKey(fromJson: stringSetFromJson) Set<String> accountFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> featureFlags,
      @JsonKey(fromJson: stringSetFromJson) Set<String> companySectors,
      @JsonKey(
          fromJson: ProfileCompanySize.fromJson,
          toJson: ProfileCompanySize.toJson,
          name: 'companySize')
      ProfileCompanySize companySize,
      int availablePromotionsCount,
      int activePromotionsCount});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $PositivePlaceCopyWith<$Res>? get place;
  @override
  $ProfileCompanySizeCopyWith<$Res> get companySize;
}

/// @nodoc
class __$$ProfileImplCopyWithImpl<$Res>
    extends _$ProfileCopyWithImpl<$Res, _$ProfileImpl>
    implements _$$ProfileImplCopyWith<$Res> {
  __$$ProfileImplCopyWithImpl(
      _$ProfileImpl _value, $Res Function(_$ProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
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
    Object? tags = null,
    Object? placeSkipped = null,
    Object? suppressEmailNotifications = null,
    Object? place = freezed,
    Object? biography = null,
    Object? media = null,
    Object? accountFlags = null,
    Object? visibilityFlags = null,
    Object? featureFlags = null,
    Object? companySectors = null,
    Object? companySize = null,
    Object? availablePromotionsCount = null,
    Object? activePromotionsCount = null,
  }) {
    return _then(_$ProfileImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
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
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      placeSkipped: null == placeSkipped
          ? _value.placeSkipped
          : placeSkipped // ignore: cast_nullable_to_non_nullable
              as bool,
      suppressEmailNotifications: null == suppressEmailNotifications
          ? _value.suppressEmailNotifications
          : suppressEmailNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      biography: null == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
      accountFlags: null == accountFlags
          ? _value._accountFlags
          : accountFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      visibilityFlags: null == visibilityFlags
          ? _value._visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      featureFlags: null == featureFlags
          ? _value._featureFlags
          : featureFlags // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      companySectors: null == companySectors
          ? _value._companySectors
          : companySectors // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      companySize: null == companySize
          ? _value.companySize
          : companySize // ignore: cast_nullable_to_non_nullable
              as ProfileCompanySize,
      availablePromotionsCount: null == availablePromotionsCount
          ? _value.availablePromotionsCount
          : availablePromotionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      activePromotionsCount: null == activePromotionsCount
          ? _value.activePromotionsCount
          : activePromotionsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileImpl implements _Profile {
  const _$ProfileImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
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
      @JsonKey(fromJson: stringSetFromJson) final Set<String> tags = const {},
      this.placeSkipped = false,
      this.suppressEmailNotifications = false,
      this.place,
      this.biography = '',
      final List<Media> media = const [],
      @JsonKey(fromJson: stringSetFromJson)
      final Set<String> accountFlags = const {},
      @JsonKey(fromJson: stringSetFromJson)
      final Set<String> visibilityFlags = const {},
      @JsonKey(fromJson: stringSetFromJson)
      final Set<String> featureFlags = const {},
      @JsonKey(fromJson: stringSetFromJson)
      final Set<String> companySectors = const {},
      @JsonKey(
          fromJson: ProfileCompanySize.fromJson,
          toJson: ProfileCompanySize.toJson,
          name: 'companySize')
      this.companySize = const ProfileCompanySize.unknown(),
      this.availablePromotionsCount = 0,
      this.activePromotionsCount = 0})
      : _genders = genders,
        _interests = interests,
        _tags = tags,
        _media = media,
        _accountFlags = accountFlags,
        _visibilityFlags = visibilityFlags,
        _featureFlags = featureFlags,
        _companySectors = companySectors;

  factory _$ProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
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

  final Set<String> _tags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get tags {
    if (_tags is EqualUnmodifiableSetView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_tags);
  }

  @override
  @JsonKey()
  final bool placeSkipped;
  @override
  @JsonKey()
  final bool suppressEmailNotifications;
  @override
  final PositivePlace? place;
  @override
  @JsonKey()
  final String biography;
  final List<Media> _media;
  @override
  @JsonKey()
  List<Media> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final Set<String> _accountFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get accountFlags {
    if (_accountFlags is EqualUnmodifiableSetView) return _accountFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_accountFlags);
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

  final Set<String> _companySectors;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get companySectors {
    if (_companySectors is EqualUnmodifiableSetView) return _companySectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_companySectors);
  }

  @override
  @JsonKey(
      fromJson: ProfileCompanySize.fromJson,
      toJson: ProfileCompanySize.toJson,
      name: 'companySize')
  final ProfileCompanySize companySize;
  @override
  @JsonKey()
  final int availablePromotionsCount;
  @override
  @JsonKey()
  final int activePromotionsCount;

  @override
  String toString() {
    return 'Profile(flMeta: $flMeta, email: $email, phoneNumber: $phoneNumber, locale: $locale, fcmToken: $fcmToken, name: $name, displayName: $displayName, birthday: $birthday, accentColor: $accentColor, hivStatus: $hivStatus, genders: $genders, interests: $interests, tags: $tags, placeSkipped: $placeSkipped, suppressEmailNotifications: $suppressEmailNotifications, place: $place, biography: $biography, media: $media, accountFlags: $accountFlags, visibilityFlags: $visibilityFlags, featureFlags: $featureFlags, companySectors: $companySectors, companySize: $companySize, availablePromotionsCount: $availablePromotionsCount, activePromotionsCount: $activePromotionsCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
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
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.placeSkipped, placeSkipped) ||
                other.placeSkipped == placeSkipped) &&
            (identical(other.suppressEmailNotifications,
                    suppressEmailNotifications) ||
                other.suppressEmailNotifications ==
                    suppressEmailNotifications) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.biography, biography) ||
                other.biography == biography) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality()
                .equals(other._accountFlags, _accountFlags) &&
            const DeepCollectionEquality()
                .equals(other._visibilityFlags, _visibilityFlags) &&
            const DeepCollectionEquality()
                .equals(other._featureFlags, _featureFlags) &&
            const DeepCollectionEquality()
                .equals(other._companySectors, _companySectors) &&
            (identical(other.companySize, companySize) ||
                other.companySize == companySize) &&
            (identical(
                    other.availablePromotionsCount, availablePromotionsCount) ||
                other.availablePromotionsCount == availablePromotionsCount) &&
            (identical(other.activePromotionsCount, activePromotionsCount) ||
                other.activePromotionsCount == activePromotionsCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        flMeta,
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
        const DeepCollectionEquality().hash(_tags),
        placeSkipped,
        suppressEmailNotifications,
        place,
        biography,
        const DeepCollectionEquality().hash(_media),
        const DeepCollectionEquality().hash(_accountFlags),
        const DeepCollectionEquality().hash(_visibilityFlags),
        const DeepCollectionEquality().hash(_featureFlags),
        const DeepCollectionEquality().hash(_companySectors),
        companySize,
        availablePromotionsCount,
        activePromotionsCount
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      __$$ProfileImplCopyWithImpl<_$ProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileImplToJson(
      this,
    );
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
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
      @JsonKey(fromJson: stringSetFromJson) final Set<String> tags,
      final bool placeSkipped,
      final bool suppressEmailNotifications,
      final PositivePlace? place,
      final String biography,
      final List<Media> media,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> accountFlags,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> visibilityFlags,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> featureFlags,
      @JsonKey(fromJson: stringSetFromJson) final Set<String> companySectors,
      @JsonKey(
          fromJson: ProfileCompanySize.fromJson,
          toJson: ProfileCompanySize.toJson,
          name: 'companySize')
      final ProfileCompanySize companySize,
      final int availablePromotionsCount,
      final int activePromotionsCount}) = _$ProfileImpl;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$ProfileImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
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
  Set<String> get tags;
  @override
  bool get placeSkipped;
  @override
  bool get suppressEmailNotifications;
  @override
  PositivePlace? get place;
  @override
  String get biography;
  @override
  List<Media> get media;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get accountFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get visibilityFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get featureFlags;
  @override
  @JsonKey(fromJson: stringSetFromJson)
  Set<String> get companySectors;
  @override
  @JsonKey(
      fromJson: ProfileCompanySize.fromJson,
      toJson: ProfileCompanySize.toJson,
      name: 'companySize')
  ProfileCompanySize get companySize;
  @override
  int get availablePromotionsCount;
  @override
  int get activePromotionsCount;
  @override
  @JsonKey(ignore: true)
  _$$ProfileImplCopyWith<_$ProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProfileCompanySize {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() lessThanFive,
    required TResult Function() lessThanTwentyFive,
    required TResult Function() lessThanOneHundred,
    required TResult Function() moreThanOneHundred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? lessThanFive,
    TResult? Function()? lessThanTwentyFive,
    TResult? Function()? lessThanOneHundred,
    TResult? Function()? moreThanOneHundred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? lessThanFive,
    TResult Function()? lessThanTwentyFive,
    TResult Function()? lessThanOneHundred,
    TResult Function()? moreThanOneHundred,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileCompanySizeUnknown value) unknown,
    required TResult Function(_ProfileCompanySizeLessThanFive value)
        lessThanFive,
    required TResult Function(_ProfileCompanySizeLessThanTwentyFive value)
        lessThanTwentyFive,
    required TResult Function(_ProfileCompanySizeLessThanOneHundred value)
        lessThanOneHundred,
    required TResult Function(_ProfileCompanySizeMoreThanOneHundred value)
        moreThanOneHundred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult? Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult? Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult? Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult? Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCompanySizeCopyWith<$Res> {
  factory $ProfileCompanySizeCopyWith(
          ProfileCompanySize value, $Res Function(ProfileCompanySize) then) =
      _$ProfileCompanySizeCopyWithImpl<$Res, ProfileCompanySize>;
}

/// @nodoc
class _$ProfileCompanySizeCopyWithImpl<$Res, $Val extends ProfileCompanySize>
    implements $ProfileCompanySizeCopyWith<$Res> {
  _$ProfileCompanySizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ProfileCompanySizeUnknownImplCopyWith<$Res> {
  factory _$$ProfileCompanySizeUnknownImplCopyWith(
          _$ProfileCompanySizeUnknownImpl value,
          $Res Function(_$ProfileCompanySizeUnknownImpl) then) =
      __$$ProfileCompanySizeUnknownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileCompanySizeUnknownImplCopyWithImpl<$Res>
    extends _$ProfileCompanySizeCopyWithImpl<$Res,
        _$ProfileCompanySizeUnknownImpl>
    implements _$$ProfileCompanySizeUnknownImplCopyWith<$Res> {
  __$$ProfileCompanySizeUnknownImplCopyWithImpl(
      _$ProfileCompanySizeUnknownImpl _value,
      $Res Function(_$ProfileCompanySizeUnknownImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProfileCompanySizeUnknownImpl implements _ProfileCompanySizeUnknown {
  const _$ProfileCompanySizeUnknownImpl();

  @override
  String toString() {
    return 'ProfileCompanySize.unknown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileCompanySizeUnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() lessThanFive,
    required TResult Function() lessThanTwentyFive,
    required TResult Function() lessThanOneHundred,
    required TResult Function() moreThanOneHundred,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? lessThanFive,
    TResult? Function()? lessThanTwentyFive,
    TResult? Function()? lessThanOneHundred,
    TResult? Function()? moreThanOneHundred,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? lessThanFive,
    TResult Function()? lessThanTwentyFive,
    TResult Function()? lessThanOneHundred,
    TResult Function()? moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileCompanySizeUnknown value) unknown,
    required TResult Function(_ProfileCompanySizeLessThanFive value)
        lessThanFive,
    required TResult Function(_ProfileCompanySizeLessThanTwentyFive value)
        lessThanTwentyFive,
    required TResult Function(_ProfileCompanySizeLessThanOneHundred value)
        lessThanOneHundred,
    required TResult Function(_ProfileCompanySizeMoreThanOneHundred value)
        moreThanOneHundred,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult? Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult? Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult? Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult? Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _ProfileCompanySizeUnknown implements ProfileCompanySize {
  const factory _ProfileCompanySizeUnknown() = _$ProfileCompanySizeUnknownImpl;
}

/// @nodoc
abstract class _$$ProfileCompanySizeLessThanFiveImplCopyWith<$Res> {
  factory _$$ProfileCompanySizeLessThanFiveImplCopyWith(
          _$ProfileCompanySizeLessThanFiveImpl value,
          $Res Function(_$ProfileCompanySizeLessThanFiveImpl) then) =
      __$$ProfileCompanySizeLessThanFiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileCompanySizeLessThanFiveImplCopyWithImpl<$Res>
    extends _$ProfileCompanySizeCopyWithImpl<$Res,
        _$ProfileCompanySizeLessThanFiveImpl>
    implements _$$ProfileCompanySizeLessThanFiveImplCopyWith<$Res> {
  __$$ProfileCompanySizeLessThanFiveImplCopyWithImpl(
      _$ProfileCompanySizeLessThanFiveImpl _value,
      $Res Function(_$ProfileCompanySizeLessThanFiveImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProfileCompanySizeLessThanFiveImpl
    implements _ProfileCompanySizeLessThanFive {
  const _$ProfileCompanySizeLessThanFiveImpl();

  @override
  String toString() {
    return 'ProfileCompanySize.lessThanFive()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileCompanySizeLessThanFiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() lessThanFive,
    required TResult Function() lessThanTwentyFive,
    required TResult Function() lessThanOneHundred,
    required TResult Function() moreThanOneHundred,
  }) {
    return lessThanFive();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? lessThanFive,
    TResult? Function()? lessThanTwentyFive,
    TResult? Function()? lessThanOneHundred,
    TResult? Function()? moreThanOneHundred,
  }) {
    return lessThanFive?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? lessThanFive,
    TResult Function()? lessThanTwentyFive,
    TResult Function()? lessThanOneHundred,
    TResult Function()? moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (lessThanFive != null) {
      return lessThanFive();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileCompanySizeUnknown value) unknown,
    required TResult Function(_ProfileCompanySizeLessThanFive value)
        lessThanFive,
    required TResult Function(_ProfileCompanySizeLessThanTwentyFive value)
        lessThanTwentyFive,
    required TResult Function(_ProfileCompanySizeLessThanOneHundred value)
        lessThanOneHundred,
    required TResult Function(_ProfileCompanySizeMoreThanOneHundred value)
        moreThanOneHundred,
  }) {
    return lessThanFive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult? Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult? Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult? Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult? Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
  }) {
    return lessThanFive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (lessThanFive != null) {
      return lessThanFive(this);
    }
    return orElse();
  }
}

abstract class _ProfileCompanySizeLessThanFive implements ProfileCompanySize {
  const factory _ProfileCompanySizeLessThanFive() =
      _$ProfileCompanySizeLessThanFiveImpl;
}

/// @nodoc
abstract class _$$ProfileCompanySizeLessThanTwentyFiveImplCopyWith<$Res> {
  factory _$$ProfileCompanySizeLessThanTwentyFiveImplCopyWith(
          _$ProfileCompanySizeLessThanTwentyFiveImpl value,
          $Res Function(_$ProfileCompanySizeLessThanTwentyFiveImpl) then) =
      __$$ProfileCompanySizeLessThanTwentyFiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileCompanySizeLessThanTwentyFiveImplCopyWithImpl<$Res>
    extends _$ProfileCompanySizeCopyWithImpl<$Res,
        _$ProfileCompanySizeLessThanTwentyFiveImpl>
    implements _$$ProfileCompanySizeLessThanTwentyFiveImplCopyWith<$Res> {
  __$$ProfileCompanySizeLessThanTwentyFiveImplCopyWithImpl(
      _$ProfileCompanySizeLessThanTwentyFiveImpl _value,
      $Res Function(_$ProfileCompanySizeLessThanTwentyFiveImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProfileCompanySizeLessThanTwentyFiveImpl
    implements _ProfileCompanySizeLessThanTwentyFive {
  const _$ProfileCompanySizeLessThanTwentyFiveImpl();

  @override
  String toString() {
    return 'ProfileCompanySize.lessThanTwentyFive()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileCompanySizeLessThanTwentyFiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() lessThanFive,
    required TResult Function() lessThanTwentyFive,
    required TResult Function() lessThanOneHundred,
    required TResult Function() moreThanOneHundred,
  }) {
    return lessThanTwentyFive();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? lessThanFive,
    TResult? Function()? lessThanTwentyFive,
    TResult? Function()? lessThanOneHundred,
    TResult? Function()? moreThanOneHundred,
  }) {
    return lessThanTwentyFive?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? lessThanFive,
    TResult Function()? lessThanTwentyFive,
    TResult Function()? lessThanOneHundred,
    TResult Function()? moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (lessThanTwentyFive != null) {
      return lessThanTwentyFive();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileCompanySizeUnknown value) unknown,
    required TResult Function(_ProfileCompanySizeLessThanFive value)
        lessThanFive,
    required TResult Function(_ProfileCompanySizeLessThanTwentyFive value)
        lessThanTwentyFive,
    required TResult Function(_ProfileCompanySizeLessThanOneHundred value)
        lessThanOneHundred,
    required TResult Function(_ProfileCompanySizeMoreThanOneHundred value)
        moreThanOneHundred,
  }) {
    return lessThanTwentyFive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult? Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult? Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult? Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult? Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
  }) {
    return lessThanTwentyFive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (lessThanTwentyFive != null) {
      return lessThanTwentyFive(this);
    }
    return orElse();
  }
}

abstract class _ProfileCompanySizeLessThanTwentyFive
    implements ProfileCompanySize {
  const factory _ProfileCompanySizeLessThanTwentyFive() =
      _$ProfileCompanySizeLessThanTwentyFiveImpl;
}

/// @nodoc
abstract class _$$ProfileCompanySizeLessThanOneHundredImplCopyWith<$Res> {
  factory _$$ProfileCompanySizeLessThanOneHundredImplCopyWith(
          _$ProfileCompanySizeLessThanOneHundredImpl value,
          $Res Function(_$ProfileCompanySizeLessThanOneHundredImpl) then) =
      __$$ProfileCompanySizeLessThanOneHundredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileCompanySizeLessThanOneHundredImplCopyWithImpl<$Res>
    extends _$ProfileCompanySizeCopyWithImpl<$Res,
        _$ProfileCompanySizeLessThanOneHundredImpl>
    implements _$$ProfileCompanySizeLessThanOneHundredImplCopyWith<$Res> {
  __$$ProfileCompanySizeLessThanOneHundredImplCopyWithImpl(
      _$ProfileCompanySizeLessThanOneHundredImpl _value,
      $Res Function(_$ProfileCompanySizeLessThanOneHundredImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProfileCompanySizeLessThanOneHundredImpl
    implements _ProfileCompanySizeLessThanOneHundred {
  const _$ProfileCompanySizeLessThanOneHundredImpl();

  @override
  String toString() {
    return 'ProfileCompanySize.lessThanOneHundred()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileCompanySizeLessThanOneHundredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() lessThanFive,
    required TResult Function() lessThanTwentyFive,
    required TResult Function() lessThanOneHundred,
    required TResult Function() moreThanOneHundred,
  }) {
    return lessThanOneHundred();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? lessThanFive,
    TResult? Function()? lessThanTwentyFive,
    TResult? Function()? lessThanOneHundred,
    TResult? Function()? moreThanOneHundred,
  }) {
    return lessThanOneHundred?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? lessThanFive,
    TResult Function()? lessThanTwentyFive,
    TResult Function()? lessThanOneHundred,
    TResult Function()? moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (lessThanOneHundred != null) {
      return lessThanOneHundred();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileCompanySizeUnknown value) unknown,
    required TResult Function(_ProfileCompanySizeLessThanFive value)
        lessThanFive,
    required TResult Function(_ProfileCompanySizeLessThanTwentyFive value)
        lessThanTwentyFive,
    required TResult Function(_ProfileCompanySizeLessThanOneHundred value)
        lessThanOneHundred,
    required TResult Function(_ProfileCompanySizeMoreThanOneHundred value)
        moreThanOneHundred,
  }) {
    return lessThanOneHundred(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult? Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult? Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult? Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult? Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
  }) {
    return lessThanOneHundred?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (lessThanOneHundred != null) {
      return lessThanOneHundred(this);
    }
    return orElse();
  }
}

abstract class _ProfileCompanySizeLessThanOneHundred
    implements ProfileCompanySize {
  const factory _ProfileCompanySizeLessThanOneHundred() =
      _$ProfileCompanySizeLessThanOneHundredImpl;
}

/// @nodoc
abstract class _$$ProfileCompanySizeMoreThanOneHundredImplCopyWith<$Res> {
  factory _$$ProfileCompanySizeMoreThanOneHundredImplCopyWith(
          _$ProfileCompanySizeMoreThanOneHundredImpl value,
          $Res Function(_$ProfileCompanySizeMoreThanOneHundredImpl) then) =
      __$$ProfileCompanySizeMoreThanOneHundredImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProfileCompanySizeMoreThanOneHundredImplCopyWithImpl<$Res>
    extends _$ProfileCompanySizeCopyWithImpl<$Res,
        _$ProfileCompanySizeMoreThanOneHundredImpl>
    implements _$$ProfileCompanySizeMoreThanOneHundredImplCopyWith<$Res> {
  __$$ProfileCompanySizeMoreThanOneHundredImplCopyWithImpl(
      _$ProfileCompanySizeMoreThanOneHundredImpl _value,
      $Res Function(_$ProfileCompanySizeMoreThanOneHundredImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ProfileCompanySizeMoreThanOneHundredImpl
    implements _ProfileCompanySizeMoreThanOneHundred {
  const _$ProfileCompanySizeMoreThanOneHundredImpl();

  @override
  String toString() {
    return 'ProfileCompanySize.moreThanOneHundred()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileCompanySizeMoreThanOneHundredImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknown,
    required TResult Function() lessThanFive,
    required TResult Function() lessThanTwentyFive,
    required TResult Function() lessThanOneHundred,
    required TResult Function() moreThanOneHundred,
  }) {
    return moreThanOneHundred();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknown,
    TResult? Function()? lessThanFive,
    TResult? Function()? lessThanTwentyFive,
    TResult? Function()? lessThanOneHundred,
    TResult? Function()? moreThanOneHundred,
  }) {
    return moreThanOneHundred?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknown,
    TResult Function()? lessThanFive,
    TResult Function()? lessThanTwentyFive,
    TResult Function()? lessThanOneHundred,
    TResult Function()? moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (moreThanOneHundred != null) {
      return moreThanOneHundred();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ProfileCompanySizeUnknown value) unknown,
    required TResult Function(_ProfileCompanySizeLessThanFive value)
        lessThanFive,
    required TResult Function(_ProfileCompanySizeLessThanTwentyFive value)
        lessThanTwentyFive,
    required TResult Function(_ProfileCompanySizeLessThanOneHundred value)
        lessThanOneHundred,
    required TResult Function(_ProfileCompanySizeMoreThanOneHundred value)
        moreThanOneHundred,
  }) {
    return moreThanOneHundred(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult? Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult? Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult? Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult? Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
  }) {
    return moreThanOneHundred?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ProfileCompanySizeUnknown value)? unknown,
    TResult Function(_ProfileCompanySizeLessThanFive value)? lessThanFive,
    TResult Function(_ProfileCompanySizeLessThanTwentyFive value)?
        lessThanTwentyFive,
    TResult Function(_ProfileCompanySizeLessThanOneHundred value)?
        lessThanOneHundred,
    TResult Function(_ProfileCompanySizeMoreThanOneHundred value)?
        moreThanOneHundred,
    required TResult orElse(),
  }) {
    if (moreThanOneHundred != null) {
      return moreThanOneHundred(this);
    }
    return orElse();
  }
}

abstract class _ProfileCompanySizeMoreThanOneHundred
    implements ProfileCompanySize {
  const factory _ProfileCompanySizeMoreThanOneHundred() =
      _$ProfileCompanySizeMoreThanOneHundredImpl;
}

ProfileStatistics _$ProfileStatisticsFromJson(Map<String, dynamic> json) {
  return _ProfileStatistics.fromJson(json);
}

/// @nodoc
mixin _$ProfileStatistics {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get profileId => throw _privateConstructorUsedError;
  Map<String, int> get counts => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileStatisticsCopyWith<ProfileStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileStatisticsCopyWith<$Res> {
  factory $ProfileStatisticsCopyWith(
          ProfileStatistics value, $Res Function(ProfileStatistics) then) =
      _$ProfileStatisticsCopyWithImpl<$Res, ProfileStatistics>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String profileId,
      Map<String, int> counts});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$ProfileStatisticsCopyWithImpl<$Res, $Val extends ProfileStatistics>
    implements $ProfileStatisticsCopyWith<$Res> {
  _$ProfileStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? profileId = null,
    Object? counts = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
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
}

/// @nodoc
abstract class _$$ProfileStatisticsImplCopyWith<$Res>
    implements $ProfileStatisticsCopyWith<$Res> {
  factory _$$ProfileStatisticsImplCopyWith(_$ProfileStatisticsImpl value,
          $Res Function(_$ProfileStatisticsImpl) then) =
      __$$ProfileStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String profileId,
      Map<String, int> counts});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$ProfileStatisticsImplCopyWithImpl<$Res>
    extends _$ProfileStatisticsCopyWithImpl<$Res, _$ProfileStatisticsImpl>
    implements _$$ProfileStatisticsImplCopyWith<$Res> {
  __$$ProfileStatisticsImplCopyWithImpl(_$ProfileStatisticsImpl _value,
      $Res Function(_$ProfileStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? profileId = null,
    Object? counts = null,
  }) {
    return _then(_$ProfileStatisticsImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      profileId: null == profileId
          ? _value.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _value._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileStatisticsImpl implements _ProfileStatistics {
  const _$ProfileStatisticsImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.profileId = '',
      final Map<String, int> counts = const {}})
      : _counts = counts;

  factory _$ProfileStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileStatisticsImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String profileId;
  final Map<String, int> _counts;
  @override
  @JsonKey()
  Map<String, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
  }

  @override
  String toString() {
    return 'ProfileStatistics(flMeta: $flMeta, profileId: $profileId, counts: $counts)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileStatisticsImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            const DeepCollectionEquality().equals(other._counts, _counts));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, flMeta, profileId,
      const DeepCollectionEquality().hash(_counts));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileStatisticsImplCopyWith<_$ProfileStatisticsImpl> get copyWith =>
      __$$ProfileStatisticsImplCopyWithImpl<_$ProfileStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileStatisticsImplToJson(
      this,
    );
  }
}

abstract class _ProfileStatistics implements ProfileStatistics {
  const factory _ProfileStatistics(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final String profileId,
      final Map<String, int> counts}) = _$ProfileStatisticsImpl;

  factory _ProfileStatistics.fromJson(Map<String, dynamic> json) =
      _$ProfileStatisticsImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get profileId;
  @override
  Map<String, int> get counts;
  @override
  @JsonKey(ignore: true)
  _$$ProfileStatisticsImplCopyWith<_$ProfileStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
