// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AnalyticsControllerState {
  bool get isCollectingData => throw _privateConstructorUsedError;
  bool get canPromptForAnalytics => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AnalyticsControllerStateCopyWith<AnalyticsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsControllerStateCopyWith<$Res> {
  factory $AnalyticsControllerStateCopyWith(AnalyticsControllerState value,
          $Res Function(AnalyticsControllerState) then) =
      _$AnalyticsControllerStateCopyWithImpl<$Res, AnalyticsControllerState>;
  @useResult
  $Res call({bool isCollectingData, bool canPromptForAnalytics});
}

/// @nodoc
class _$AnalyticsControllerStateCopyWithImpl<$Res,
        $Val extends AnalyticsControllerState>
    implements $AnalyticsControllerStateCopyWith<$Res> {
  _$AnalyticsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCollectingData = null,
    Object? canPromptForAnalytics = null,
  }) {
    return _then(_value.copyWith(
      isCollectingData: null == isCollectingData
          ? _value.isCollectingData
          : isCollectingData // ignore: cast_nullable_to_non_nullable
              as bool,
      canPromptForAnalytics: null == canPromptForAnalytics
          ? _value.canPromptForAnalytics
          : canPromptForAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyticsControllerStateImplCopyWith<$Res>
    implements $AnalyticsControllerStateCopyWith<$Res> {
  factory _$$AnalyticsControllerStateImplCopyWith(
          _$AnalyticsControllerStateImpl value,
          $Res Function(_$AnalyticsControllerStateImpl) then) =
      __$$AnalyticsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isCollectingData, bool canPromptForAnalytics});
}

/// @nodoc
class __$$AnalyticsControllerStateImplCopyWithImpl<$Res>
    extends _$AnalyticsControllerStateCopyWithImpl<$Res,
        _$AnalyticsControllerStateImpl>
    implements _$$AnalyticsControllerStateImplCopyWith<$Res> {
  __$$AnalyticsControllerStateImplCopyWithImpl(
      _$AnalyticsControllerStateImpl _value,
      $Res Function(_$AnalyticsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCollectingData = null,
    Object? canPromptForAnalytics = null,
  }) {
    return _then(_$AnalyticsControllerStateImpl(
      isCollectingData: null == isCollectingData
          ? _value.isCollectingData
          : isCollectingData // ignore: cast_nullable_to_non_nullable
              as bool,
      canPromptForAnalytics: null == canPromptForAnalytics
          ? _value.canPromptForAnalytics
          : canPromptForAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AnalyticsControllerStateImpl implements _AnalyticsControllerState {
  const _$AnalyticsControllerStateImpl(
      {this.isCollectingData = false, this.canPromptForAnalytics = false});

  @override
  @JsonKey()
  final bool isCollectingData;
  @override
  @JsonKey()
  final bool canPromptForAnalytics;

  @override
  String toString() {
    return 'AnalyticsControllerState(isCollectingData: $isCollectingData, canPromptForAnalytics: $canPromptForAnalytics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsControllerStateImpl &&
            (identical(other.isCollectingData, isCollectingData) ||
                other.isCollectingData == isCollectingData) &&
            (identical(other.canPromptForAnalytics, canPromptForAnalytics) ||
                other.canPromptForAnalytics == canPromptForAnalytics));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isCollectingData, canPromptForAnalytics);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsControllerStateImplCopyWith<_$AnalyticsControllerStateImpl>
      get copyWith => __$$AnalyticsControllerStateImplCopyWithImpl<
          _$AnalyticsControllerStateImpl>(this, _$identity);
}

abstract class _AnalyticsControllerState implements AnalyticsControllerState {
  const factory _AnalyticsControllerState(
      {final bool isCollectingData,
      final bool canPromptForAnalytics}) = _$AnalyticsControllerStateImpl;

  @override
  bool get isCollectingData;
  @override
  bool get canPromptForAnalytics;
  @override
  @JsonKey(ignore: true)
  _$$AnalyticsControllerStateImplCopyWith<_$AnalyticsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
