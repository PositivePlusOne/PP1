// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connections_list_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ConnectionsListState {
  List<ConnectedUser> get selectedUsers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ConnectionsListStateCopyWith<ConnectionsListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionsListStateCopyWith<$Res> {
  factory $ConnectionsListStateCopyWith(ConnectionsListState value,
          $Res Function(ConnectionsListState) then) =
      _$ConnectionsListStateCopyWithImpl<$Res, ConnectionsListState>;
  @useResult
  $Res call({List<ConnectedUser> selectedUsers});
}

/// @nodoc
class _$ConnectionsListStateCopyWithImpl<$Res,
        $Val extends ConnectionsListState>
    implements $ConnectionsListStateCopyWith<$Res> {
  _$ConnectionsListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedUsers = null,
  }) {
    return _then(_value.copyWith(
      selectedUsers: null == selectedUsers
          ? _value.selectedUsers
          : selectedUsers // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ConnectionsListStateCopyWith<$Res>
    implements $ConnectionsListStateCopyWith<$Res> {
  factory _$$_ConnectionsListStateCopyWith(_$_ConnectionsListState value,
          $Res Function(_$_ConnectionsListState) then) =
      __$$_ConnectionsListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ConnectedUser> selectedUsers});
}

/// @nodoc
class __$$_ConnectionsListStateCopyWithImpl<$Res>
    extends _$ConnectionsListStateCopyWithImpl<$Res, _$_ConnectionsListState>
    implements _$$_ConnectionsListStateCopyWith<$Res> {
  __$$_ConnectionsListStateCopyWithImpl(_$_ConnectionsListState _value,
      $Res Function(_$_ConnectionsListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedUsers = null,
  }) {
    return _then(_$_ConnectionsListState(
      selectedUsers: null == selectedUsers
          ? _value._selectedUsers
          : selectedUsers // ignore: cast_nullable_to_non_nullable
              as List<ConnectedUser>,
    ));
  }
}

/// @nodoc

class _$_ConnectionsListState implements _ConnectionsListState {
  const _$_ConnectionsListState(
      {final List<ConnectedUser> selectedUsers = const <ConnectedUser>[]})
      : _selectedUsers = selectedUsers;

  final List<ConnectedUser> _selectedUsers;
  @override
  @JsonKey()
  List<ConnectedUser> get selectedUsers {
    if (_selectedUsers is EqualUnmodifiableListView) return _selectedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedUsers);
  }

  @override
  String toString() {
    return 'ConnectionsListState(selectedUsers: $selectedUsers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ConnectionsListState &&
            const DeepCollectionEquality()
                .equals(other._selectedUsers, _selectedUsers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_selectedUsers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ConnectionsListStateCopyWith<_$_ConnectionsListState> get copyWith =>
      __$$_ConnectionsListStateCopyWithImpl<_$_ConnectionsListState>(
          this, _$identity);
}

abstract class _ConnectionsListState implements ConnectionsListState {
  const factory _ConnectionsListState(
      {final List<ConnectedUser> selectedUsers}) = _$_ConnectionsListState;

  @override
  List<ConnectedUser> get selectedUsers;
  @override
  @JsonKey(ignore: true)
  _$$_ConnectionsListStateCopyWith<_$_ConnectionsListState> get copyWith =>
      throw _privateConstructorUsedError;
}
