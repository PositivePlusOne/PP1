// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exception_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ExceptionControllerState {
  Object? get currentException => throw _privateConstructorUsedError;
  String? get currentExceptionRoute => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExceptionControllerStateCopyWith<ExceptionControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExceptionControllerStateCopyWith<$Res> {
  factory $ExceptionControllerStateCopyWith(ExceptionControllerState value,
          $Res Function(ExceptionControllerState) then) =
      _$ExceptionControllerStateCopyWithImpl<$Res, ExceptionControllerState>;
  @useResult
  $Res call({Object? currentException, String? currentExceptionRoute});
}

/// @nodoc
class _$ExceptionControllerStateCopyWithImpl<$Res,
        $Val extends ExceptionControllerState>
    implements $ExceptionControllerStateCopyWith<$Res> {
  _$ExceptionControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentException = freezed,
    Object? currentExceptionRoute = freezed,
  }) {
    return _then(_value.copyWith(
      currentException: freezed == currentException
          ? _value.currentException
          : currentException,
      currentExceptionRoute: freezed == currentExceptionRoute
          ? _value.currentExceptionRoute
          : currentExceptionRoute // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExceptionControllerStateImplCopyWith<$Res>
    implements $ExceptionControllerStateCopyWith<$Res> {
  factory _$$ExceptionControllerStateImplCopyWith(
          _$ExceptionControllerStateImpl value,
          $Res Function(_$ExceptionControllerStateImpl) then) =
      __$$ExceptionControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Object? currentException, String? currentExceptionRoute});
}

/// @nodoc
class __$$ExceptionControllerStateImplCopyWithImpl<$Res>
    extends _$ExceptionControllerStateCopyWithImpl<$Res,
        _$ExceptionControllerStateImpl>
    implements _$$ExceptionControllerStateImplCopyWith<$Res> {
  __$$ExceptionControllerStateImplCopyWithImpl(
      _$ExceptionControllerStateImpl _value,
      $Res Function(_$ExceptionControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentException = freezed,
    Object? currentExceptionRoute = freezed,
  }) {
    return _then(_$ExceptionControllerStateImpl(
      currentException: freezed == currentException
          ? _value.currentException
          : currentException,
      currentExceptionRoute: freezed == currentExceptionRoute
          ? _value.currentExceptionRoute
          : currentExceptionRoute // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ExceptionControllerStateImpl
    with DiagnosticableTreeMixin
    implements _ExceptionControllerState {
  const _$ExceptionControllerStateImpl(
      {this.currentException, this.currentExceptionRoute});

  @override
  final Object? currentException;
  @override
  final String? currentExceptionRoute;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ExceptionControllerState(currentException: $currentException, currentExceptionRoute: $currentExceptionRoute)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExceptionControllerState'))
      ..add(DiagnosticsProperty('currentException', currentException))
      ..add(
          DiagnosticsProperty('currentExceptionRoute', currentExceptionRoute));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExceptionControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other.currentException, currentException) &&
            (identical(other.currentExceptionRoute, currentExceptionRoute) ||
                other.currentExceptionRoute == currentExceptionRoute));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(currentException),
      currentExceptionRoute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExceptionControllerStateImplCopyWith<_$ExceptionControllerStateImpl>
      get copyWith => __$$ExceptionControllerStateImplCopyWithImpl<
          _$ExceptionControllerStateImpl>(this, _$identity);
}

abstract class _ExceptionControllerState implements ExceptionControllerState {
  const factory _ExceptionControllerState(
      {final Object? currentException,
      final String? currentExceptionRoute}) = _$ExceptionControllerStateImpl;

  @override
  Object? get currentException;
  @override
  String? get currentExceptionRoute;
  @override
  @JsonKey(ignore: true)
  _$$ExceptionControllerStateImplCopyWith<_$ExceptionControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
