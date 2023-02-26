// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchControllerState {
  String get algoliaApplicationID => throw _privateConstructorUsedError;
  String get algoliaApiKey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchControllerStateCopyWith<SearchControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchControllerStateCopyWith<$Res> {
  factory $SearchControllerStateCopyWith(SearchControllerState value,
          $Res Function(SearchControllerState) then) =
      _$SearchControllerStateCopyWithImpl<$Res, SearchControllerState>;
  @useResult
  $Res call({String algoliaApplicationID, String algoliaApiKey});
}

/// @nodoc
class _$SearchControllerStateCopyWithImpl<$Res,
        $Val extends SearchControllerState>
    implements $SearchControllerStateCopyWith<$Res> {
  _$SearchControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? algoliaApplicationID = null,
    Object? algoliaApiKey = null,
  }) {
    return _then(_value.copyWith(
      algoliaApplicationID: null == algoliaApplicationID
          ? _value.algoliaApplicationID
          : algoliaApplicationID // ignore: cast_nullable_to_non_nullable
              as String,
      algoliaApiKey: null == algoliaApiKey
          ? _value.algoliaApiKey
          : algoliaApiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SearchControllerStateCopyWith<$Res>
    implements $SearchControllerStateCopyWith<$Res> {
  factory _$$_SearchControllerStateCopyWith(_$_SearchControllerState value,
          $Res Function(_$_SearchControllerState) then) =
      __$$_SearchControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String algoliaApplicationID, String algoliaApiKey});
}

/// @nodoc
class __$$_SearchControllerStateCopyWithImpl<$Res>
    extends _$SearchControllerStateCopyWithImpl<$Res, _$_SearchControllerState>
    implements _$$_SearchControllerStateCopyWith<$Res> {
  __$$_SearchControllerStateCopyWithImpl(_$_SearchControllerState _value,
      $Res Function(_$_SearchControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? algoliaApplicationID = null,
    Object? algoliaApiKey = null,
  }) {
    return _then(_$_SearchControllerState(
      algoliaApplicationID: null == algoliaApplicationID
          ? _value.algoliaApplicationID
          : algoliaApplicationID // ignore: cast_nullable_to_non_nullable
              as String,
      algoliaApiKey: null == algoliaApiKey
          ? _value.algoliaApiKey
          : algoliaApiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_SearchControllerState implements _SearchControllerState {
  const _$_SearchControllerState(
      {required this.algoliaApplicationID, this.algoliaApiKey = ''});

  @override
  final String algoliaApplicationID;
  @override
  @JsonKey()
  final String algoliaApiKey;

  @override
  String toString() {
    return 'SearchControllerState(algoliaApplicationID: $algoliaApplicationID, algoliaApiKey: $algoliaApiKey)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchControllerState &&
            (identical(other.algoliaApplicationID, algoliaApplicationID) ||
                other.algoliaApplicationID == algoliaApplicationID) &&
            (identical(other.algoliaApiKey, algoliaApiKey) ||
                other.algoliaApiKey == algoliaApiKey));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, algoliaApplicationID, algoliaApiKey);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SearchControllerStateCopyWith<_$_SearchControllerState> get copyWith =>
      __$$_SearchControllerStateCopyWithImpl<_$_SearchControllerState>(
          this, _$identity);
}

abstract class _SearchControllerState implements SearchControllerState {
  const factory _SearchControllerState(
      {required final String algoliaApplicationID,
      final String algoliaApiKey}) = _$_SearchControllerState;

  @override
  String get algoliaApplicationID;
  @override
  String get algoliaApiKey;
  @override
  @JsonKey(ignore: true)
  _$$_SearchControllerStateCopyWith<_$_SearchControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
