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

ConnectedUserResult _$ConnectedUserResultFromJson(Map<String, dynamic> json) {
  return _ConnectedUserResult.fromJson(json);
}

/// @nodoc
mixin _$ConnectedUserResult {
  List<ConnectedUser> get data => throw _privateConstructorUsedError;
  Pagination get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConnectedUserResultCopyWith<ConnectedUserResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectedUserResultCopyWith<$Res> {
  factory $ConnectedUserResultCopyWith(
          ConnectedUserResult value, $Res Function(ConnectedUserResult) then) =
      _$ConnectedUserResultCopyWithImpl<$Res, ConnectedUserResult>;
  @useResult
  $Res call({List<ConnectedUser> data, Pagination pagination});

  $PaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class _$ConnectedUserResultCopyWithImpl<$Res, $Val extends ConnectedUserResult>
    implements $ConnectedUserResultCopyWith<$Res> {
  _$ConnectedUserResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationCopyWith<$Res> get pagination {
    return $PaginationCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ConnectedUserResultCopyWith<$Res>
    implements $ConnectedUserResultCopyWith<$Res> {
  factory _$$_ConnectedUserResultCopyWith(_$_ConnectedUserResult value,
          $Res Function(_$_ConnectedUserResult) then) =
      __$$_ConnectedUserResultCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ConnectedUser> data, Pagination pagination});

  @override
  $PaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$_ConnectedUserResultCopyWithImpl<$Res>
    extends _$ConnectedUserResultCopyWithImpl<$Res, _$_ConnectedUserResult>
    implements _$$_ConnectedUserResultCopyWith<$Res> {
  __$$_ConnectedUserResultCopyWithImpl(_$_ConnectedUserResult _value,
      $Res Function(_$_ConnectedUserResult) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pagination = null,
  }) {
    return _then(_$_ConnectedUserResult(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ConnectedUserResult implements _ConnectedUserResult {
  const _$_ConnectedUserResult(
      {required final List<ConnectedUser> data, required this.pagination})
      : _data = data;

  factory _$_ConnectedUserResult.fromJson(Map<String, dynamic> json) =>
      _$$_ConnectedUserResultFromJson(json);

  final List<ConnectedUser> _data;
  @override
  List<ConnectedUser> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final Pagination pagination;

  @override
  String toString() {
    return 'ConnectedUserResult(data: $data, pagination: $pagination)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConnectedUserResult &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConnectedUserResultCopyWith<_$_ConnectedUserResult> get copyWith =>
      __$$_ConnectedUserResultCopyWithImpl<_$_ConnectedUserResult>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ConnectedUserResultToJson(
      this,
    );
  }
}

abstract class _ConnectedUserResult implements ConnectedUserResult {
  const factory _ConnectedUserResult(
      {required final List<ConnectedUser> data,
      required final Pagination pagination}) = _$_ConnectedUserResult;

  factory _ConnectedUserResult.fromJson(Map<String, dynamic> json) =
      _$_ConnectedUserResult.fromJson;

  @override
  List<ConnectedUser> get data;
  @override
  Pagination get pagination;
  @override
  @JsonKey(ignore: true)
  _$$_ConnectedUserResultCopyWith<_$_ConnectedUserResult> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectedUser _$ConnectedUserFromJson(Map<String, dynamic> json) {
  return _ConnectedUser.fromJson(json);
}

/// @nodoc
mixin _$ConnectedUser {
  String get id => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: PositivePlace.fromJson)
  PositivePlace? get place => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  String? get accentColor => throw _privateConstructorUsedError;
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
      {String id,
      String displayName,
      @JsonKey(fromJson: PositivePlace.fromJson) PositivePlace? place,
      String? profileImage,
      String? accentColor,
      String? hivStatus,
      List<String>? interests,
      List<String>? genders,
      String? birthday});

  $PositivePlaceCopyWith<$Res>? get place;
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
    Object? id = null,
    Object? displayName = null,
    Object? place = freezed,
    Object? profileImage = freezed,
    Object? accentColor = freezed,
    Object? hivStatus = freezed,
    Object? interests = freezed,
    Object? genders = freezed,
    Object? birthday = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
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
  $PositivePlaceCopyWith<$Res>? get place {
    if (_value.place == null) {
      return null;
    }

    return $PositivePlaceCopyWith<$Res>(_value.place!, (value) {
      return _then(_value.copyWith(place: value) as $Val);
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
      {String id,
      String displayName,
      @JsonKey(fromJson: PositivePlace.fromJson) PositivePlace? place,
      String? profileImage,
      String? accentColor,
      String? hivStatus,
      List<String>? interests,
      List<String>? genders,
      String? birthday});

  @override
  $PositivePlaceCopyWith<$Res>? get place;
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
    Object? id = null,
    Object? displayName = null,
    Object? place = freezed,
    Object? profileImage = freezed,
    Object? accentColor = freezed,
    Object? hivStatus = freezed,
    Object? interests = freezed,
    Object? genders = freezed,
    Object? birthday = freezed,
  }) {
    return _then(_$_ConnectedUser(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as PositivePlace?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      accentColor: freezed == accentColor
          ? _value.accentColor
          : accentColor // ignore: cast_nullable_to_non_nullable
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
      {required this.id,
      required this.displayName,
      @JsonKey(fromJson: PositivePlace.fromJson) this.place,
      this.profileImage,
      this.accentColor,
      this.hivStatus,
      final List<String>? interests,
      final List<String>? genders,
      this.birthday})
      : _interests = interests,
        _genders = genders;

  factory _$_ConnectedUser.fromJson(Map<String, dynamic> json) =>
      _$$_ConnectedUserFromJson(json);

  @override
  final String id;
  @override
  final String displayName;
  @override
  @JsonKey(fromJson: PositivePlace.fromJson)
  final PositivePlace? place;
  @override
  final String? profileImage;
  @override
  final String? accentColor;
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
    return 'ConnectedUser(id: $id, displayName: $displayName, place: $place, profileImage: $profileImage, accentColor: $accentColor, hivStatus: $hivStatus, interests: $interests, genders: $genders, birthday: $birthday)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConnectedUser &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
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
      id,
      displayName,
      place,
      profileImage,
      accentColor,
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
      {required final String id,
      required final String displayName,
      @JsonKey(fromJson: PositivePlace.fromJson) final PositivePlace? place,
      final String? profileImage,
      final String? accentColor,
      final String? hivStatus,
      final List<String>? interests,
      final List<String>? genders,
      final String? birthday}) = _$_ConnectedUser;

  factory _ConnectedUser.fromJson(Map<String, dynamic> json) =
      _$_ConnectedUser.fromJson;

  @override
  String get id;
  @override
  String get displayName;
  @override
  @JsonKey(fromJson: PositivePlace.fromJson)
  PositivePlace? get place;
  @override
  String? get profileImage;
  @override
  String? get accentColor;
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

/// @nodoc
mixin _$ConnectedUserState {
  List<ConnectedUser> get users => throw _privateConstructorUsedError;
  bool get hasReachMax => throw _privateConstructorUsedError;
  Pagination get pagination => throw _privateConstructorUsedError;
  List<ConnectedUser> get filteredUsers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConnectedUserStateCopyWith<ConnectedUserState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectedUserStateCopyWith<$Res> {
  factory $ConnectedUserStateCopyWith(
          ConnectedUserState value, $Res Function(ConnectedUserState) then) =
      _$ConnectedUserStateCopyWithImpl<$Res, ConnectedUserState>;
  @useResult
  $Res call(
      {List<ConnectedUser> users,
      bool hasReachMax,
      Pagination pagination,
      List<ConnectedUser> filteredUsers});

  $PaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class _$ConnectedUserStateCopyWithImpl<$Res, $Val extends ConnectedUserState>
    implements $ConnectedUserStateCopyWith<$Res> {
  _$ConnectedUserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? hasReachMax = null,
    Object? pagination = null,
    Object? filteredUsers = null,
  }) {
    return _then(_value.copyWith(
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
      hasReachMax: null == hasReachMax
          ? _value.hasReachMax
          : hasReachMax // ignore: cast_nullable_to_non_nullable
              as bool,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination,
      filteredUsers: null == filteredUsers
          ? _value.filteredUsers
          : filteredUsers // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationCopyWith<$Res> get pagination {
    return $PaginationCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ConnectedUserStateCopyWith<$Res>
    implements $ConnectedUserStateCopyWith<$Res> {
  factory _$$_ConnectedUserStateCopyWith(_$_ConnectedUserState value,
          $Res Function(_$_ConnectedUserState) then) =
      __$$_ConnectedUserStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ConnectedUser> users,
      bool hasReachMax,
      Pagination pagination,
      List<ConnectedUser> filteredUsers});

  @override
  $PaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$_ConnectedUserStateCopyWithImpl<$Res>
    extends _$ConnectedUserStateCopyWithImpl<$Res, _$_ConnectedUserState>
    implements _$$_ConnectedUserStateCopyWith<$Res> {
  __$$_ConnectedUserStateCopyWithImpl(
      _$_ConnectedUserState _value, $Res Function(_$_ConnectedUserState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? users = null,
    Object? hasReachMax = null,
    Object? pagination = null,
    Object? filteredUsers = null,
  }) {
    return _then(_$_ConnectedUserState(
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
      hasReachMax: null == hasReachMax
          ? _value.hasReachMax
          : hasReachMax // ignore: cast_nullable_to_non_nullable
              as bool,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as Pagination,
      filteredUsers: null == filteredUsers
          ? _value._filteredUsers
          : filteredUsers // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
    ));
  }
}

/// @nodoc

class _$_ConnectedUserState implements _ConnectedUserState {
  const _$_ConnectedUserState(
      {final List<ConnectedUser> users = const <ConnectedUser>[],
      this.hasReachMax = false,
      required this.pagination,
      final List<ConnectedUser> filteredUsers = const <ConnectedUser>[]})
      : _users = users,
        _filteredUsers = filteredUsers;

  final List<ConnectedUser> _users;
  @override
  @JsonKey()
  List<ConnectedUser> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  @JsonKey()
  final bool hasReachMax;
  @override
  final Pagination pagination;
  final List<ConnectedUser> _filteredUsers;
  @override
  @JsonKey()
  List<ConnectedUser> get filteredUsers {
    if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredUsers);
  }

  @override
  String toString() {
    return 'ConnectedUserState(users: $users, hasReachMax: $hasReachMax, pagination: $pagination, filteredUsers: $filteredUsers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConnectedUserState &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.hasReachMax, hasReachMax) ||
                other.hasReachMax == hasReachMax) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination) &&
            const DeepCollectionEquality()
                .equals(other._filteredUsers, _filteredUsers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_users),
      hasReachMax,
      pagination,
      const DeepCollectionEquality().hash(_filteredUsers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConnectedUserStateCopyWith<_$_ConnectedUserState> get copyWith =>
      __$$_ConnectedUserStateCopyWithImpl<_$_ConnectedUserState>(
          this, _$identity);
}

abstract class _ConnectedUserState implements ConnectedUserState {
  const factory _ConnectedUserState(
      {final List<ConnectedUser> users,
      final bool hasReachMax,
      required final Pagination pagination,
      final List<ConnectedUser> filteredUsers}) = _$_ConnectedUserState;

  @override
  List<ConnectedUser> get users;
  @override
  bool get hasReachMax;
  @override
  Pagination get pagination;
  @override
  List<ConnectedUser> get filteredUsers;
  @override
  @JsonKey(ignore: true)
  _$$_ConnectedUserStateCopyWith<_$_ConnectedUserState> get copyWith =>
      throw _privateConstructorUsedError;
}
