// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design_system_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DesignSystemState _$DesignSystemStateFromJson(Map<String, dynamic> json) {
  return _DesignSystemState.fromJson(json);
}

/// @nodoc
mixin _$DesignSystemState {
  DesignSystemBrand get brand => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemStateCopyWith<DesignSystemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemStateCopyWith<$Res> {
  factory $DesignSystemStateCopyWith(
          DesignSystemState value, $Res Function(DesignSystemState) then) =
      _$DesignSystemStateCopyWithImpl<$Res>;
  $Res call({DesignSystemBrand brand});

  $DesignSystemBrandCopyWith<$Res> get brand;
}

/// @nodoc
class _$DesignSystemStateCopyWithImpl<$Res>
    implements $DesignSystemStateCopyWith<$Res> {
  _$DesignSystemStateCopyWithImpl(this._value, this._then);

  final DesignSystemState _value;
  // ignore: unused_field
  final $Res Function(DesignSystemState) _then;

  @override
  $Res call({
    Object? brand = freezed,
  }) {
    return _then(_value.copyWith(
      brand: brand == freezed
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as DesignSystemBrand,
    ));
  }

  @override
  $DesignSystemBrandCopyWith<$Res> get brand {
    return $DesignSystemBrandCopyWith<$Res>(_value.brand, (value) {
      return _then(_value.copyWith(brand: value));
    });
  }
}

/// @nodoc
abstract class _$$_DesignSystemStateCopyWith<$Res>
    implements $DesignSystemStateCopyWith<$Res> {
  factory _$$_DesignSystemStateCopyWith(_$_DesignSystemState value,
          $Res Function(_$_DesignSystemState) then) =
      __$$_DesignSystemStateCopyWithImpl<$Res>;
  @override
  $Res call({DesignSystemBrand brand});

  @override
  $DesignSystemBrandCopyWith<$Res> get brand;
}

/// @nodoc
class __$$_DesignSystemStateCopyWithImpl<$Res>
    extends _$DesignSystemStateCopyWithImpl<$Res>
    implements _$$_DesignSystemStateCopyWith<$Res> {
  __$$_DesignSystemStateCopyWithImpl(
      _$_DesignSystemState _value, $Res Function(_$_DesignSystemState) _then)
      : super(_value, (v) => _then(v as _$_DesignSystemState));

  @override
  _$_DesignSystemState get _value => super._value as _$_DesignSystemState;

  @override
  $Res call({
    Object? brand = freezed,
  }) {
    return _then(_$_DesignSystemState(
      brand: brand == freezed
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as DesignSystemBrand,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_DesignSystemState implements _DesignSystemState {
  const _$_DesignSystemState({required this.brand});

  factory _$_DesignSystemState.fromJson(Map<String, dynamic> json) =>
      _$$_DesignSystemStateFromJson(json);

  @override
  final DesignSystemBrand brand;

  @override
  String toString() {
    return 'DesignSystemState(brand: $brand)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignSystemState &&
            const DeepCollectionEquality().equals(other.brand, brand));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(brand));

  @JsonKey(ignore: true)
  @override
  _$$_DesignSystemStateCopyWith<_$_DesignSystemState> get copyWith =>
      __$$_DesignSystemStateCopyWithImpl<_$_DesignSystemState>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignSystemStateToJson(
      this,
    );
  }
}

abstract class _DesignSystemState implements DesignSystemState {
  const factory _DesignSystemState({required final DesignSystemBrand brand}) =
      _$_DesignSystemState;

  factory _DesignSystemState.fromJson(Map<String, dynamic> json) =
      _$_DesignSystemState.fromJson;

  @override
  DesignSystemBrand get brand;
  @override
  @JsonKey(ignore: true)
  _$$_DesignSystemStateCopyWith<_$_DesignSystemState> get copyWith =>
      throw _privateConstructorUsedError;
}
