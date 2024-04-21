// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileViewModelState {
  String get targetProfileId => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileViewModelStateCopyWith<ProfileViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileViewModelStateCopyWith<$Res> {
  factory $ProfileViewModelStateCopyWith(ProfileViewModelState value,
          $Res Function(ProfileViewModelState) then) =
      _$ProfileViewModelStateCopyWithImpl<$Res, ProfileViewModelState>;
  @useResult
  $Res call({String targetProfileId, bool isBusy});
}

/// @nodoc
class _$ProfileViewModelStateCopyWithImpl<$Res,
        $Val extends ProfileViewModelState>
    implements $ProfileViewModelStateCopyWith<$Res> {
  _$ProfileViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetProfileId = null,
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      targetProfileId: null == targetProfileId
          ? _value.targetProfileId
          : targetProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProfileViewModelStateImplCopyWith<$Res>
    implements $ProfileViewModelStateCopyWith<$Res> {
  factory _$$ProfileViewModelStateImplCopyWith(
          _$ProfileViewModelStateImpl value,
          $Res Function(_$ProfileViewModelStateImpl) then) =
      __$$ProfileViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String targetProfileId, bool isBusy});
}

/// @nodoc
class __$$ProfileViewModelStateImplCopyWithImpl<$Res>
    extends _$ProfileViewModelStateCopyWithImpl<$Res,
        _$ProfileViewModelStateImpl>
    implements _$$ProfileViewModelStateImplCopyWith<$Res> {
  __$$ProfileViewModelStateImplCopyWithImpl(_$ProfileViewModelStateImpl _value,
      $Res Function(_$ProfileViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetProfileId = null,
    Object? isBusy = null,
  }) {
    return _then(_$ProfileViewModelStateImpl(
      targetProfileId: null == targetProfileId
          ? _value.targetProfileId
          : targetProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ProfileViewModelStateImpl implements _ProfileViewModelState {
  const _$ProfileViewModelStateImpl(
      {required this.targetProfileId, this.isBusy = false});

  @override
  final String targetProfileId;
  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'ProfileViewModelState(targetProfileId: $targetProfileId, isBusy: $isBusy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileViewModelStateImpl &&
            (identical(other.targetProfileId, targetProfileId) ||
                other.targetProfileId == targetProfileId) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetProfileId, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileViewModelStateImplCopyWith<_$ProfileViewModelStateImpl>
      get copyWith => __$$ProfileViewModelStateImplCopyWithImpl<
          _$ProfileViewModelStateImpl>(this, _$identity);
}

abstract class _ProfileViewModelState implements ProfileViewModelState {
  const factory _ProfileViewModelState(
      {required final String targetProfileId,
      final bool isBusy}) = _$ProfileViewModelStateImpl;

  @override
  String get targetProfileId;
  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$ProfileViewModelStateImplCopyWith<_$ProfileViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
