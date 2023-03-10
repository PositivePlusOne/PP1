// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hiv_status_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HivStatus {
  String get label => throw _privateConstructorUsedError;
  List<HivStatus>? get children => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HivStatusCopyWith<HivStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HivStatusCopyWith<$Res> {
  factory $HivStatusCopyWith(HivStatus value, $Res Function(HivStatus) then) =
      _$HivStatusCopyWithImpl<$Res, HivStatus>;
  @useResult
  $Res call({String label, List<HivStatus>? children});
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
    Object? label = null,
    Object? children = freezed,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$_HivStatusCopyWith<$Res> implements $HivStatusCopyWith<$Res> {
  factory _$$_HivStatusCopyWith(
          _$_HivStatus value, $Res Function(_$_HivStatus) then) =
      __$$_HivStatusCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, List<HivStatus>? children});
}

/// @nodoc
class __$$_HivStatusCopyWithImpl<$Res>
    extends _$HivStatusCopyWithImpl<$Res, _$_HivStatus>
    implements _$$_HivStatusCopyWith<$Res> {
  __$$_HivStatusCopyWithImpl(
      _$_HivStatus _value, $Res Function(_$_HivStatus) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? children = freezed,
  }) {
    return _then(_$_HivStatus(
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

class _$_HivStatus implements _HivStatus {
  const _$_HivStatus({required this.label, final List<HivStatus>? children})
      : _children = children;

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
    return 'HivStatus(label: $label, children: $children)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HivStatus &&
            (identical(other.label, label) || other.label == label) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, label, const DeepCollectionEquality().hash(_children));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HivStatusCopyWith<_$_HivStatus> get copyWith =>
      __$$_HivStatusCopyWithImpl<_$_HivStatus>(this, _$identity);
}

abstract class _HivStatus implements HivStatus {
  const factory _HivStatus(
      {required final String label,
      final List<HivStatus>? children}) = _$_HivStatus;

  @override
  String get label;
  @override
  List<HivStatus>? get children;
  @override
  @JsonKey(ignore: true)
  _$$_HivStatusCopyWith<_$_HivStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$HivStatusViewModelState {
  List<HivStatus> get options => throw _privateConstructorUsedError;
  HivStatus? get selectedStatus => throw _privateConstructorUsedError;
  HivStatus? get selectedSecondaryStatus => throw _privateConstructorUsedError;
  bool get displayInApp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HivStatusViewModelStateCopyWith<HivStatusViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HivStatusViewModelStateCopyWith<$Res> {
  factory $HivStatusViewModelStateCopyWith(HivStatusViewModelState value,
          $Res Function(HivStatusViewModelState) then) =
      _$HivStatusViewModelStateCopyWithImpl<$Res, HivStatusViewModelState>;
  @useResult
  $Res call(
      {List<HivStatus> options,
      HivStatus? selectedStatus,
      HivStatus? selectedSecondaryStatus,
      bool displayInApp});

  $HivStatusCopyWith<$Res>? get selectedStatus;
  $HivStatusCopyWith<$Res>? get selectedSecondaryStatus;
}

/// @nodoc
class _$HivStatusViewModelStateCopyWithImpl<$Res,
        $Val extends HivStatusViewModelState>
    implements $HivStatusViewModelStateCopyWith<$Res> {
  _$HivStatusViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? selectedStatus = freezed,
    Object? selectedSecondaryStatus = freezed,
    Object? displayInApp = null,
  }) {
    return _then(_value.copyWith(
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<HivStatus>,
      selectedStatus: freezed == selectedStatus
          ? _value.selectedStatus
          : selectedStatus // ignore: cast_nullable_to_non_nullable
              as HivStatus?,
      selectedSecondaryStatus: freezed == selectedSecondaryStatus
          ? _value.selectedSecondaryStatus
          : selectedSecondaryStatus // ignore: cast_nullable_to_non_nullable
              as HivStatus?,
      displayInApp: null == displayInApp
          ? _value.displayInApp
          : displayInApp // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HivStatusCopyWith<$Res>? get selectedStatus {
    if (_value.selectedStatus == null) {
      return null;
    }

    return $HivStatusCopyWith<$Res>(_value.selectedStatus!, (value) {
      return _then(_value.copyWith(selectedStatus: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $HivStatusCopyWith<$Res>? get selectedSecondaryStatus {
    if (_value.selectedSecondaryStatus == null) {
      return null;
    }

    return $HivStatusCopyWith<$Res>(_value.selectedSecondaryStatus!, (value) {
      return _then(_value.copyWith(selectedSecondaryStatus: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_HivStatusViewModelStateCopyWith<$Res>
    implements $HivStatusViewModelStateCopyWith<$Res> {
  factory _$$_HivStatusViewModelStateCopyWith(_$_HivStatusViewModelState value,
          $Res Function(_$_HivStatusViewModelState) then) =
      __$$_HivStatusViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<HivStatus> options,
      HivStatus? selectedStatus,
      HivStatus? selectedSecondaryStatus,
      bool displayInApp});

  @override
  $HivStatusCopyWith<$Res>? get selectedStatus;
  @override
  $HivStatusCopyWith<$Res>? get selectedSecondaryStatus;
}

/// @nodoc
class __$$_HivStatusViewModelStateCopyWithImpl<$Res>
    extends _$HivStatusViewModelStateCopyWithImpl<$Res,
        _$_HivStatusViewModelState>
    implements _$$_HivStatusViewModelStateCopyWith<$Res> {
  __$$_HivStatusViewModelStateCopyWithImpl(_$_HivStatusViewModelState _value,
      $Res Function(_$_HivStatusViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
    Object? selectedStatus = freezed,
    Object? selectedSecondaryStatus = freezed,
    Object? displayInApp = null,
  }) {
    return _then(_$_HivStatusViewModelState(
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<HivStatus>,
      selectedStatus: freezed == selectedStatus
          ? _value.selectedStatus
          : selectedStatus // ignore: cast_nullable_to_non_nullable
              as HivStatus?,
      selectedSecondaryStatus: freezed == selectedSecondaryStatus
          ? _value.selectedSecondaryStatus
          : selectedSecondaryStatus // ignore: cast_nullable_to_non_nullable
              as HivStatus?,
      displayInApp: null == displayInApp
          ? _value.displayInApp
          : displayInApp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_HivStatusViewModelState implements _HivStatusViewModelState {
  const _$_HivStatusViewModelState(
      {final List<HivStatus> options = const <HivStatus>[],
      this.selectedStatus,
      this.selectedSecondaryStatus,
      this.displayInApp = true})
      : _options = options;

  final List<HivStatus> _options;
  @override
  @JsonKey()
  List<HivStatus> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  final HivStatus? selectedStatus;
  @override
  final HivStatus? selectedSecondaryStatus;
  @override
  @JsonKey()
  final bool displayInApp;

  @override
  String toString() {
    return 'HivStatusViewModelState(options: $options, selectedStatus: $selectedStatus, selectedSecondaryStatus: $selectedSecondaryStatus, displayInApp: $displayInApp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HivStatusViewModelState &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.selectedStatus, selectedStatus) ||
                other.selectedStatus == selectedStatus) &&
            (identical(
                    other.selectedSecondaryStatus, selectedSecondaryStatus) ||
                other.selectedSecondaryStatus == selectedSecondaryStatus) &&
            (identical(other.displayInApp, displayInApp) ||
                other.displayInApp == displayInApp));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_options),
      selectedStatus,
      selectedSecondaryStatus,
      displayInApp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HivStatusViewModelStateCopyWith<_$_HivStatusViewModelState>
      get copyWith =>
          __$$_HivStatusViewModelStateCopyWithImpl<_$_HivStatusViewModelState>(
              this, _$identity);
}

abstract class _HivStatusViewModelState implements HivStatusViewModelState {
  const factory _HivStatusViewModelState(
      {final List<HivStatus> options,
      final HivStatus? selectedStatus,
      final HivStatus? selectedSecondaryStatus,
      final bool displayInApp}) = _$_HivStatusViewModelState;

  @override
  List<HivStatus> get options;
  @override
  HivStatus? get selectedStatus;
  @override
  HivStatus? get selectedSecondaryStatus;
  @override
  bool get displayInApp;
  @override
  @JsonKey(ignore: true)
  _$$_HivStatusViewModelStateCopyWith<_$_HivStatusViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
