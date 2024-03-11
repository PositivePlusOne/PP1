// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_sectors_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompanySectorsOption _$CompanySectorsOptionFromJson(Map<String, dynamic> json) {
  return _CompanySectorsOption.fromJson(json);
}

/// @nodoc
mixin _$CompanySectorsOption {
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompanySectorsOptionCopyWith<CompanySectorsOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanySectorsOptionCopyWith<$Res> {
  factory $CompanySectorsOptionCopyWith(CompanySectorsOption value,
          $Res Function(CompanySectorsOption) then) =
      _$CompanySectorsOptionCopyWithImpl<$Res, CompanySectorsOption>;
  @useResult
  $Res call({String label, String value});
}

/// @nodoc
class _$CompanySectorsOptionCopyWithImpl<$Res,
        $Val extends CompanySectorsOption>
    implements $CompanySectorsOptionCopyWith<$Res> {
  _$CompanySectorsOptionCopyWithImpl(this._value, this._then);

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
abstract class _$$CompanySectorsOptionImplCopyWith<$Res>
    implements $CompanySectorsOptionCopyWith<$Res> {
  factory _$$CompanySectorsOptionImplCopyWith(_$CompanySectorsOptionImpl value,
          $Res Function(_$CompanySectorsOptionImpl) then) =
      __$$CompanySectorsOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String value});
}

/// @nodoc
class __$$CompanySectorsOptionImplCopyWithImpl<$Res>
    extends _$CompanySectorsOptionCopyWithImpl<$Res, _$CompanySectorsOptionImpl>
    implements _$$CompanySectorsOptionImplCopyWith<$Res> {
  __$$CompanySectorsOptionImplCopyWithImpl(_$CompanySectorsOptionImpl _value,
      $Res Function(_$CompanySectorsOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
  }) {
    return _then(_$CompanySectorsOptionImpl(
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
class _$CompanySectorsOptionImpl extends _CompanySectorsOption {
  const _$CompanySectorsOptionImpl({required this.label, required this.value})
      : super._();

  factory _$CompanySectorsOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanySectorsOptionImplFromJson(json);

  @override
  final String label;
  @override
  final String value;

  @override
  String toString() {
    return 'CompanySectorsOption(label: $label, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanySectorsOptionImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, label, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanySectorsOptionImplCopyWith<_$CompanySectorsOptionImpl>
      get copyWith =>
          __$$CompanySectorsOptionImplCopyWithImpl<_$CompanySectorsOptionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanySectorsOptionImplToJson(
      this,
    );
  }
}

abstract class _CompanySectorsOption extends CompanySectorsOption {
  const factory _CompanySectorsOption(
      {required final String label,
      required final String value}) = _$CompanySectorsOptionImpl;
  const _CompanySectorsOption._() : super._();

  factory _CompanySectorsOption.fromJson(Map<String, dynamic> json) =
      _$CompanySectorsOptionImpl.fromJson;

  @override
  String get label;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$CompanySectorsOptionImplCopyWith<_$CompanySectorsOptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CompanySectorsControllerState {
  List<CompanySectorsOption> get options => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CompanySectorsControllerStateCopyWith<CompanySectorsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanySectorsControllerStateCopyWith<$Res> {
  factory $CompanySectorsControllerStateCopyWith(
          CompanySectorsControllerState value,
          $Res Function(CompanySectorsControllerState) then) =
      _$CompanySectorsControllerStateCopyWithImpl<$Res,
          CompanySectorsControllerState>;
  @useResult
  $Res call({List<CompanySectorsOption> options});
}

/// @nodoc
class _$CompanySectorsControllerStateCopyWithImpl<$Res,
        $Val extends CompanySectorsControllerState>
    implements $CompanySectorsControllerStateCopyWith<$Res> {
  _$CompanySectorsControllerStateCopyWithImpl(this._value, this._then);

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
              as List<CompanySectorsOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanySectorsControllerStateImplCopyWith<$Res>
    implements $CompanySectorsControllerStateCopyWith<$Res> {
  factory _$$CompanySectorsControllerStateImplCopyWith(
          _$CompanySectorsControllerStateImpl value,
          $Res Function(_$CompanySectorsControllerStateImpl) then) =
      __$$CompanySectorsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CompanySectorsOption> options});
}

/// @nodoc
class __$$CompanySectorsControllerStateImplCopyWithImpl<$Res>
    extends _$CompanySectorsControllerStateCopyWithImpl<$Res,
        _$CompanySectorsControllerStateImpl>
    implements _$$CompanySectorsControllerStateImplCopyWith<$Res> {
  __$$CompanySectorsControllerStateImplCopyWithImpl(
      _$CompanySectorsControllerStateImpl _value,
      $Res Function(_$CompanySectorsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? options = null,
  }) {
    return _then(_$CompanySectorsControllerStateImpl(
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<CompanySectorsOption>,
    ));
  }
}

/// @nodoc

class _$CompanySectorsControllerStateImpl
    extends _CompanySectorsControllerState {
  const _$CompanySectorsControllerStateImpl(
      {final List<CompanySectorsOption> options =
          const <CompanySectorsOption>[]})
      : _options = options,
        super._();

  final List<CompanySectorsOption> _options;
  @override
  @JsonKey()
  List<CompanySectorsOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'CompanySectorsControllerState(options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanySectorsControllerStateImpl &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanySectorsControllerStateImplCopyWith<
          _$CompanySectorsControllerStateImpl>
      get copyWith => __$$CompanySectorsControllerStateImplCopyWithImpl<
          _$CompanySectorsControllerStateImpl>(this, _$identity);
}

abstract class _CompanySectorsControllerState
    extends CompanySectorsControllerState {
  const factory _CompanySectorsControllerState(
          {final List<CompanySectorsOption> options}) =
      _$CompanySectorsControllerStateImpl;
  const _CompanySectorsControllerState._() : super._();

  @override
  List<CompanySectorsOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$CompanySectorsControllerStateImplCopyWith<
          _$CompanySectorsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
