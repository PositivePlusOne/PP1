// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hiv_status_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HivStatus _$HivStatusFromJson(Map<String, dynamic> json) {
  return _HivStatus.fromJson(json);
}

/// @nodoc
mixin _$HivStatus {
  String get value => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  List<HivStatus>? get children => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HivStatusCopyWith<HivStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HivStatusCopyWith<$Res> {
  factory $HivStatusCopyWith(HivStatus value, $Res Function(HivStatus) then) =
      _$HivStatusCopyWithImpl<$Res, HivStatus>;
  @useResult
  $Res call({String value, String label, List<HivStatus>? children});
}

/// @nodoc
class _$HivStatusCopyWithImpl<$Res, $Val extends HivStatus>
    implements $HivStatusCopyWith<$Res> {
  _$HivStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
    Object? children = freezed,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      children: freezed == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<HivStatus>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HivStatusImplCopyWith<$Res>
    implements $HivStatusCopyWith<$Res> {
  factory _$$HivStatusImplCopyWith(
          _$HivStatusImpl value, $Res Function(_$HivStatusImpl) then) =
      __$$HivStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String label, List<HivStatus>? children});
}

/// @nodoc
class __$$HivStatusImplCopyWithImpl<$Res>
    extends _$HivStatusCopyWithImpl<$Res, _$HivStatusImpl>
    implements _$$HivStatusImplCopyWith<$Res> {
  __$$HivStatusImplCopyWithImpl(
      _$HivStatusImpl _value, $Res Function(_$HivStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? label = null,
    Object? children = freezed,
  }) {
    return _then(_$HivStatusImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      children: freezed == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<HivStatus>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HivStatusImpl implements _HivStatus {
  const _$HivStatusImpl(
      {required this.value,
      required this.label,
      final List<HivStatus>? children})
      : _children = children;

  factory _$HivStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$HivStatusImplFromJson(json);

  @override
  final String value;
  @override
  final String label;
  final List<HivStatus>? _children;
  @override
  List<HivStatus>? get children {
    final value = _children;
    if (value == null) return null;
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HivStatus(value: $value, label: $label, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HivStatusImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value, label,
      const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HivStatusImplCopyWith<_$HivStatusImpl> get copyWith =>
      __$$HivStatusImplCopyWithImpl<_$HivStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HivStatusImplToJson(
      this,
    );
  }
}

abstract class _HivStatus implements HivStatus {
  const factory _HivStatus(
      {required final String value,
      required final String label,
      final List<HivStatus>? children}) = _$HivStatusImpl;

  factory _HivStatus.fromJson(Map<String, dynamic> json) =
      _$HivStatusImpl.fromJson;

  @override
  String get value;
  @override
  String get label;
  @override
  List<HivStatus>? get children;
  @override
  @JsonKey(ignore: true)
  _$$HivStatusImplCopyWith<_$HivStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HivStatusControllerState {
  List<HivStatus> get hivStatuses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HivStatusControllerStateCopyWith<HivStatusControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HivStatusControllerStateCopyWith<$Res> {
  factory $HivStatusControllerStateCopyWith(HivStatusControllerState value,
          $Res Function(HivStatusControllerState) then) =
      _$HivStatusControllerStateCopyWithImpl<$Res, HivStatusControllerState>;
  @useResult
  $Res call({List<HivStatus> hivStatuses});
}

/// @nodoc
class _$HivStatusControllerStateCopyWithImpl<$Res,
        $Val extends HivStatusControllerState>
    implements $HivStatusControllerStateCopyWith<$Res> {
  _$HivStatusControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hivStatuses = null,
  }) {
    return _then(_value.copyWith(
      hivStatuses: null == hivStatuses
          ? _value.hivStatuses
          : hivStatuses // ignore: cast_nullable_to_non_nullable
              as List<HivStatus>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HivStatusControllerStateImplCopyWith<$Res>
    implements $HivStatusControllerStateCopyWith<$Res> {
  factory _$$HivStatusControllerStateImplCopyWith(
          _$HivStatusControllerStateImpl value,
          $Res Function(_$HivStatusControllerStateImpl) then) =
      __$$HivStatusControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<HivStatus> hivStatuses});
}

/// @nodoc
class __$$HivStatusControllerStateImplCopyWithImpl<$Res>
    extends _$HivStatusControllerStateCopyWithImpl<$Res,
        _$HivStatusControllerStateImpl>
    implements _$$HivStatusControllerStateImplCopyWith<$Res> {
  __$$HivStatusControllerStateImplCopyWithImpl(
      _$HivStatusControllerStateImpl _value,
      $Res Function(_$HivStatusControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hivStatuses = null,
  }) {
    return _then(_$HivStatusControllerStateImpl(
      hivStatuses: null == hivStatuses
          ? _value._hivStatuses
          : hivStatuses // ignore: cast_nullable_to_non_nullable
              as List<HivStatus>,
    ));
  }
}

/// @nodoc

class _$HivStatusControllerStateImpl implements _HivStatusControllerState {
  const _$HivStatusControllerStateImpl(
      {final List<HivStatus> hivStatuses = const <HivStatus>[]})
      : _hivStatuses = hivStatuses;

  final List<HivStatus> _hivStatuses;
  @override
  @JsonKey()
  List<HivStatus> get hivStatuses {
    if (_hivStatuses is EqualUnmodifiableListView) return _hivStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hivStatuses);
  }

  @override
  String toString() {
    return 'HivStatusControllerState(hivStatuses: $hivStatuses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HivStatusControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._hivStatuses, _hivStatuses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_hivStatuses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HivStatusControllerStateImplCopyWith<_$HivStatusControllerStateImpl>
      get copyWith => __$$HivStatusControllerStateImplCopyWithImpl<
          _$HivStatusControllerStateImpl>(this, _$identity);
}

abstract class _HivStatusControllerState implements HivStatusControllerState {
  const factory _HivStatusControllerState({final List<HivStatus> hivStatuses}) =
      _$HivStatusControllerStateImpl;

  @override
  List<HivStatus> get hivStatuses;
  @override
  @JsonKey(ignore: true)
  _$$HivStatusControllerStateImplCopyWith<_$HivStatusControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
