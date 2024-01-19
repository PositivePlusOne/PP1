// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promoted_posts_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PromotedPostsControllerState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PromotedPostsControllerStateCopyWith<PromotedPostsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotedPostsControllerStateCopyWith<$Res> {
  factory $PromotedPostsControllerStateCopyWith(
          PromotedPostsControllerState value,
          $Res Function(PromotedPostsControllerState) then) =
      _$PromotedPostsControllerStateCopyWithImpl<$Res,
          PromotedPostsControllerState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$PromotedPostsControllerStateCopyWithImpl<$Res,
        $Val extends PromotedPostsControllerState>
    implements $PromotedPostsControllerStateCopyWith<$Res> {
  _$PromotedPostsControllerStateCopyWithImpl(this._value, this._then);

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
abstract class _$$PromotedPostsControllerStateImplCopyWith<$Res>
    implements $PromotedPostsControllerStateCopyWith<$Res> {
  factory _$$PromotedPostsControllerStateImplCopyWith(
          _$PromotedPostsControllerStateImpl value,
          $Res Function(_$PromotedPostsControllerStateImpl) then) =
      __$$PromotedPostsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$PromotedPostsControllerStateImplCopyWithImpl<$Res>
    extends _$PromotedPostsControllerStateCopyWithImpl<$Res,
        _$PromotedPostsControllerStateImpl>
    implements _$$PromotedPostsControllerStateImplCopyWith<$Res> {
  __$$PromotedPostsControllerStateImplCopyWithImpl(
      _$PromotedPostsControllerStateImpl _value,
      $Res Function(_$PromotedPostsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$PromotedPostsControllerStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PromotedPostsControllerStateImpl
    implements _PromotedPostsControllerState {
  const _$PromotedPostsControllerStateImpl({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'PromotedPostsControllerState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotedPostsControllerStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotedPostsControllerStateImplCopyWith<
          _$PromotedPostsControllerStateImpl>
      get copyWith => __$$PromotedPostsControllerStateImplCopyWithImpl<
          _$PromotedPostsControllerStateImpl>(this, _$identity);
}

abstract class _PromotedPostsControllerState
    implements PromotedPostsControllerState {
  const factory _PromotedPostsControllerState({final bool isBusy}) =
      _$PromotedPostsControllerStateImpl;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$PromotedPostsControllerStateImplCopyWith<
          _$PromotedPostsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
