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
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String get fcmToken => throw _privateConstructorUsedError;
  List<String> get visibilityFlags => throw _privateConstructorUsedError;
  int get connectionCount => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  Object? get referenceImages => throw _privateConstructorUsedError;

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
      String name,
      String displayName,
      String fcmToken,
      List<String> visibilityFlags,
      int connectionCount,
      String locale,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      Object? referenceImages});

  $FlMetaCopyWith<$Res>? get flMeta;
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
    Object? name = null,
    Object? displayName = null,
    Object? fcmToken = null,
    Object? visibilityFlags = null,
    Object? connectionCount = null,
    Object? locale = null,
    Object? flMeta = freezed,
    Object? referenceImages = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityFlags: null == visibilityFlags
          ? _value.visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      connectionCount: null == connectionCount
          ? _value.connectionCount
          : connectionCount // ignore: cast_nullable_to_non_nullable
              as int,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      referenceImages:
          freezed == referenceImages ? _value.referenceImages : referenceImages,
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
abstract class _$$_UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$_UserProfileCopyWith(
          _$_UserProfile value, $Res Function(_$_UserProfile) then) =
      __$$_UserProfileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String displayName,
      String fcmToken,
      List<String> visibilityFlags,
      int connectionCount,
      String locale,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      Object? referenceImages});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
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
    Object? name = null,
    Object? displayName = null,
    Object? fcmToken = null,
    Object? visibilityFlags = null,
    Object? connectionCount = null,
    Object? locale = null,
    Object? flMeta = freezed,
    Object? referenceImages = freezed,
  }) {
    return _then(_$_UserProfile(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      visibilityFlags: null == visibilityFlags
          ? _value._visibilityFlags
          : visibilityFlags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      connectionCount: null == connectionCount
          ? _value.connectionCount
          : connectionCount // ignore: cast_nullable_to_non_nullable
              as int,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      referenceImages:
          freezed == referenceImages ? _value.referenceImages : referenceImages,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserProfile implements _UserProfile {
  const _$_UserProfile(
      {this.id = '',
      this.name = '',
      this.displayName = '',
      this.fcmToken = '',
      final List<String> visibilityFlags = const [],
      this.connectionCount = 0,
      this.locale = 'en-GB',
      @JsonKey(name: '_fl_meta_') this.flMeta,
      this.referenceImages = const []})
      : _visibilityFlags = visibilityFlags;

  factory _$_UserProfile.fromJson(Map<String, dynamic> json) =>
      _$$_UserProfileFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String displayName;
  @override
  @JsonKey()
  final String fcmToken;
  final List<String> _visibilityFlags;
  @override
  @JsonKey()
  List<String> get visibilityFlags {
    if (_visibilityFlags is EqualUnmodifiableListView) return _visibilityFlags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_visibilityFlags);
  }

  @override
  @JsonKey()
  final int connectionCount;
  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final Object? referenceImages;

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, displayName: $displayName, fcmToken: $fcmToken, visibilityFlags: $visibilityFlags, connectionCount: $connectionCount, locale: $locale, flMeta: $flMeta, referenceImages: $referenceImages)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            const DeepCollectionEquality()
                .equals(other._visibilityFlags, _visibilityFlags) &&
            (identical(other.connectionCount, connectionCount) ||
                other.connectionCount == connectionCount) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            const DeepCollectionEquality()
                .equals(other.referenceImages, referenceImages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      displayName,
      fcmToken,
      const DeepCollectionEquality().hash(_visibilityFlags),
      connectionCount,
      locale,
      flMeta,
      const DeepCollectionEquality().hash(referenceImages));

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
      final String name,
      final String displayName,
      final String fcmToken,
      final List<String> visibilityFlags,
      final int connectionCount,
      final String locale,
      @JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final Object? referenceImages}) = _$_UserProfile;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$_UserProfile.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get displayName;
  @override
  String get fcmToken;
  @override
  List<String> get visibilityFlags;
  @override
  int get connectionCount;
  @override
  String get locale;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  Object? get referenceImages;
  @override
  @JsonKey(ignore: true)
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}
