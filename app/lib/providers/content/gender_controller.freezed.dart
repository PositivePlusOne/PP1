// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gender_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GenderOption _$GenderOptionFromJson(Map<String, dynamic> json) {
  return _GenderOption.fromJson(json);
}

/// @nodoc
mixin _$GenderOption {
  /// The localized version to display
  String get label => throw _privateConstructorUsedError;

  /// The key of the local
  String get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GenderOptionCopyWith<GenderOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenderOptionCopyWith<$Res> {
  factory $GenderOptionCopyWith(
          GenderOption value, $Res Function(GenderOption) then) =
      _$GenderOptionCopyWithImpl<$Res, GenderOption>;
  @useResult
  $Res call({String label, String value});
}

/// @nodoc
class _$GenderOptionCopyWithImpl<$Res, $Val extends GenderOption>
    implements $GenderOptionCopyWith<$Res> {
  _$GenderOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GenderOptionCopyWith<$Res>
    implements $GenderOptionCopyWith<$Res> {
  factory _$$_GenderOptionCopyWith(
          _$_GenderOption value, $Res Function(_$_GenderOption) then) =
      __$$_GenderOptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String value});
}

/// @nodoc
class __$$_GenderOptionCopyWithImpl<$Res>
    extends _$GenderOptionCopyWithImpl<$Res, _$_GenderOption>
    implements _$$_GenderOptionCopyWith<$Res> {
  __$$_GenderOptionCopyWithImpl(
      _$_GenderOption _value, $Res Function(_$_GenderOption) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
  }) {
    return _then(_$_GenderOption(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GenderOption extends _GenderOption {
  const _$_GenderOption({required this.label, required this.value}) : super._();

  factory _$_GenderOption.fromJson(Map<String, dynamic> json) =>
      _$$_GenderOptionFromJson(json);

  /// The localized version to display
  @override
  final String label;

  /// The key of the local
  @override
  final String value;

  @override
  String toString() {
    return 'GenderOption(label: $label, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GenderOption &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GenderOptionCopyWith<_$_GenderOption> get copyWith =>
      __$$_GenderOptionCopyWithImpl<_$_GenderOption>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GenderOptionToJson(
      this,
    );
  }
}

abstract class _GenderOption extends GenderOption {
  const factory _GenderOption(
      {required final String label,
      required final String value}) = _$_GenderOption;
  const _GenderOption._() : super._();

  factory _GenderOption.fromJson(Map<String, dynamic> json) =
      _$_GenderOption.fromJson;

  @override

  /// The localized version to display
  String get label;
  @override

  /// The key of the local
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$_GenderOptionCopyWith<_$_GenderOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GenderControllerState {
  List<GenderOption> get options => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GenderControllerStateCopyWith<GenderControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenderControllerStateCopyWith<$Res> {
  factory $GenderControllerStateCopyWith(GenderControllerState value,
          $Res Function(GenderControllerState) then) =
      _$GenderControllerStateCopyWithImpl<$Res, GenderControllerState>;
  @useResult
  $Res call({List<GenderOption> options});
}

/// @nodoc
class _$GenderControllerStateCopyWithImpl<$Res,
        $Val extends GenderControllerState>
    implements $GenderControllerStateCopyWith<$Res> {
  _$GenderControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GenderControllerStateCopyWith<$Res>
    implements $GenderControllerStateCopyWith<$Res> {
  factory _$$_GenderControllerStateCopyWith(_$_GenderControllerState value,
          $Res Function(_$_GenderControllerState) then) =
      __$$_GenderControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<GenderOption> options});
}

/// @nodoc
class __$$_GenderControllerStateCopyWithImpl<$Res>
    extends _$GenderControllerStateCopyWithImpl<$Res, _$_GenderControllerState>
    implements _$$_GenderControllerStateCopyWith<$Res> {
  __$$_GenderControllerStateCopyWithImpl(_$_GenderControllerState _value,
      $Res Function(_$_GenderControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
  }) {
    return _then(_$_GenderControllerState(
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>,
    ));
  }
}

/// @nodoc

class _$_GenderControllerState extends _GenderControllerState {
  const _$_GenderControllerState(
      {final List<GenderOption> options = const <GenderOption>[]})
      : _options = options,
        super._();

  final List<GenderOption> _options;
  @override
  @JsonKey()
  List<GenderOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'GenderControllerState(options: $options)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GenderControllerState &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GenderControllerStateCopyWith<_$_GenderControllerState> get copyWith =>
      __$$_GenderControllerStateCopyWithImpl<_$_GenderControllerState>(
          this, _$identity);
}

abstract class _GenderControllerState extends GenderControllerState {
  const factory _GenderControllerState({final List<GenderOption> options}) =
      _$_GenderControllerState;
  const _GenderControllerState._() : super._();

  @override
  List<GenderOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$_GenderControllerStateCopyWith<_$_GenderControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
