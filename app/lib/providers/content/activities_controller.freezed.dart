// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activities_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ActivitiesControllerState {
  Map<String, Activity> get activities => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActivitiesControllerStateCopyWith<ActivitiesControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivitiesControllerStateCopyWith<$Res> {
  factory $ActivitiesControllerStateCopyWith(ActivitiesControllerState value,
          $Res Function(ActivitiesControllerState) then) =
      _$ActivitiesControllerStateCopyWithImpl<$Res, ActivitiesControllerState>;
  @useResult
  $Res call({Map<String, Activity> activities});
}

/// @nodoc
class _$ActivitiesControllerStateCopyWithImpl<$Res,
        $Val extends ActivitiesControllerState>
    implements $ActivitiesControllerStateCopyWith<$Res> {
  _$ActivitiesControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
  }) {
    return _then(_value.copyWith(
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as Map<String, Activity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivitiesControllerStateImplCopyWith<$Res>
    implements $ActivitiesControllerStateCopyWith<$Res> {
  factory _$$ActivitiesControllerStateImplCopyWith(
          _$ActivitiesControllerStateImpl value,
          $Res Function(_$ActivitiesControllerStateImpl) then) =
      __$$ActivitiesControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, Activity> activities});
}

/// @nodoc
class __$$ActivitiesControllerStateImplCopyWithImpl<$Res>
    extends _$ActivitiesControllerStateCopyWithImpl<$Res,
        _$ActivitiesControllerStateImpl>
    implements _$$ActivitiesControllerStateImplCopyWith<$Res> {
  __$$ActivitiesControllerStateImplCopyWithImpl(
      _$ActivitiesControllerStateImpl _value,
      $Res Function(_$ActivitiesControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activities = null,
  }) {
    return _then(_$ActivitiesControllerStateImpl(
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as Map<String, Activity>,
    ));
  }
}

/// @nodoc

class _$ActivitiesControllerStateImpl implements _ActivitiesControllerState {
  const _$ActivitiesControllerStateImpl(
      {required final Map<String, Activity> activities})
      : _activities = activities;

  final Map<String, Activity> _activities;
  @override
  Map<String, Activity> get activities {
    if (_activities is EqualUnmodifiableMapView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_activities);
  }

  @override
  String toString() {
    return 'ActivitiesControllerState(activities: $activities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivitiesControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_activities));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivitiesControllerStateImplCopyWith<_$ActivitiesControllerStateImpl>
      get copyWith => __$$ActivitiesControllerStateImplCopyWithImpl<
          _$ActivitiesControllerStateImpl>(this, _$identity);
}

abstract class _ActivitiesControllerState implements ActivitiesControllerState {
  const factory _ActivitiesControllerState(
          {required final Map<String, Activity> activities}) =
      _$ActivitiesControllerStateImpl;

  @override
  Map<String, Activity> get activities;
  @override
  @JsonKey(ignore: true)
  _$$ActivitiesControllerStateImplCopyWith<_$ActivitiesControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
