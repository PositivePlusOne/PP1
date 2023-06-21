// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GuidanceViewModelState {
  bool get isRefreshing => throw _privateConstructorUsedError;
  String get entryId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GuidanceViewModelStateCopyWith<GuidanceViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceViewModelStateCopyWith<$Res> {
  factory $GuidanceViewModelStateCopyWith(GuidanceViewModelState value,
          $Res Function(GuidanceViewModelState) then) =
      _$GuidanceViewModelStateCopyWithImpl<$Res, GuidanceViewModelState>;
  @useResult
  $Res call({bool isRefreshing, String entryId});
}

/// @nodoc
class _$GuidanceViewModelStateCopyWithImpl<$Res,
        $Val extends GuidanceViewModelState>
    implements $GuidanceViewModelStateCopyWith<$Res> {
  _$GuidanceViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? entryId = null,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GuidanceViewModelStateCopyWith<$Res>
    implements $GuidanceViewModelStateCopyWith<$Res> {
  factory _$$_GuidanceViewModelStateCopyWith(_$_GuidanceViewModelState value,
          $Res Function(_$_GuidanceViewModelState) then) =
      __$$_GuidanceViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRefreshing, String entryId});
}

/// @nodoc
class __$$_GuidanceViewModelStateCopyWithImpl<$Res>
    extends _$GuidanceViewModelStateCopyWithImpl<$Res,
        _$_GuidanceViewModelState>
    implements _$$_GuidanceViewModelStateCopyWith<$Res> {
  __$$_GuidanceViewModelStateCopyWithImpl(_$_GuidanceViewModelState _value,
      $Res Function(_$_GuidanceViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? entryId = null,
  }) {
    return _then(_$_GuidanceViewModelState(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GuidanceViewModelState implements _GuidanceViewModelState {
  const _$_GuidanceViewModelState(
      {this.isRefreshing = false, this.entryId = ''});

  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final String entryId;

  @override
  String toString() {
    return 'GuidanceViewModelState(isRefreshing: $isRefreshing, entryId: $entryId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceViewModelState &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.entryId, entryId) || other.entryId == entryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRefreshing, entryId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GuidanceViewModelStateCopyWith<_$_GuidanceViewModelState> get copyWith =>
      __$$_GuidanceViewModelStateCopyWithImpl<_$_GuidanceViewModelState>(
          this, _$identity);
}

abstract class _GuidanceViewModelState implements GuidanceViewModelState {
  const factory _GuidanceViewModelState(
      {final bool isRefreshing,
      final String entryId}) = _$_GuidanceViewModelState;

  @override
  bool get isRefreshing;
  @override
  String get entryId;
  @override
  @JsonKey(ignore: true)
  _$$_GuidanceViewModelStateCopyWith<_$_GuidanceViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
