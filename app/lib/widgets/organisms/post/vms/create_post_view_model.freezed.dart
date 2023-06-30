// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_post_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CreatePostViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CreatePostViewModelStateCopyWith<CreatePostViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostViewModelStateCopyWith<$Res> {
  factory $CreatePostViewModelStateCopyWith(CreatePostViewModelState value,
          $Res Function(CreatePostViewModelState) then) =
      _$CreatePostViewModelStateCopyWithImpl<$Res, CreatePostViewModelState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$CreatePostViewModelStateCopyWithImpl<$Res,
        $Val extends CreatePostViewModelState>
    implements $CreatePostViewModelStateCopyWith<$Res> {
  _$CreatePostViewModelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_CreatePostViewModelStateCopyWith<$Res>
    implements $CreatePostViewModelStateCopyWith<$Res> {
  factory _$$_CreatePostViewModelStateCopyWith(
          _$_CreatePostViewModelState value,
          $Res Function(_$_CreatePostViewModelState) then) =
      __$$_CreatePostViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$_CreatePostViewModelStateCopyWithImpl<$Res>
    extends _$CreatePostViewModelStateCopyWithImpl<$Res,
        _$_CreatePostViewModelState>
    implements _$$_CreatePostViewModelStateCopyWith<$Res> {
  __$$_CreatePostViewModelStateCopyWithImpl(_$_CreatePostViewModelState _value,
      $Res Function(_$_CreatePostViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$_CreatePostViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_CreatePostViewModelState implements _CreatePostViewModelState {
  const _$_CreatePostViewModelState({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'CreatePostViewModelState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreatePostViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreatePostViewModelStateCopyWith<_$_CreatePostViewModelState>
      get copyWith => __$$_CreatePostViewModelStateCopyWithImpl<
          _$_CreatePostViewModelState>(this, _$identity);
}

abstract class _CreatePostViewModelState implements CreatePostViewModelState {
  const factory _CreatePostViewModelState({final bool isBusy}) =
      _$_CreatePostViewModelState;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_CreatePostViewModelStateCopyWith<_$_CreatePostViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
