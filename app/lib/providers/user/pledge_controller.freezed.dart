// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pledge_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PledgeControllerState {
  bool get arePledgesAccepted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PledgeControllerStateCopyWith<PledgeControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PledgeControllerStateCopyWith<$Res> {
  factory $PledgeControllerStateCopyWith(PledgeControllerState value,
          $Res Function(PledgeControllerState) then) =
      _$PledgeControllerStateCopyWithImpl<$Res, PledgeControllerState>;
  @useResult
  $Res call({bool arePledgesAccepted});
}

/// @nodoc
class _$PledgeControllerStateCopyWithImpl<$Res,
        $Val extends PledgeControllerState>
    implements $PledgeControllerStateCopyWith<$Res> {
  _$PledgeControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? arePledgesAccepted = null,
  }) {
    return _then(_value.copyWith(
      arePledgesAccepted: null == arePledgesAccepted
          ? _value.arePledgesAccepted
          : arePledgesAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PledgeControllerStateCopyWith<$Res>
    implements $PledgeControllerStateCopyWith<$Res> {
  factory _$$_PledgeControllerStateCopyWith(_$_PledgeControllerState value,
          $Res Function(_$_PledgeControllerState) then) =
      __$$_PledgeControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool arePledgesAccepted});
}

/// @nodoc
class __$$_PledgeControllerStateCopyWithImpl<$Res>
    extends _$PledgeControllerStateCopyWithImpl<$Res, _$_PledgeControllerState>
    implements _$$_PledgeControllerStateCopyWith<$Res> {
  __$$_PledgeControllerStateCopyWithImpl(_$_PledgeControllerState _value,
      $Res Function(_$_PledgeControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? arePledgesAccepted = null,
  }) {
    return _then(_$_PledgeControllerState(
      arePledgesAccepted: null == arePledgesAccepted
          ? _value.arePledgesAccepted
          : arePledgesAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_PledgeControllerState implements _PledgeControllerState {
  const _$_PledgeControllerState({required this.arePledgesAccepted});

  @override
  final bool arePledgesAccepted;

  @override
  String toString() {
    return 'PledgeControllerState(arePledgesAccepted: $arePledgesAccepted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PledgeControllerState &&
            (identical(other.arePledgesAccepted, arePledgesAccepted) ||
                other.arePledgesAccepted == arePledgesAccepted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, arePledgesAccepted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PledgeControllerStateCopyWith<_$_PledgeControllerState> get copyWith =>
      __$$_PledgeControllerStateCopyWithImpl<_$_PledgeControllerState>(
          this, _$identity);
}

abstract class _PledgeControllerState implements PledgeControllerState {
  const factory _PledgeControllerState(
      {required final bool arePledgesAccepted}) = _$_PledgeControllerState;

  @override
  bool get arePledgesAccepted;
  @override
  @JsonKey(ignore: true)
  _$$_PledgeControllerStateCopyWith<_$_PledgeControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
