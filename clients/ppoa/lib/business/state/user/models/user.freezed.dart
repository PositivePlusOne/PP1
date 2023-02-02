// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  bool get hasCreatedProfile => throw _privateConstructorUsedError;
  Map<String, dynamic> get publicData => throw _privateConstructorUsedError;
  Map<String, dynamic> get privateData => throw _privateConstructorUsedError;
  Map<String, dynamic> get systemData => throw _privateConstructorUsedError;
  List<UserAuthProvider> get authProviders =>
      throw _privateConstructorUsedError;
  List<NotificationPreference> get notificationPreferences =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      bool hasCreatedProfile,
      Map<String, dynamic> publicData,
      Map<String, dynamic> privateData,
      Map<String, dynamic> systemData,
      List<UserAuthProvider> authProviders,
      List<NotificationPreference> notificationPreferences});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hasCreatedProfile = null,
    Object? publicData = null,
    Object? privateData = null,
    Object? systemData = null,
    Object? authProviders = null,
    Object? notificationPreferences = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hasCreatedProfile: null == hasCreatedProfile
          ? _value.hasCreatedProfile
          : hasCreatedProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      publicData: null == publicData
          ? _value.publicData
          : publicData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      privateData: null == privateData
          ? _value.privateData
          : privateData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      systemData: null == systemData
          ? _value.systemData
          : systemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      authProviders: null == authProviders
          ? _value.authProviders
          : authProviders // ignore: cast_nullable_to_non_nullable
              as List<UserAuthProvider>,
      notificationPreferences: null == notificationPreferences
          ? _value.notificationPreferences
          : notificationPreferences // ignore: cast_nullable_to_non_nullable
              as List<NotificationPreference>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      bool hasCreatedProfile,
      Map<String, dynamic> publicData,
      Map<String, dynamic> privateData,
      Map<String, dynamic> systemData,
      List<UserAuthProvider> authProviders,
      List<NotificationPreference> notificationPreferences});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hasCreatedProfile = null,
    Object? publicData = null,
    Object? privateData = null,
    Object? systemData = null,
    Object? authProviders = null,
    Object? notificationPreferences = null,
  }) {
    return _then(_$_User(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hasCreatedProfile: null == hasCreatedProfile
          ? _value.hasCreatedProfile
          : hasCreatedProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      publicData: null == publicData
          ? _value._publicData
          : publicData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      privateData: null == privateData
          ? _value._privateData
          : privateData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      systemData: null == systemData
          ? _value._systemData
          : systemData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      authProviders: null == authProviders
          ? _value._authProviders
          : authProviders // ignore: cast_nullable_to_non_nullable
              as List<UserAuthProvider>,
      notificationPreferences: null == notificationPreferences
          ? _value._notificationPreferences
          : notificationPreferences // ignore: cast_nullable_to_non_nullable
              as List<NotificationPreference>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_User implements _User {
  const _$_User(
      {required this.id,
      required this.hasCreatedProfile,
      final Map<String, dynamic> publicData = const {},
      final Map<String, dynamic> privateData = const {},
      final Map<String, dynamic> systemData = const {},
      final List<UserAuthProvider> authProviders = const <UserAuthProvider>[],
      final List<NotificationPreference> notificationPreferences =
          const <NotificationPreference>[]})
      : _publicData = publicData,
        _privateData = privateData,
        _systemData = systemData,
        _authProviders = authProviders,
        _notificationPreferences = notificationPreferences;

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String id;
  @override
  final bool hasCreatedProfile;
  final Map<String, dynamic> _publicData;
  @override
  @JsonKey()
  Map<String, dynamic> get publicData {
    if (_publicData is EqualUnmodifiableMapView) return _publicData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_publicData);
  }

  final Map<String, dynamic> _privateData;
  @override
  @JsonKey()
  Map<String, dynamic> get privateData {
    if (_privateData is EqualUnmodifiableMapView) return _privateData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_privateData);
  }

  final Map<String, dynamic> _systemData;
  @override
  @JsonKey()
  Map<String, dynamic> get systemData {
    if (_systemData is EqualUnmodifiableMapView) return _systemData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_systemData);
  }

  final List<UserAuthProvider> _authProviders;
  @override
  @JsonKey()
  List<UserAuthProvider> get authProviders {
    if (_authProviders is EqualUnmodifiableListView) return _authProviders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authProviders);
  }

  final List<NotificationPreference> _notificationPreferences;
  @override
  @JsonKey()
  List<NotificationPreference> get notificationPreferences {
    if (_notificationPreferences is EqualUnmodifiableListView)
      return _notificationPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notificationPreferences);
  }

  @override
  String toString() {
    return 'User(id: $id, hasCreatedProfile: $hasCreatedProfile, publicData: $publicData, privateData: $privateData, systemData: $systemData, authProviders: $authProviders, notificationPreferences: $notificationPreferences)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hasCreatedProfile, hasCreatedProfile) ||
                other.hasCreatedProfile == hasCreatedProfile) &&
            const DeepCollectionEquality()
                .equals(other._publicData, _publicData) &&
            const DeepCollectionEquality()
                .equals(other._privateData, _privateData) &&
            const DeepCollectionEquality()
                .equals(other._systemData, _systemData) &&
            const DeepCollectionEquality()
                .equals(other._authProviders, _authProviders) &&
            const DeepCollectionEquality().equals(
                other._notificationPreferences, _notificationPreferences));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      hasCreatedProfile,
      const DeepCollectionEquality().hash(_publicData),
      const DeepCollectionEquality().hash(_privateData),
      const DeepCollectionEquality().hash(_systemData),
      const DeepCollectionEquality().hash(_authProviders),
      const DeepCollectionEquality().hash(_notificationPreferences));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final bool hasCreatedProfile,
      final Map<String, dynamic> publicData,
      final Map<String, dynamic> privateData,
      final Map<String, dynamic> systemData,
      final List<UserAuthProvider> authProviders,
      final List<NotificationPreference> notificationPreferences}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id;
  @override
  bool get hasCreatedProfile;
  @override
  Map<String, dynamic> get publicData;
  @override
  Map<String, dynamic> get privateData;
  @override
  Map<String, dynamic> get systemData;
  @override
  List<UserAuthProvider> get authProviders;
  @override
  List<NotificationPreference> get notificationPreferences;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
