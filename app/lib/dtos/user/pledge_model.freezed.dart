// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pledge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PledgeModel _$PledgeModelFromJson(Map<String, dynamic> json) {
  return _PledgeModel.fromJson(json);
}

/// @nodoc
mixin _$PledgeModel {
  PledgeOwner get owner => throw _privateConstructorUsedError;
  List<String> get affirmations => throw _privateConstructorUsedError;
  int get version => throw _privateConstructorUsedError;
  bool get hasAccepted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PledgeModelCopyWith<PledgeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PledgeModelCopyWith<$Res> {
  factory $PledgeModelCopyWith(
          PledgeModel value, $Res Function(PledgeModel) then) =
      _$PledgeModelCopyWithImpl<$Res, PledgeModel>;
  @useResult
  $Res call(
      {PledgeOwner owner,
      List<String> affirmations,
      int version,
      bool hasAccepted});
}

/// @nodoc
class _$PledgeModelCopyWithImpl<$Res, $Val extends PledgeModel>
    implements $PledgeModelCopyWith<$Res> {
  _$PledgeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? owner = null,
    Object? affirmations = null,
    Object? version = null,
    Object? hasAccepted = null,
  }) {
    return _then(_value.copyWith(
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as PledgeOwner,
      affirmations: null == affirmations
          ? _value.affirmations
          : affirmations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      hasAccepted: null == hasAccepted
          ? _value.hasAccepted
          : hasAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PledgeModelCopyWith<$Res>
    implements $PledgeModelCopyWith<$Res> {
  factory _$$_PledgeModelCopyWith(
          _$_PledgeModel value, $Res Function(_$_PledgeModel) then) =
      __$$_PledgeModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PledgeOwner owner,
      List<String> affirmations,
      int version,
      bool hasAccepted});
}

/// @nodoc
class __$$_PledgeModelCopyWithImpl<$Res>
    extends _$PledgeModelCopyWithImpl<$Res, _$_PledgeModel>
    implements _$$_PledgeModelCopyWith<$Res> {
  __$$_PledgeModelCopyWithImpl(
      _$_PledgeModel _value, $Res Function(_$_PledgeModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? owner = null,
    Object? affirmations = null,
    Object? version = null,
    Object? hasAccepted = null,
  }) {
    return _then(_$_PledgeModel(
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as PledgeOwner,
      affirmations: null == affirmations
          ? _value._affirmations
          : affirmations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      hasAccepted: null == hasAccepted
          ? _value.hasAccepted
          : hasAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_PledgeModel implements _PledgeModel {
  const _$_PledgeModel(
      {required this.owner,
      required final List<String> affirmations,
      required this.version,
      required this.hasAccepted})
      : _affirmations = affirmations;

  factory _$_PledgeModel.fromJson(Map<String, dynamic> json) =>
      _$$_PledgeModelFromJson(json);

  @override
  final PledgeOwner owner;
  final List<String> _affirmations;
  @override
  List<String> get affirmations {
    if (_affirmations is EqualUnmodifiableListView) return _affirmations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_affirmations);
  }

  @override
  final int version;
  @override
  final bool hasAccepted;

  @override
  String toString() {
    return 'PledgeModel(owner: $owner, affirmations: $affirmations, version: $version, hasAccepted: $hasAccepted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PledgeModel &&
            (identical(other.owner, owner) || other.owner == owner) &&
            const DeepCollectionEquality()
                .equals(other._affirmations, _affirmations) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.hasAccepted, hasAccepted) ||
                other.hasAccepted == hasAccepted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, owner,
      const DeepCollectionEquality().hash(_affirmations), version, hasAccepted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PledgeModelCopyWith<_$_PledgeModel> get copyWith =>
      __$$_PledgeModelCopyWithImpl<_$_PledgeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PledgeModelToJson(
      this,
    );
  }
}

abstract class _PledgeModel implements PledgeModel {
  const factory _PledgeModel(
      {required final PledgeOwner owner,
      required final List<String> affirmations,
      required final int version,
      required final bool hasAccepted}) = _$_PledgeModel;

  factory _PledgeModel.fromJson(Map<String, dynamic> json) =
      _$_PledgeModel.fromJson;

  @override
  PledgeOwner get owner;
  @override
  List<String> get affirmations;
  @override
  int get version;
  @override
  bool get hasAccepted;
  @override
  @JsonKey(ignore: true)
  _$$_PledgeModelCopyWith<_$_PledgeModel> get copyWith =>
      throw _privateConstructorUsedError;
}
