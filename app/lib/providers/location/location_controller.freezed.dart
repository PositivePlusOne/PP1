// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LocationControllerState {
  List<PlacesSearchResult>? get placesList =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocationControllerStateCopyWith<LocationControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationControllerStateCopyWith<$Res> {
  factory $LocationControllerStateCopyWith(LocationControllerState value,
          $Res Function(LocationControllerState) then) =
      _$LocationControllerStateCopyWithImpl<$Res, LocationControllerState>;
  @useResult
  $Res call({List<PlacesSearchResult>? placesList});
}

/// @nodoc
class _$LocationControllerStateCopyWithImpl<$Res,
        $Val extends LocationControllerState>
    implements $LocationControllerStateCopyWith<$Res> {
  _$LocationControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placesList = freezed,
  }) {
    return _then(_value.copyWith(
      placesList: freezed == placesList
          ? _value.placesList
          : placesList // ignore: cast_nullable_to_non_nullable
              as List<PlacesSearchResult>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LocationControllerStateCopyWith<$Res>
    implements $LocationControllerStateCopyWith<$Res> {
  factory _$$_LocationControllerStateCopyWith(_$_LocationControllerState value,
          $Res Function(_$_LocationControllerState) then) =
      __$$_LocationControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PlacesSearchResult>? placesList});
}

/// @nodoc
class __$$_LocationControllerStateCopyWithImpl<$Res>
    extends _$LocationControllerStateCopyWithImpl<$Res,
        _$_LocationControllerState>
    implements _$$_LocationControllerStateCopyWith<$Res> {
  __$$_LocationControllerStateCopyWithImpl(_$_LocationControllerState _value,
      $Res Function(_$_LocationControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placesList = freezed,
  }) {
    return _then(_$_LocationControllerState(
      placesList: freezed == placesList
          ? _value._placesList
          : placesList // ignore: cast_nullable_to_non_nullable
              as List<PlacesSearchResult>?,
    ));
  }
}

/// @nodoc

class _$_LocationControllerState implements _LocationControllerState {
  const _$_LocationControllerState({final List<PlacesSearchResult>? placesList})
      : _placesList = placesList;

  final List<PlacesSearchResult>? _placesList;
  @override
  List<PlacesSearchResult>? get placesList {
    final value = _placesList;
    if (value == null) return null;
    if (_placesList is EqualUnmodifiableListView) return _placesList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LocationControllerState(placesList: $placesList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LocationControllerState &&
            const DeepCollectionEquality()
                .equals(other._placesList, _placesList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_placesList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LocationControllerStateCopyWith<_$_LocationControllerState>
      get copyWith =>
          __$$_LocationControllerStateCopyWithImpl<_$_LocationControllerState>(
              this, _$identity);
}

abstract class _LocationControllerState implements LocationControllerState {
  const factory _LocationControllerState(
          {final List<PlacesSearchResult>? placesList}) =
      _$_LocationControllerState;

  @override
  List<PlacesSearchResult>? get placesList;
  @override
  @JsonKey(ignore: true)
  _$$_LocationControllerStateCopyWith<_$_LocationControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
