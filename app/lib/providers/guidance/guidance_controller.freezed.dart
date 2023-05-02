// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GuidanceControllerState {
  List<ContentBuilder> get guidancePageContentStack =>
      throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GuidanceControllerStateCopyWith<GuidanceControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceControllerStateCopyWith<$Res> {
  factory $GuidanceControllerStateCopyWith(GuidanceControllerState value,
          $Res Function(GuidanceControllerState) then) =
      _$GuidanceControllerStateCopyWithImpl<$Res, GuidanceControllerState>;
  @useResult
  $Res call({List<ContentBuilder> guidancePageContentStack, bool isBusy});
}

/// @nodoc
class _$GuidanceControllerStateCopyWithImpl<$Res,
        $Val extends GuidanceControllerState>
    implements $GuidanceControllerStateCopyWith<$Res> {
  _$GuidanceControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guidancePageContentStack = null,
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      guidancePageContentStack: null == guidancePageContentStack
          ? _value.guidancePageContentStack
          : guidancePageContentStack // ignore: cast_nullable_to_non_nullable
              as List<ContentBuilder>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GuidanceControllerStateCopyWith<$Res>
    implements $GuidanceControllerStateCopyWith<$Res> {
  factory _$$_GuidanceControllerStateCopyWith(_$_GuidanceControllerState value,
          $Res Function(_$_GuidanceControllerState) then) =
      __$$_GuidanceControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ContentBuilder> guidancePageContentStack, bool isBusy});
}

/// @nodoc
class __$$_GuidanceControllerStateCopyWithImpl<$Res>
    extends _$GuidanceControllerStateCopyWithImpl<$Res,
        _$_GuidanceControllerState>
    implements _$$_GuidanceControllerStateCopyWith<$Res> {
  __$$_GuidanceControllerStateCopyWithImpl(_$_GuidanceControllerState _value,
      $Res Function(_$_GuidanceControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guidancePageContentStack = null,
    Object? isBusy = null,
  }) {
    return _then(_$_GuidanceControllerState(
      guidancePageContentStack: null == guidancePageContentStack
          ? _value._guidancePageContentStack
          : guidancePageContentStack // ignore: cast_nullable_to_non_nullable
              as List<ContentBuilder>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_GuidanceControllerState implements _GuidanceControllerState {
  const _$_GuidanceControllerState(
      {final List<ContentBuilder> guidancePageContentStack = const [],
      this.isBusy = false})
      : _guidancePageContentStack = guidancePageContentStack;

  final List<ContentBuilder> _guidancePageContentStack;
  @override
  @JsonKey()
  List<ContentBuilder> get guidancePageContentStack {
    if (_guidancePageContentStack is EqualUnmodifiableListView)
      return _guidancePageContentStack;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guidancePageContentStack);
  }

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'GuidanceControllerState(guidancePageContentStack: $guidancePageContentStack, isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceControllerState &&
            const DeepCollectionEquality().equals(
                other._guidancePageContentStack, _guidancePageContentStack) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_guidancePageContentStack), isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GuidanceControllerStateCopyWith<_$_GuidanceControllerState>
      get copyWith =>
          __$$_GuidanceControllerStateCopyWithImpl<_$_GuidanceControllerState>(
              this, _$identity);
}

abstract class _GuidanceControllerState implements GuidanceControllerState {
  const factory _GuidanceControllerState(
      {final List<ContentBuilder> guidancePageContentStack,
      final bool isBusy}) = _$_GuidanceControllerState;

  @override
  List<ContentBuilder> get guidancePageContentStack;
  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_GuidanceControllerStateCopyWith<_$_GuidanceControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
