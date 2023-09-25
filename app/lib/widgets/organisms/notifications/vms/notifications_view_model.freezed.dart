// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationsViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsViewModelStateCopyWith<NotificationsViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsViewModelStateCopyWith<$Res> {
  factory $NotificationsViewModelStateCopyWith(
          NotificationsViewModelState value,
          $Res Function(NotificationsViewModelState) then) =
      _$NotificationsViewModelStateCopyWithImpl<$Res,
          NotificationsViewModelState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$NotificationsViewModelStateCopyWithImpl<$Res,
        $Val extends NotificationsViewModelState>
    implements $NotificationsViewModelStateCopyWith<$Res> {
  _$NotificationsViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NotificationsViewModelStateCopyWith<$Res>
    implements $NotificationsViewModelStateCopyWith<$Res> {
  factory _$$_NotificationsViewModelStateCopyWith(
          _$_NotificationsViewModelState value,
          $Res Function(_$_NotificationsViewModelState) then) =
      __$$_NotificationsViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$_NotificationsViewModelStateCopyWithImpl<$Res>
    extends _$NotificationsViewModelStateCopyWithImpl<$Res,
        _$_NotificationsViewModelState>
    implements _$$_NotificationsViewModelStateCopyWith<$Res> {
  __$$_NotificationsViewModelStateCopyWithImpl(
      _$_NotificationsViewModelState _value,
      $Res Function(_$_NotificationsViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$_NotificationsViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_NotificationsViewModelState implements _NotificationsViewModelState {
  const _$_NotificationsViewModelState({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'NotificationsViewModelState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationsViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationsViewModelStateCopyWith<_$_NotificationsViewModelState>
      get copyWith => __$$_NotificationsViewModelStateCopyWithImpl<
          _$_NotificationsViewModelState>(this, _$identity);
}

abstract class _NotificationsViewModelState
    implements NotificationsViewModelState {
  const factory _NotificationsViewModelState({final bool isBusy}) =
      _$_NotificationsViewModelState;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationsViewModelStateCopyWith<_$_NotificationsViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
