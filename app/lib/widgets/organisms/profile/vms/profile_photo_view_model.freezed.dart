// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_photo_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfilePhotoViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfilePhotoViewModelStateCopyWith<ProfilePhotoViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfilePhotoViewModelStateCopyWith<$Res> {
  factory $ProfilePhotoViewModelStateCopyWith(ProfilePhotoViewModelState value,
          $Res Function(ProfilePhotoViewModelState) then) =
      _$ProfilePhotoViewModelStateCopyWithImpl<$Res,
          ProfilePhotoViewModelState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$ProfilePhotoViewModelStateCopyWithImpl<$Res,
        $Val extends ProfilePhotoViewModelState>
    implements $ProfilePhotoViewModelStateCopyWith<$Res> {
  _$ProfilePhotoViewModelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$ProfilePhotoViewModelStateImplCopyWith<$Res>
    implements $ProfilePhotoViewModelStateCopyWith<$Res> {
  factory _$$ProfilePhotoViewModelStateImplCopyWith(
          _$ProfilePhotoViewModelStateImpl value,
          $Res Function(_$ProfilePhotoViewModelStateImpl) then) =
      __$$ProfilePhotoViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$ProfilePhotoViewModelStateImplCopyWithImpl<$Res>
    extends _$ProfilePhotoViewModelStateCopyWithImpl<$Res,
        _$ProfilePhotoViewModelStateImpl>
    implements _$$ProfilePhotoViewModelStateImplCopyWith<$Res> {
  __$$ProfilePhotoViewModelStateImplCopyWithImpl(
      _$ProfilePhotoViewModelStateImpl _value,
      $Res Function(_$ProfilePhotoViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$ProfilePhotoViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ProfilePhotoViewModelStateImpl implements _ProfilePhotoViewModelState {
  const _$ProfilePhotoViewModelStateImpl({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'ProfilePhotoViewModelState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfilePhotoViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfilePhotoViewModelStateImplCopyWith<_$ProfilePhotoViewModelStateImpl>
      get copyWith => __$$ProfilePhotoViewModelStateImplCopyWithImpl<
          _$ProfilePhotoViewModelStateImpl>(this, _$identity);
}

abstract class _ProfilePhotoViewModelState
    implements ProfilePhotoViewModelState {
  const factory _ProfilePhotoViewModelState({final bool isBusy}) =
      _$ProfilePhotoViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$ProfilePhotoViewModelStateImplCopyWith<_$ProfilePhotoViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
