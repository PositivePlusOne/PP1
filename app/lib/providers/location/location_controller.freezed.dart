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
mixin _$LocationOption {
  String get description => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LocationOptionCopyWith<LocationOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationOptionCopyWith<$Res> {
  factory $LocationOptionCopyWith(
          LocationOption value, $Res Function(LocationOption) then) =
      _$LocationOptionCopyWithImpl<$Res, LocationOption>;
  @useResult
  $Res call({String description, String placeId});
}

/// @nodoc
class _$LocationOptionCopyWithImpl<$Res, $Val extends LocationOption>
    implements $LocationOptionCopyWith<$Res> {
  _$LocationOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationOptionImplCopyWith<$Res>
    implements $LocationOptionCopyWith<$Res> {
  factory _$$LocationOptionImplCopyWith(_$LocationOptionImpl value,
          $Res Function(_$LocationOptionImpl) then) =
      __$$LocationOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, String placeId});
}

/// @nodoc
class __$$LocationOptionImplCopyWithImpl<$Res>
    extends _$LocationOptionCopyWithImpl<$Res, _$LocationOptionImpl>
    implements _$$LocationOptionImplCopyWith<$Res> {
  __$$LocationOptionImplCopyWithImpl(
      _$LocationOptionImpl _value, $Res Function(_$LocationOptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? placeId = null,
  }) {
    return _then(_$LocationOptionImpl(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LocationOptionImpl implements _LocationOption {
  const _$LocationOptionImpl(
      {required this.description, required this.placeId});

  @override
  final String description;
  @override
  final String placeId;

  @override
  String toString() {
    return 'LocationOption(description: $description, placeId: $placeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationOptionImpl &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.placeId, placeId) || other.placeId == placeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, placeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationOptionImplCopyWith<_$LocationOptionImpl> get copyWith =>
      __$$LocationOptionImplCopyWithImpl<_$LocationOptionImpl>(
          this, _$identity);
}

abstract class _LocationOption implements LocationOption {
  const factory _LocationOption(
      {required final String description,
      required final String placeId}) = _$LocationOptionImpl;

  @override
  String get description;
  @override
  String get placeId;
  @override
  @JsonKey(ignore: true)
  _$$LocationOptionImplCopyWith<_$LocationOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LocationControllerState {
  PermissionStatus? get locationPermission =>
      throw _privateConstructorUsedError;
  StreamSubscription<Position>? get locationSubscription =>
      throw _privateConstructorUsedError;
  Duration? get locationUpdateInterval => throw _privateConstructorUsedError;
  dynamic get isUpdatingLocation => throw _privateConstructorUsedError;
  bool get isManualLocation => throw _privateConstructorUsedError;
  double? get lastKnownLatitude => throw _privateConstructorUsedError;
  double? get lastKnownLongitude => throw _privateConstructorUsedError;
  Map<String, Set<String>> get lastKnownAddressComponents =>
      throw _privateConstructorUsedError;
<<<<<<< HEAD
<<<<<<< HEAD
  DateTime? get lastGpsLookup => throw _privateConstructorUsedError;
  DateTime? get lastAddressComponentLookup =>
      throw _privateConstructorUsedError;
=======
  DateTime? get lastGpsUpdate => throw _privateConstructorUsedError;
  DateTime? get lastGeocodingUpdate => throw _privateConstructorUsedError;
>>>>>>> feature/organisation-name-display
=======
  DateTime? get lastGpsUpdate => throw _privateConstructorUsedError;
  DateTime? get lastGeocodingUpdate => throw _privateConstructorUsedError;
>>>>>>> feature/social-controls

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
  $Res call(
      {PermissionStatus? locationPermission,
      StreamSubscription<Position>? locationSubscription,
      Duration? locationUpdateInterval,
      dynamic isUpdatingLocation,
      bool isManualLocation,
      double? lastKnownLatitude,
      double? lastKnownLongitude,
      Map<String, Set<String>> lastKnownAddressComponents,
<<<<<<< HEAD
<<<<<<< HEAD
      DateTime? lastGpsLookup,
      DateTime? lastAddressComponentLookup});
=======
      DateTime? lastGpsUpdate,
      DateTime? lastGeocodingUpdate});
>>>>>>> feature/organisation-name-display
=======
      DateTime? lastGpsUpdate,
      DateTime? lastGeocodingUpdate});
>>>>>>> feature/social-controls
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
    Object? locationPermission = freezed,
    Object? locationSubscription = freezed,
    Object? locationUpdateInterval = freezed,
    Object? isUpdatingLocation = freezed,
    Object? isManualLocation = null,
    Object? lastKnownLatitude = freezed,
    Object? lastKnownLongitude = freezed,
    Object? lastKnownAddressComponents = null,
<<<<<<< HEAD
<<<<<<< HEAD
    Object? lastGpsLookup = freezed,
    Object? lastAddressComponentLookup = freezed,
=======
    Object? lastGpsUpdate = freezed,
    Object? lastGeocodingUpdate = freezed,
>>>>>>> feature/organisation-name-display
=======
    Object? lastGpsUpdate = freezed,
    Object? lastGeocodingUpdate = freezed,
>>>>>>> feature/social-controls
  }) {
    return _then(_value.copyWith(
      locationPermission: freezed == locationPermission
          ? _value.locationPermission
          : locationPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
      locationSubscription: freezed == locationSubscription
          ? _value.locationSubscription
          : locationSubscription // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<Position>?,
      locationUpdateInterval: freezed == locationUpdateInterval
          ? _value.locationUpdateInterval
          : locationUpdateInterval // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isUpdatingLocation: freezed == isUpdatingLocation
          ? _value.isUpdatingLocation
          : isUpdatingLocation // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isManualLocation: null == isManualLocation
          ? _value.isManualLocation
          : isManualLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      lastKnownLatitude: freezed == lastKnownLatitude
          ? _value.lastKnownLatitude
          : lastKnownLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lastKnownLongitude: freezed == lastKnownLongitude
          ? _value.lastKnownLongitude
          : lastKnownLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lastKnownAddressComponents: null == lastKnownAddressComponents
          ? _value.lastKnownAddressComponents
          : lastKnownAddressComponents // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
<<<<<<< HEAD
<<<<<<< HEAD
      lastGpsLookup: freezed == lastGpsLookup
          ? _value.lastGpsLookup
          : lastGpsLookup // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastAddressComponentLookup: freezed == lastAddressComponentLookup
          ? _value.lastAddressComponentLookup
          : lastAddressComponentLookup // ignore: cast_nullable_to_non_nullable
=======
=======
>>>>>>> feature/social-controls
      lastGpsUpdate: freezed == lastGpsUpdate
          ? _value.lastGpsUpdate
          : lastGpsUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastGeocodingUpdate: freezed == lastGeocodingUpdate
          ? _value.lastGeocodingUpdate
          : lastGeocodingUpdate // ignore: cast_nullable_to_non_nullable
>>>>>>> feature/organisation-name-display
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationControllerStateImplCopyWith<$Res>
    implements $LocationControllerStateCopyWith<$Res> {
  factory _$$LocationControllerStateImplCopyWith(
          _$LocationControllerStateImpl value,
          $Res Function(_$LocationControllerStateImpl) then) =
      __$$LocationControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PermissionStatus? locationPermission,
      StreamSubscription<Position>? locationSubscription,
      Duration? locationUpdateInterval,
      dynamic isUpdatingLocation,
      bool isManualLocation,
      double? lastKnownLatitude,
      double? lastKnownLongitude,
      Map<String, Set<String>> lastKnownAddressComponents,
<<<<<<< HEAD
<<<<<<< HEAD
      DateTime? lastGpsLookup,
      DateTime? lastAddressComponentLookup});
=======
      DateTime? lastGpsUpdate,
      DateTime? lastGeocodingUpdate});
>>>>>>> feature/organisation-name-display
=======
      DateTime? lastGpsUpdate,
      DateTime? lastGeocodingUpdate});
>>>>>>> feature/social-controls
}

/// @nodoc
class __$$LocationControllerStateImplCopyWithImpl<$Res>
    extends _$LocationControllerStateCopyWithImpl<$Res,
        _$LocationControllerStateImpl>
    implements _$$LocationControllerStateImplCopyWith<$Res> {
  __$$LocationControllerStateImplCopyWithImpl(
      _$LocationControllerStateImpl _value,
      $Res Function(_$LocationControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationPermission = freezed,
    Object? locationSubscription = freezed,
    Object? locationUpdateInterval = freezed,
    Object? isUpdatingLocation = freezed,
    Object? isManualLocation = null,
    Object? lastKnownLatitude = freezed,
    Object? lastKnownLongitude = freezed,
    Object? lastKnownAddressComponents = null,
<<<<<<< HEAD
<<<<<<< HEAD
    Object? lastGpsLookup = freezed,
    Object? lastAddressComponentLookup = freezed,
=======
    Object? lastGpsUpdate = freezed,
    Object? lastGeocodingUpdate = freezed,
>>>>>>> feature/organisation-name-display
=======
    Object? lastGpsUpdate = freezed,
    Object? lastGeocodingUpdate = freezed,
>>>>>>> feature/social-controls
  }) {
    return _then(_$LocationControllerStateImpl(
      locationPermission: freezed == locationPermission
          ? _value.locationPermission
          : locationPermission // ignore: cast_nullable_to_non_nullable
              as PermissionStatus?,
      locationSubscription: freezed == locationSubscription
          ? _value.locationSubscription
          : locationSubscription // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<Position>?,
      locationUpdateInterval: freezed == locationUpdateInterval
          ? _value.locationUpdateInterval
          : locationUpdateInterval // ignore: cast_nullable_to_non_nullable
              as Duration?,
      isUpdatingLocation: freezed == isUpdatingLocation
          ? _value.isUpdatingLocation!
          : isUpdatingLocation,
      isManualLocation: null == isManualLocation
          ? _value.isManualLocation
          : isManualLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      lastKnownLatitude: freezed == lastKnownLatitude
          ? _value.lastKnownLatitude
          : lastKnownLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lastKnownLongitude: freezed == lastKnownLongitude
          ? _value.lastKnownLongitude
          : lastKnownLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      lastKnownAddressComponents: null == lastKnownAddressComponents
          ? _value._lastKnownAddressComponents
          : lastKnownAddressComponents // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<String>>,
<<<<<<< HEAD
<<<<<<< HEAD
      lastGpsLookup: freezed == lastGpsLookup
          ? _value.lastGpsLookup
          : lastGpsLookup // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastAddressComponentLookup: freezed == lastAddressComponentLookup
          ? _value.lastAddressComponentLookup
          : lastAddressComponentLookup // ignore: cast_nullable_to_non_nullable
=======
=======
>>>>>>> feature/social-controls
      lastGpsUpdate: freezed == lastGpsUpdate
          ? _value.lastGpsUpdate
          : lastGpsUpdate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastGeocodingUpdate: freezed == lastGeocodingUpdate
          ? _value.lastGeocodingUpdate
          : lastGeocodingUpdate // ignore: cast_nullable_to_non_nullable
>>>>>>> feature/organisation-name-display
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$LocationControllerStateImpl implements _LocationControllerState {
  const _$LocationControllerStateImpl(
      {this.locationPermission,
      this.locationSubscription,
      this.locationUpdateInterval,
      this.isUpdatingLocation = false,
      this.isManualLocation = false,
      this.lastKnownLatitude,
      this.lastKnownLongitude,
      final Map<String, Set<String>> lastKnownAddressComponents = const {},
<<<<<<< HEAD
<<<<<<< HEAD
      this.lastGpsLookup,
      this.lastAddressComponentLookup})
=======
      this.lastGpsUpdate,
      this.lastGeocodingUpdate})
>>>>>>> feature/organisation-name-display
=======
      this.lastGpsUpdate,
      this.lastGeocodingUpdate})
>>>>>>> feature/social-controls
      : _lastKnownAddressComponents = lastKnownAddressComponents;

  @override
  final PermissionStatus? locationPermission;
  @override
  final StreamSubscription<Position>? locationSubscription;
  @override
  final Duration? locationUpdateInterval;
  @override
  @JsonKey()
  final dynamic isUpdatingLocation;
  @override
  @JsonKey()
  final bool isManualLocation;
  @override
  final double? lastKnownLatitude;
  @override
  final double? lastKnownLongitude;
  final Map<String, Set<String>> _lastKnownAddressComponents;
  @override
  @JsonKey()
  Map<String, Set<String>> get lastKnownAddressComponents {
    if (_lastKnownAddressComponents is EqualUnmodifiableMapView)
      return _lastKnownAddressComponents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lastKnownAddressComponents);
  }

  @override
<<<<<<< HEAD
<<<<<<< HEAD
  final DateTime? lastGpsLookup;
  @override
  final DateTime? lastAddressComponentLookup;

  @override
  String toString() {
    return 'LocationControllerState(locationPermission: $locationPermission, locationSubscription: $locationSubscription, locationUpdateInterval: $locationUpdateInterval, isUpdatingLocation: $isUpdatingLocation, isManualLocation: $isManualLocation, lastKnownLatitude: $lastKnownLatitude, lastKnownLongitude: $lastKnownLongitude, lastKnownAddressComponents: $lastKnownAddressComponents, lastGpsLookup: $lastGpsLookup, lastAddressComponentLookup: $lastAddressComponentLookup)';
=======
  final DateTime? lastGpsUpdate;
  @override
  final DateTime? lastGeocodingUpdate;

  @override
  String toString() {
    return 'LocationControllerState(locationPermission: $locationPermission, locationSubscription: $locationSubscription, locationUpdateInterval: $locationUpdateInterval, isUpdatingLocation: $isUpdatingLocation, lastKnownLatitude: $lastKnownLatitude, lastKnownLongitude: $lastKnownLongitude, lastKnownAddressComponents: $lastKnownAddressComponents, lastGpsUpdate: $lastGpsUpdate, lastGeocodingUpdate: $lastGeocodingUpdate)';
>>>>>>> feature/organisation-name-display
=======
  final DateTime? lastGpsUpdate;
  @override
  final DateTime? lastGeocodingUpdate;

  @override
  String toString() {
    return 'LocationControllerState(locationPermission: $locationPermission, locationSubscription: $locationSubscription, locationUpdateInterval: $locationUpdateInterval, isUpdatingLocation: $isUpdatingLocation, lastKnownLatitude: $lastKnownLatitude, lastKnownLongitude: $lastKnownLongitude, lastKnownAddressComponents: $lastKnownAddressComponents, lastGpsUpdate: $lastGpsUpdate, lastGeocodingUpdate: $lastGeocodingUpdate)';
>>>>>>> feature/social-controls
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationControllerStateImpl &&
            (identical(other.locationPermission, locationPermission) ||
                other.locationPermission == locationPermission) &&
            (identical(other.locationSubscription, locationSubscription) ||
                other.locationSubscription == locationSubscription) &&
            (identical(other.locationUpdateInterval, locationUpdateInterval) ||
                other.locationUpdateInterval == locationUpdateInterval) &&
            const DeepCollectionEquality()
                .equals(other.isUpdatingLocation, isUpdatingLocation) &&
            (identical(other.isManualLocation, isManualLocation) ||
                other.isManualLocation == isManualLocation) &&
            (identical(other.lastKnownLatitude, lastKnownLatitude) ||
                other.lastKnownLatitude == lastKnownLatitude) &&
            (identical(other.lastKnownLongitude, lastKnownLongitude) ||
                other.lastKnownLongitude == lastKnownLongitude) &&
            const DeepCollectionEquality().equals(
                other._lastKnownAddressComponents,
                _lastKnownAddressComponents) &&
<<<<<<< HEAD
<<<<<<< HEAD
            (identical(other.lastGpsLookup, lastGpsLookup) ||
                other.lastGpsLookup == lastGpsLookup) &&
            (identical(other.lastAddressComponentLookup,
                    lastAddressComponentLookup) ||
                other.lastAddressComponentLookup ==
                    lastAddressComponentLookup));
=======
=======
>>>>>>> feature/social-controls
            (identical(other.lastGpsUpdate, lastGpsUpdate) ||
                other.lastGpsUpdate == lastGpsUpdate) &&
            (identical(other.lastGeocodingUpdate, lastGeocodingUpdate) ||
                other.lastGeocodingUpdate == lastGeocodingUpdate));
<<<<<<< HEAD
>>>>>>> feature/organisation-name-display
=======
>>>>>>> feature/social-controls
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationPermission,
      locationSubscription,
      locationUpdateInterval,
      const DeepCollectionEquality().hash(isUpdatingLocation),
      isManualLocation,
      lastKnownLatitude,
      lastKnownLongitude,
      const DeepCollectionEquality().hash(_lastKnownAddressComponents),
<<<<<<< HEAD
<<<<<<< HEAD
      lastGpsLookup,
      lastAddressComponentLookup);
=======
      lastGpsUpdate,
      lastGeocodingUpdate);
>>>>>>> feature/organisation-name-display
=======
      lastGpsUpdate,
      lastGeocodingUpdate);
>>>>>>> feature/social-controls

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationControllerStateImplCopyWith<_$LocationControllerStateImpl>
      get copyWith => __$$LocationControllerStateImplCopyWithImpl<
          _$LocationControllerStateImpl>(this, _$identity);
}

abstract class _LocationControllerState implements LocationControllerState {
  const factory _LocationControllerState(
<<<<<<< HEAD
<<<<<<< HEAD
          {final PermissionStatus? locationPermission,
          final StreamSubscription<Position>? locationSubscription,
          final Duration? locationUpdateInterval,
          final dynamic isUpdatingLocation,
          final bool isManualLocation,
          final double? lastKnownLatitude,
          final double? lastKnownLongitude,
          final Map<String, Set<String>> lastKnownAddressComponents,
          final DateTime? lastGpsLookup,
          final DateTime? lastAddressComponentLookup}) =
      _$LocationControllerStateImpl;
=======
=======
>>>>>>> feature/social-controls
      {final PermissionStatus? locationPermission,
      final StreamSubscription<Position>? locationSubscription,
      final Duration? locationUpdateInterval,
      final dynamic isUpdatingLocation,
      final double? lastKnownLatitude,
      final double? lastKnownLongitude,
      final Map<String, Set<String>> lastKnownAddressComponents,
      final DateTime? lastGpsUpdate,
      final DateTime? lastGeocodingUpdate}) = _$LocationControllerStateImpl;
<<<<<<< HEAD
>>>>>>> feature/organisation-name-display
=======
>>>>>>> feature/social-controls

  @override
  PermissionStatus? get locationPermission;
  @override
  StreamSubscription<Position>? get locationSubscription;
  @override
  Duration? get locationUpdateInterval;
  @override
  dynamic get isUpdatingLocation;
  @override
  bool get isManualLocation;
  @override
  double? get lastKnownLatitude;
  @override
  double? get lastKnownLongitude;
  @override
  Map<String, Set<String>> get lastKnownAddressComponents;
  @override
<<<<<<< HEAD
<<<<<<< HEAD
  DateTime? get lastGpsLookup;
  @override
  DateTime? get lastAddressComponentLookup;
=======
  DateTime? get lastGpsUpdate;
  @override
  DateTime? get lastGeocodingUpdate;
>>>>>>> feature/organisation-name-display
=======
  DateTime? get lastGpsUpdate;
  @override
  DateTime? get lastGeocodingUpdate;
>>>>>>> feature/social-controls
  @override
  @JsonKey(ignore: true)
  _$$LocationControllerStateImplCopyWith<_$LocationControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
