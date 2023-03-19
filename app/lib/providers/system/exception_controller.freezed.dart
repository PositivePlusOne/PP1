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
  bool get isCrashlyticsListening => throw _privateConstructorUsedError;
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
  $Res call(
      {bool isCrashlyticsListening,
      Object? currentException,
      String? currentExceptionRoute});
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
    Object? isCrashlyticsListening = null,
    Object? currentException = freezed,
    Object? currentExceptionRoute = freezed,
  }) {
    return _then(_value.copyWith(
      isCrashlyticsListening: null == isCrashlyticsListening
          ? _value.isCrashlyticsListening
          : isCrashlyticsListening // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$_ExceptionControllerStateCopyWith<$Res>
    implements $ExceptionControllerStateCopyWith<$Res> {
  factory _$$_ExceptionControllerStateCopyWith(
          _$_ExceptionControllerState value,
          $Res Function(_$_ExceptionControllerState) then) =
      __$$_ExceptionControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCrashlyticsListening,
      Object? currentException,
      String? currentExceptionRoute});
}

/// @nodoc
class __$$_ExceptionControllerStateCopyWithImpl<$Res>
    extends _$ExceptionControllerStateCopyWithImpl<$Res,
        _$_ExceptionControllerState>
    implements _$$_ExceptionControllerStateCopyWith<$Res> {
  __$$_ExceptionControllerStateCopyWithImpl(_$_ExceptionControllerState _value,
      $Res Function(_$_ExceptionControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCrashlyticsListening = null,
    Object? currentException = freezed,
    Object? currentExceptionRoute = freezed,
  }) {
    return _then(_$_ExceptionControllerState(
      isCrashlyticsListening: null == isCrashlyticsListening
          ? _value.isCrashlyticsListening
          : isCrashlyticsListening // ignore: cast_nullable_to_non_nullable
              as bool,
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

class _$_ExceptionControllerState
    with DiagnosticableTreeMixin
    implements _ExceptionControllerState {
  const _$_ExceptionControllerState(
      {required this.isCrashlyticsListening,
      this.currentException,
      this.currentExceptionRoute});

  @override
  final bool isCrashlyticsListening;
  @override
  final Object? currentException;
  @override
  final String? currentExceptionRoute;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ExceptionControllerState(isCrashlyticsListening: $isCrashlyticsListening, currentException: $currentException, currentExceptionRoute: $currentExceptionRoute)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ExceptionControllerState'))
      ..add(
          DiagnosticsProperty('isCrashlyticsListening', isCrashlyticsListening))
      ..add(DiagnosticsProperty('currentException', currentException))
      ..add(
          DiagnosticsProperty('currentExceptionRoute', currentExceptionRoute));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ExceptionControllerState &&
            (identical(other.isCrashlyticsListening, isCrashlyticsListening) ||
                other.isCrashlyticsListening == isCrashlyticsListening) &&
            const DeepCollectionEquality()
                .equals(other.currentException, currentException) &&
            (identical(other.currentExceptionRoute, currentExceptionRoute) ||
                other.currentExceptionRoute == currentExceptionRoute));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCrashlyticsListening,
      const DeepCollectionEquality().hash(currentException),
      currentExceptionRoute);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ExceptionControllerStateCopyWith<_$_ExceptionControllerState>
      get copyWith => __$$_ExceptionControllerStateCopyWithImpl<
          _$_ExceptionControllerState>(this, _$identity);
}

abstract class _ExceptionControllerState implements ExceptionControllerState {
  const factory _ExceptionControllerState(
      {required final bool isCrashlyticsListening,
      final Object? currentException,
      final String? currentExceptionRoute}) = _$_ExceptionControllerState;

  @override
  bool get isCrashlyticsListening;
  @override
  Object? get currentException;
  @override
  String? get currentExceptionRoute;
  @override
  @JsonKey(ignore: true)
  _$$_ExceptionControllerStateCopyWith<_$_ExceptionControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
