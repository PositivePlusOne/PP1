// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'positive_restricted_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PositiveRestrictedPlace _$PositiveRestrictedPlaceFromJson(
    Map<String, dynamic> json) {
  return _PositiveRestrictedPlace.fromJson(json);
}

/// @nodoc
mixin _$PositiveRestrictedPlace {
  @JsonKey(
      fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
      toJson: PositiveRestrictedPlaceEnforcementType.toJson)
  PositiveRestrictedPlaceEnforcementType get enforcementType =>
      throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
      toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
  PositiveRestrictedPlaceEnforcementMatcher get enforcementMatcher =>
      throw _privateConstructorUsedError;
  String get enforcementValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PositiveRestrictedPlaceCopyWith<PositiveRestrictedPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositiveRestrictedPlaceCopyWith<$Res> {
  factory $PositiveRestrictedPlaceCopyWith(PositiveRestrictedPlace value,
          $Res Function(PositiveRestrictedPlace) then) =
      _$PositiveRestrictedPlaceCopyWithImpl<$Res, PositiveRestrictedPlace>;
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementType.toJson)
      PositiveRestrictedPlaceEnforcementType enforcementType,
      @JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
      PositiveRestrictedPlaceEnforcementMatcher enforcementMatcher,
      String enforcementValue});

  $PositiveRestrictedPlaceEnforcementTypeCopyWith<$Res> get enforcementType;
  $PositiveRestrictedPlaceEnforcementMatcherCopyWith<$Res>
      get enforcementMatcher;
}

/// @nodoc
class _$PositiveRestrictedPlaceCopyWithImpl<$Res,
        $Val extends PositiveRestrictedPlace>
    implements $PositiveRestrictedPlaceCopyWith<$Res> {
  _$PositiveRestrictedPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enforcementType = null,
    Object? enforcementMatcher = null,
    Object? enforcementValue = null,
  }) {
    return _then(_value.copyWith(
      enforcementType: null == enforcementType
          ? _value.enforcementType
          : enforcementType // ignore: cast_nullable_to_non_nullable
              as PositiveRestrictedPlaceEnforcementType,
      enforcementMatcher: null == enforcementMatcher
          ? _value.enforcementMatcher
          : enforcementMatcher // ignore: cast_nullable_to_non_nullable
              as PositiveRestrictedPlaceEnforcementMatcher,
      enforcementValue: null == enforcementValue
          ? _value.enforcementValue
          : enforcementValue // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PositiveRestrictedPlaceEnforcementTypeCopyWith<$Res> get enforcementType {
    return $PositiveRestrictedPlaceEnforcementTypeCopyWith<$Res>(
        _value.enforcementType, (value) {
      return _then(_value.copyWith(enforcementType: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PositiveRestrictedPlaceEnforcementMatcherCopyWith<$Res>
      get enforcementMatcher {
    return $PositiveRestrictedPlaceEnforcementMatcherCopyWith<$Res>(
        _value.enforcementMatcher, (value) {
      return _then(_value.copyWith(enforcementMatcher: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceImplCopyWith<$Res>
    implements $PositiveRestrictedPlaceCopyWith<$Res> {
  factory _$$PositiveRestrictedPlaceImplCopyWith(
          _$PositiveRestrictedPlaceImpl value,
          $Res Function(_$PositiveRestrictedPlaceImpl) then) =
      __$$PositiveRestrictedPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementType.toJson)
      PositiveRestrictedPlaceEnforcementType enforcementType,
      @JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
      PositiveRestrictedPlaceEnforcementMatcher enforcementMatcher,
      String enforcementValue});

  @override
  $PositiveRestrictedPlaceEnforcementTypeCopyWith<$Res> get enforcementType;
  @override
  $PositiveRestrictedPlaceEnforcementMatcherCopyWith<$Res>
      get enforcementMatcher;
}

/// @nodoc
class __$$PositiveRestrictedPlaceImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceImpl>
    implements _$$PositiveRestrictedPlaceImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceImplCopyWithImpl(
      _$PositiveRestrictedPlaceImpl _value,
      $Res Function(_$PositiveRestrictedPlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? enforcementType = null,
    Object? enforcementMatcher = null,
    Object? enforcementValue = null,
  }) {
    return _then(_$PositiveRestrictedPlaceImpl(
      enforcementType: null == enforcementType
          ? _value.enforcementType
          : enforcementType // ignore: cast_nullable_to_non_nullable
              as PositiveRestrictedPlaceEnforcementType,
      enforcementMatcher: null == enforcementMatcher
          ? _value.enforcementMatcher
          : enforcementMatcher // ignore: cast_nullable_to_non_nullable
              as PositiveRestrictedPlaceEnforcementMatcher,
      enforcementValue: null == enforcementValue
          ? _value.enforcementValue
          : enforcementValue // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PositiveRestrictedPlaceImpl implements _PositiveRestrictedPlace {
  const _$PositiveRestrictedPlaceImpl(
      {@JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementType.toJson)
      this.enforcementType =
          const PositiveRestrictedPlaceEnforcementType.unknown(),
      @JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
      this.enforcementMatcher =
          const PositiveRestrictedPlaceEnforcementMatcher.unknown(),
      this.enforcementValue = ''});

  factory _$PositiveRestrictedPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositiveRestrictedPlaceImplFromJson(json);

  @override
  @JsonKey(
      fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
      toJson: PositiveRestrictedPlaceEnforcementType.toJson)
  final PositiveRestrictedPlaceEnforcementType enforcementType;
  @override
  @JsonKey(
      fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
      toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
  final PositiveRestrictedPlaceEnforcementMatcher enforcementMatcher;
  @override
  @JsonKey()
  final String enforcementValue;

  @override
  String toString() {
    return 'PositiveRestrictedPlace(enforcementType: $enforcementType, enforcementMatcher: $enforcementMatcher, enforcementValue: $enforcementValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceImpl &&
            (identical(other.enforcementType, enforcementType) ||
                other.enforcementType == enforcementType) &&
            (identical(other.enforcementMatcher, enforcementMatcher) ||
                other.enforcementMatcher == enforcementMatcher) &&
            (identical(other.enforcementValue, enforcementValue) ||
                other.enforcementValue == enforcementValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, enforcementType, enforcementMatcher, enforcementValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PositiveRestrictedPlaceImplCopyWith<_$PositiveRestrictedPlaceImpl>
      get copyWith => __$$PositiveRestrictedPlaceImplCopyWithImpl<
          _$PositiveRestrictedPlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositiveRestrictedPlaceImplToJson(
      this,
    );
  }
}

abstract class _PositiveRestrictedPlace implements PositiveRestrictedPlace {
  const factory _PositiveRestrictedPlace(
      {@JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementType.toJson)
      final PositiveRestrictedPlaceEnforcementType enforcementType,
      @JsonKey(
          fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
          toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
      final PositiveRestrictedPlaceEnforcementMatcher enforcementMatcher,
      final String enforcementValue}) = _$PositiveRestrictedPlaceImpl;

  factory _PositiveRestrictedPlace.fromJson(Map<String, dynamic> json) =
      _$PositiveRestrictedPlaceImpl.fromJson;

  @override
  @JsonKey(
      fromJson: PositiveRestrictedPlaceEnforcementType.fromJson,
      toJson: PositiveRestrictedPlaceEnforcementType.toJson)
  PositiveRestrictedPlaceEnforcementType get enforcementType;
  @override
  @JsonKey(
      fromJson: PositiveRestrictedPlaceEnforcementMatcher.fromJson,
      toJson: PositiveRestrictedPlaceEnforcementMatcher.toJson)
  PositiveRestrictedPlaceEnforcementMatcher get enforcementMatcher;
  @override
  String get enforcementValue;
  @override
  @JsonKey(ignore: true)
  _$$PositiveRestrictedPlaceImplCopyWith<_$PositiveRestrictedPlaceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PositiveRestrictedPlaceEnforcementMatcher {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositiveRestrictedPlaceEnforcementMatcherCopyWith<$Res> {
  factory $PositiveRestrictedPlaceEnforcementMatcherCopyWith(
          PositiveRestrictedPlaceEnforcementMatcher value,
          $Res Function(PositiveRestrictedPlaceEnforcementMatcher) then) =
      _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
          PositiveRestrictedPlaceEnforcementMatcher>;
}

/// @nodoc
class _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        $Val extends PositiveRestrictedPlaceEnforcementMatcher>
    implements $PositiveRestrictedPlaceEnforcementMatcherCopyWith<$Res> {
  _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl(
      this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherEqualImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherEqualImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherEqualImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherEqualImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherEqualImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherEqualImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherEqualImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherEqualImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherEqual {
  const _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.equal()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return equal();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return equal?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (equal != null) {
      return equal();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return equal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return equal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (equal != null) {
      return equal(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherEqual
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherEqual() =
      _$PositiveRestrictedPlaceEnforcementMatcherEqualImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherNotEqualImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherNotEqualImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherNotEqualImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherNotEqualImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherNotEqualImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherNotEqualImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherNotEqual {
  const _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.notEqual()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return notEqual();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return notEqual?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (notEqual != null) {
      return notEqual();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return notEqual(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return notEqual?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (notEqual != null) {
      return notEqual(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherNotEqual
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherNotEqual() =
      _$PositiveRestrictedPlaceEnforcementMatcherNotEqualImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherLessThanImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherLessThanImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherLessThanImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherLessThanImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherLessThanImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherLessThanImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherLessThan {
  const _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.lessThan()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return lessThan();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return lessThan?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (lessThan != null) {
      return lessThan();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return lessThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return lessThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (lessThan != null) {
      return lessThan(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherLessThan
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherLessThan() =
      _$PositiveRestrictedPlaceEnforcementMatcherLessThanImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl value,
          $Res Function(
                  _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImplCopyWith<
            $Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl _value,
      $Res Function(
              _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual {
  const _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.lessThanOrEqual()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return lessThanOrEqual();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return lessThanOrEqual?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (lessThanOrEqual != null) {
      return lessThanOrEqual();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return lessThanOrEqual(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return lessThanOrEqual?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (lessThanOrEqual != null) {
      return lessThanOrEqual(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual() =
      _$PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqualImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl value,
          $Res Function(
                  _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImplCopyWith<
            $Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherGreaterThan {
  const _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.greaterThan()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return greaterThan();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return greaterThan?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (greaterThan != null) {
      return greaterThan();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return greaterThan(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return greaterThan?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (greaterThan != null) {
      return greaterThan(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherGreaterThan
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherGreaterThan() =
      _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl value,
          $Res Function(
                  _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImplCopyWith<
            $Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl _value,
      $Res Function(
              _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual {
  const _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.greaterThanOrEqual()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return greaterThanOrEqual();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return greaterThanOrEqual?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (greaterThanOrEqual != null) {
      return greaterThanOrEqual();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return greaterThanOrEqual(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return greaterThanOrEqual?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (greaterThanOrEqual != null) {
      return greaterThanOrEqual(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual() =
      _$PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqualImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementMatcherUnknownImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementMatcherUnknownImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementMatcherUnknownImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementMatcherUnknownImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceEnforcementMatcherCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementMatcherUnknownImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementMatcherUnknownImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl
    implements _PositiveRestrictedPlaceEnforcementMatcherUnknown {
  const _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementMatcher.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() equal,
    required TResult Function() notEqual,
    required TResult Function() lessThan,
    required TResult Function() lessThanOrEqual,
    required TResult Function() greaterThan,
    required TResult Function() greaterThanOrEqual,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? equal,
    TResult? Function()? notEqual,
    TResult? Function()? lessThan,
    TResult? Function()? lessThanOrEqual,
    TResult? Function()? greaterThan,
    TResult? Function()? greaterThanOrEqual,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? equal,
    TResult Function()? notEqual,
    TResult Function()? lessThan,
    TResult Function()? lessThanOrEqual,
    TResult Function()? greaterThan,
    TResult Function()? greaterThanOrEqual,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherEqual value)
        equal,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherNotEqual value)
        notEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThan value)
        lessThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)
        lessThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)
        greaterThan,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)
        greaterThanOrEqual,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherUnknown value)
        unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult? Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherEqual value)?
        equal,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherNotEqual value)?
        notEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherLessThan value)?
        lessThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherLessThanOrEqual value)?
        lessThanOrEqual,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThan value)?
        greaterThan,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementMatcherGreaterThanOrEqual value)?
        greaterThanOrEqual,
    TResult Function(_PositiveRestrictedPlaceEnforcementMatcherUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementMatcherUnknown
    implements PositiveRestrictedPlaceEnforcementMatcher {
  const factory _PositiveRestrictedPlaceEnforcementMatcherUnknown() =
      _$PositiveRestrictedPlaceEnforcementMatcherUnknownImpl;
}

/// @nodoc
mixin _$PositiveRestrictedPlaceEnforcementType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositiveRestrictedPlaceEnforcementTypeCopyWith<$Res> {
  factory $PositiveRestrictedPlaceEnforcementTypeCopyWith(
          PositiveRestrictedPlaceEnforcementType value,
          $Res Function(PositiveRestrictedPlaceEnforcementType) then) =
      _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
          PositiveRestrictedPlaceEnforcementType>;
}

/// @nodoc
class _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        $Val extends PositiveRestrictedPlaceEnforcementType>
    implements $PositiveRestrictedPlaceEnforcementTypeCopyWith<$Res> {
  _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl
              value,
          $Res Function(
                  _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImplCopyWith<
            $Res> {
  __$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl
          _value,
      $Res Function(
              _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl
    implements
        _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne {
  const _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementType.administrativeAreaLevelOne()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) {
    return administrativeAreaLevelOne();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) {
    return administrativeAreaLevelOne?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (administrativeAreaLevelOne != null) {
      return administrativeAreaLevelOne();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) {
    return administrativeAreaLevelOne(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) {
    return administrativeAreaLevelOne?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (administrativeAreaLevelOne != null) {
      return administrativeAreaLevelOne(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
    implements PositiveRestrictedPlaceEnforcementType {
  const factory _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne() =
      _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOneImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl
              value,
          $Res Function(
                  _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImplCopyWithImpl<
          $Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImplCopyWithImpl<
        $Res>
    extends _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImplCopyWith<
            $Res> {
  __$$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl
          _value,
      $Res Function(
              _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl)
          _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl
    implements
        _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo {
  const _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementType.administrativeAreaLevelTwo()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other
                is _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) {
    return administrativeAreaLevelTwo();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) {
    return administrativeAreaLevelTwo?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (administrativeAreaLevelTwo != null) {
      return administrativeAreaLevelTwo();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) {
    return administrativeAreaLevelTwo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) {
    return administrativeAreaLevelTwo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (administrativeAreaLevelTwo != null) {
      return administrativeAreaLevelTwo(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
    implements PositiveRestrictedPlaceEnforcementType {
  const factory _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo() =
      _$PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwoImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementTypeCountryImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementTypeCountryImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementTypeCountryImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementTypeCountryImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementTypeCountryImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementTypeCountryImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementTypeCountryImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementTypeCountryImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementTypeCountryImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementTypeCountryImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementTypeCountryImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementTypeCountryImpl
    implements _PositiveRestrictedPlaceEnforcementTypeCountry {
  const _$PositiveRestrictedPlaceEnforcementTypeCountryImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementType.country()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementTypeCountryImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) {
    return country();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) {
    return country?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (country != null) {
      return country();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) {
    return country(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) {
    return country?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (country != null) {
      return country(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementTypeCountry
    implements PositiveRestrictedPlaceEnforcementType {
  const factory _PositiveRestrictedPlaceEnforcementTypeCountry() =
      _$PositiveRestrictedPlaceEnforcementTypeCountryImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementTypeLocalityImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementTypeLocalityImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementTypeLocalityImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementTypeLocalityImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementTypeLocalityImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementTypeLocalityImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementTypeLocalityImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementTypeLocalityImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl
    implements _PositiveRestrictedPlaceEnforcementTypeLocality {
  const _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementType.locality()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) {
    return locality();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) {
    return locality?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (locality != null) {
      return locality();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) {
    return locality(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) {
    return locality?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (locality != null) {
      return locality(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementTypeLocality
    implements PositiveRestrictedPlaceEnforcementType {
  const factory _PositiveRestrictedPlaceEnforcementTypeLocality() =
      _$PositiveRestrictedPlaceEnforcementTypeLocalityImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementTypeDistanceImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementTypeDistanceImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementTypeDistanceImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementTypeDistanceImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementTypeDistanceImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementTypeDistanceImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementTypeDistanceImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementTypeDistanceImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl
    implements _PositiveRestrictedPlaceEnforcementTypeDistance {
  const _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementType.distance()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) {
    return distance();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) {
    return distance?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (distance != null) {
      return distance();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) {
    return distance(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) {
    return distance?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (distance != null) {
      return distance(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementTypeDistance
    implements PositiveRestrictedPlaceEnforcementType {
  const factory _PositiveRestrictedPlaceEnforcementTypeDistance() =
      _$PositiveRestrictedPlaceEnforcementTypeDistanceImpl;
}

/// @nodoc
abstract class _$$PositiveRestrictedPlaceEnforcementTypeUnknownImplCopyWith<
    $Res> {
  factory _$$PositiveRestrictedPlaceEnforcementTypeUnknownImplCopyWith(
          _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl value,
          $Res Function(_$PositiveRestrictedPlaceEnforcementTypeUnknownImpl)
              then) =
      __$$PositiveRestrictedPlaceEnforcementTypeUnknownImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PositiveRestrictedPlaceEnforcementTypeUnknownImplCopyWithImpl<$Res>
    extends _$PositiveRestrictedPlaceEnforcementTypeCopyWithImpl<$Res,
        _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl>
    implements
        _$$PositiveRestrictedPlaceEnforcementTypeUnknownImplCopyWith<$Res> {
  __$$PositiveRestrictedPlaceEnforcementTypeUnknownImplCopyWithImpl(
      _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl _value,
      $Res Function(_$PositiveRestrictedPlaceEnforcementTypeUnknownImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl
    implements _PositiveRestrictedPlaceEnforcementTypeUnknown {
  const _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl();

  @override
  String toString() {
    return 'PositiveRestrictedPlaceEnforcementType.unknown()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() administrativeAreaLevelOne,
    required TResult Function() administrativeAreaLevelTwo,
    required TResult Function() country,
    required TResult Function() locality,
    required TResult Function() distance,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? administrativeAreaLevelOne,
    TResult? Function()? administrativeAreaLevelTwo,
    TResult? Function()? country,
    TResult? Function()? locality,
    TResult? Function()? distance,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? administrativeAreaLevelOne,
    TResult Function()? administrativeAreaLevelTwo,
    TResult Function()? country,
    TResult Function()? locality,
    TResult Function()? distance,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)
        administrativeAreaLevelOne,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)
        administrativeAreaLevelTwo,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeCountry value)
        country,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeLocality value)
        locality,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeDistance value)
        distance,
    required TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeUnknown value)
        unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult? Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult? Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelOne
                value)?
        administrativeAreaLevelOne,
    TResult Function(
            _PositiveRestrictedPlaceEnforcementTypeAdministrativeAreaLevelTwo
                value)?
        administrativeAreaLevelTwo,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeCountry value)?
        country,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeLocality value)?
        locality,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeDistance value)?
        distance,
    TResult Function(_PositiveRestrictedPlaceEnforcementTypeUnknown value)?
        unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class _PositiveRestrictedPlaceEnforcementTypeUnknown
    implements PositiveRestrictedPlaceEnforcementType {
  const factory _PositiveRestrictedPlaceEnforcementTypeUnknown() =
      _$PositiveRestrictedPlaceEnforcementTypeUnknownImpl;
}
