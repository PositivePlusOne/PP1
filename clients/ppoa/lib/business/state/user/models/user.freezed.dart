// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

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
  String get displayName => throw _privateConstructorUsedError;
  String get emailAddress => throw _privateConstructorUsedError;
  bool get hasCreatedProfile => throw _privateConstructorUsedError;
  List<UserAuthProvider> get authProviders =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String displayName,
      String emailAddress,
      bool hasCreatedProfile,
      List<UserAuthProvider> authProviders});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? displayName = freezed,
    Object? emailAddress = freezed,
    Object? hasCreatedProfile = freezed,
    Object? authProviders = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: displayName == freezed
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      emailAddress: emailAddress == freezed
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      hasCreatedProfile: hasCreatedProfile == freezed
          ? _value.hasCreatedProfile
          : hasCreatedProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      authProviders: authProviders == freezed
          ? _value.authProviders
          : authProviders // ignore: cast_nullable_to_non_nullable
              as List<UserAuthProvider>,
    ));
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String displayName,
      String emailAddress,
      bool hasCreatedProfile,
      List<UserAuthProvider> authProviders});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, (v) => _then(v as _$_User));

  @override
  _$_User get _value => super._value as _$_User;

  @override
  $Res call({
    Object? id = freezed,
    Object? displayName = freezed,
    Object? emailAddress = freezed,
    Object? hasCreatedProfile = freezed,
    Object? authProviders = freezed,
  }) {
    return _then(_$_User(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: displayName == freezed
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      emailAddress: emailAddress == freezed
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      hasCreatedProfile: hasCreatedProfile == freezed
          ? _value.hasCreatedProfile
          : hasCreatedProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      authProviders: authProviders == freezed
          ? _value._authProviders
          : authProviders // ignore: cast_nullable_to_non_nullable
              as List<UserAuthProvider>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_User implements _User {
  const _$_User(
      {required this.id,
      required this.displayName,
      required this.emailAddress,
      required this.hasCreatedProfile,
      final List<UserAuthProvider> authProviders = const <UserAuthProvider>[]})
      : _authProviders = authProviders;

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  final String emailAddress;
  @override
  final bool hasCreatedProfile;
  final List<UserAuthProvider> _authProviders;
  @override
  @JsonKey()
  List<UserAuthProvider> get authProviders {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authProviders);
  }

  @override
  String toString() {
    return 'User(id: $id, displayName: $displayName, emailAddress: $emailAddress, hasCreatedProfile: $hasCreatedProfile, authProviders: $authProviders)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.displayName, displayName) &&
            const DeepCollectionEquality()
                .equals(other.emailAddress, emailAddress) &&
            const DeepCollectionEquality()
                .equals(other.hasCreatedProfile, hasCreatedProfile) &&
            const DeepCollectionEquality()
                .equals(other._authProviders, _authProviders));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(displayName),
      const DeepCollectionEquality().hash(emailAddress),
      const DeepCollectionEquality().hash(hasCreatedProfile),
      const DeepCollectionEquality().hash(_authProviders));

  @JsonKey(ignore: true)
  @override
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
      required final String displayName,
      required final String emailAddress,
      required final bool hasCreatedProfile,
      final List<UserAuthProvider> authProviders}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  String get emailAddress;
  @override
  bool get hasCreatedProfile;
  @override
  List<UserAuthProvider> get authProviders;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
