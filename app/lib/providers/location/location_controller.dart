// Dart imports:

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:cron/cron.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/dtos/database/geo/positive_place.dart';
import 'package:app/providers/content/events/location_updated_event.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/services/third_party.dart';

part 'location_controller.freezed.dart';

part 'location_controller.g.dart';

@freezed
class LocationOption with _$LocationOption {
  const factory LocationOption({
    required String description,
    required String placeId,
  }) = _LocationOption;
}

@freezed
class LocationControllerState with _$LocationControllerState {
  const factory LocationControllerState({
    PermissionStatus? locationPermission,
    StreamSubscription<Position>? locationSubscription,
    Duration? locationUpdateInterval,
    @Default(false) isUpdatingLocation,
    @Default(false) bool isManualLocation,
    double? lastKnownLatitude,
    double? lastKnownLongitude,
    @Default({}) Map<String, Set<String>> lastKnownAddressComponents,
    DateTime? lastGpsLookup,
    DateTime? lastAddressComponentLookup,
  }) = _LocationControllerState;
  factory LocationControllerState.initialState() => const LocationControllerState();
}

abstract class ILocationController {
  StreamSubscription<ProfileSwitchedEvent>? get profileSwitchedSubscription;
  Stream<Position>? get locationStream;
  ScheduledTask? locationRefreshScheduleTask;
  Future<PermissionStatus> getLocationPermission();
  Future<PermissionStatus> requestLocationPermission();
  Future<void> setupListeners();
  Future<void> teardownListeners();
  Future<void> attemptToUpdateLocation({bool force = false});
  void setManualGPSLocation(double latitude, double longitude);
  Future<List<PositivePlace>> searchLocation(String query, {bool includeLocationAsRegion = false});
  Future<List<PositivePlace>> searchNearby();
  Future<List<PositivePlace>> extractPredictionsToPlaces(List<Prediction> filteredPredictions);
}

@Riverpod(keepAlive: true)
class LocationController extends _$LocationController implements ILocationController {
  StreamSubscription<ProfileSwitchedEvent>? _profileSwitchedSubscription;

  @override
  StreamSubscription<ProfileSwitchedEvent>? get profileSwitchedSubscription => _profileSwitchedSubscription;

  Stream<Position>? _locationStream;

  @override
  Stream<Position>? get locationStream => _locationStream;

  @override
  ScheduledTask? locationRefreshScheduleTask;

  @override
  LocationControllerState build() {
    return LocationControllerState.initialState();
  }

  @override
  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final Cron cron = ref.read(cronProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    locationRefreshScheduleTask ??= cron.schedule(
      Schedule.parse(kRefreshLocationCRON),
      () async {
        logger.i('Attempting to refresh location data');
        await attemptToUpdateLocation();
      },
    );

    _profileSwitchedSubscription ??= eventBus.on<ProfileSwitchedEvent>().listen((ProfileSwitchedEvent event) async {
      logger.i('Profile switched, attempting to refresh location data');
      await attemptToUpdateLocation();
    });

    await setupLocationListeners();
    await attemptToUpdateLocation();
  }

  Future<void> setupLocationListeners() async {
    final Logger logger = ref.read(loggerProvider);
    if (locationStream != null) {
      logger.w('setupLocationStream: Location stream already setup');
      return;
    }

    // Attempt to get location permissions
    final PermissionStatus locationPermission = await getLocationPermission();
    final bool isGranted = locationPermission == PermissionStatus.granted;
    if (!isGranted) {
      logger.w('setupLocationStream: Location permission not granted, cannot setup location stream');
      return;
    }

    // Setup location stream
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.reduced,
      distanceFilter: 0,
    );

    _locationStream = Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  @override
  Future<void> teardownListeners() async {
    final Logger logger = ref.read(loggerProvider);

    final bool hasLocationStream = _locationStream != null;
    if (!hasLocationStream) {
      logger.w('teardownLocationStream: Location stream already torn down');
      return;
    }

    logger.i('teardownLocationStream: Tearing down location stream');
    _locationStream = null;
  }

  @override
  Future<PermissionStatus> getLocationPermission() async {
    final Logger logger = ref.read(loggerProvider);
    final PermissionStatus permissionStatus = await ref.read(locationPermissionsProvider.future);

    logger.i('Location permission status: $permissionStatus');
    state = state.copyWith(locationPermission: permissionStatus);

    return permissionStatus;
  }

  @override
  Future<PermissionStatus> requestLocationPermission() async {
    final Logger logger = ref.read(loggerProvider);
    final PermissionStatus permissionStatus = await ref.read(requestedLocationPermissionsProvider.future);

    logger.i('Location permission status: $permissionStatus');
    state = state.copyWith(locationPermission: permissionStatus);

    return permissionStatus;
  }

  @override
  Future<void> attemptToUpdateLocation({bool force = false}) async {
    final Logger logger = ref.read(loggerProvider);
    if (state.isManualLocation) {
      logger.w('Manual location set, cannot update location');
      return;
    }

    logger.i('Attempting to update location data');
    PermissionStatus locationPermission = await ref.read(locationPermissionsProvider.future);
    bool isGranted = locationPermission == PermissionStatus.granted;

    if (force) {
      locationPermission = await ref.read(requestedLocationPermissionsProvider.future);
      isGranted = locationPermission == PermissionStatus.granted;
    }

    if (!isGranted) {
      logger.w('Location permission not granted, cannot update location');
      return;
    }

    try {
      logger.i('Updating location');
      state = state.copyWith(isUpdatingLocation: true);

      if (force) {
        state = state.copyWith(
          lastGpsLookup: null,
          lastAddressComponentLookup: null,
          lastKnownAddressComponents: {},
        );
      }

      await _updateLatitudeAndLongitude();
      await _updateGeocodingData(force: force);
    } finally {
      state = state.copyWith(isUpdatingLocation: false);
    }
  }

  Future<void> _updateGeocodingData({bool force = false}) async {
    final Logger logger = ref.read(loggerProvider);
    final GoogleMapsGeocoding geocoding = ref.read(googleMapsGeocodingProvider);
    if (state.lastKnownLatitude == null || state.lastKnownLongitude == null) {
      logger.w('Cannot update geocoding data, no location data available');
      return;
    }

    // If we already have geocoding data for this location, don't update it
    final bool hasPerformedLookupRecently = state.lastAddressComponentLookup != null && DateTime.now().difference(state.lastAddressComponentLookup!) < kLocationUpdateFrequency;
    final bool hasAddressComponents = state.lastKnownAddressComponents.isNotEmpty;
    if (!force && hasPerformedLookupRecently && hasAddressComponents) {
      logger.i('Geocoding data already up to date');
      return;
    }

    final Location latLng = Location(lat: state.lastKnownLatitude!, lng: state.lastKnownLongitude!);
    logger.i('Updating geocoding data for location: $latLng');

    final GeocodingResponse searchResponse = await geocoding.searchByLocation(latLng, resultType: ['locality']);
    if (searchResponse.errorMessage?.isNotEmpty == true) {
      throw Exception(searchResponse.errorMessage);
    }

    final GeocodingResult? result = searchResponse.results.firstOrNull;
    if (result == null) {
      logger.w('No geocoding result found');
      state = state.copyWith(
        lastKnownAddressComponents: {},
        lastAddressComponentLookup: null,
      );

      return;
    }

    final Map<String, Set<String>> addressComponents = {};
    for (final AddressComponent component in result.addressComponents) {
      final String type = component.types.first;
      final String value = component.longName.isEmpty ? component.shortName : component.longName;

      if (addressComponents[type] == null) {
        addressComponents[type] = {};
      }

      addressComponents[type]?.add(value);
    }

    logger.i('Found address components: $addressComponents');
    state = state.copyWith(
      lastKnownAddressComponents: addressComponents,
      lastAddressComponentLookup: addressComponents.isNotEmpty ? DateTime.now() : null,
    );

    notifyLocationChanged();
  }

  Future<void> _updateLatitudeAndLongitude() async {
    final Logger logger = ref.read(loggerProvider);
    final Position position = await Geolocator.getCurrentPosition();
    final Location location = Location(lat: position.latitude, lng: position.longitude);

    logger.i('Found location: $location');
    state = state.copyWith(
      lastKnownLatitude: location.lat,
      lastKnownLongitude: location.lng,
      lastGpsLookup: DateTime.now(),
    );
  }

  @override
  void setManualGPSLocation(double latitude, double longitude) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Setting manual GPS location: $latitude, $longitude');

    state = state.copyWith(
      lastKnownLatitude: latitude,
      lastKnownLongitude: longitude,
      lastGpsLookup: DateTime.now(),
      isManualLocation: true,
    );

    _updateGeocodingData(force: true);
    notifyLocationChanged();
  }

  void notifyLocationChanged() {
    final EventBus eventBus = ref.read(eventBusProvider);
    final Logger logger = ref.read(loggerProvider);
    logger.i('Notifying location changed event bus subscribers');

    eventBus.fire(LocationUpdatedEvent(
      latitude: state.lastKnownLatitude,
      longitude: state.lastKnownLongitude,
      addressComponents: state.lastKnownAddressComponents,
    ));
  }

  @override
  Future<List<PositivePlace>> searchLocation(String query, {bool includeLocationAsRegion = false}) async {
    final GoogleMapsPlaces places = ref.read(googleMapsPlacesProvider);
    final Logger logger = ref.read(loggerProvider);
    Location? location;

    try {
      if (includeLocationAsRegion) {
        final PermissionStatus locationPermission = await requestLocationPermission();
        if (locationPermission != PermissionStatus.granted) {
          throw Exception(state.locationPermission);
        }

        final Position position = await Geolocator.getCurrentPosition();
        location = Location(lat: position.latitude, lng: position.longitude);
      }
    } catch (ex) {
      logger.e('Error getting location permission: $ex');
    }

    logger.i('Searching location placemarks for query: $query');
    final PlacesAutocompleteResponse autocompleteResponse = await places.autocomplete(query, origin: location);

    if (autocompleteResponse.errorMessage?.isNotEmpty == true) {
      throw Exception(autocompleteResponse.errorMessage);
    }

    final List<Prediction> filteredPredictions = autocompleteResponse.predictions.where(
      (element) {
        return element.placeId?.isNotEmpty ?? false;
      },
    ).toList();

    logger.i('Found ${filteredPredictions.length} results for query: $query');

    return await extractPredictionsToPlaces(filteredPredictions);
  }

  @override
  Future<List<PositivePlace>> searchNearby() async {
    final GoogleMapsGeocoding geocoding = ref.read(googleMapsGeocodingProvider);
    final Logger logger = ref.read(loggerProvider);

    try {
      final PermissionStatus locationPermission = await requestLocationPermission();
      if (locationPermission != PermissionStatus.granted) {
        throw Exception(state.locationPermission);
      }

      final Position position = await Geolocator.getCurrentPosition();
      final Location latLng = Location(lat: position.latitude, lng: position.longitude);

      final GeocodingResponse searchResponse = await geocoding.searchByLocation(latLng, resultType: ['locality']);
      if (searchResponse.errorMessage?.isNotEmpty == true) {
        throw Exception(searchResponse.errorMessage);
      }

      return searchResponse.results
          .where((element) => element.formattedAddress?.isNotEmpty ?? false)
          .map((e) => PositivePlace(
                description: e.formattedAddress!,
                placeId: e.placeId,
                latitude: e.geometry.location.lat.toString(),
                longitude: e.geometry.location.lng.toString(),
                optOut: false,
              ))
          .toList();
    } catch (ex) {
      logger.e('Error getting location permission: $ex');
    }

    return [];
  }

  @override
  Future<List<PositivePlace>> extractPredictionsToPlaces(List<Prediction> filteredPredictions) async {
    final GoogleMapsPlaces places = ref.read(googleMapsPlacesProvider);
    final List<PositivePlace> retPlaces = [];
    final List<Future> futures = [];

    for (final Prediction prediction in filteredPredictions) {
      futures.add(Future(() async {
        final PlacesDetailsResponse detailsResponse = await places.getDetailsByPlaceId(prediction.placeId!);
        if (detailsResponse.errorMessage?.isNotEmpty == true) {
          throw Exception(detailsResponse.errorMessage);
        }

        final PlaceDetails result = detailsResponse.result;
        if (result.geometry?.location.lat != null && result.geometry?.location.lng != null) {
          retPlaces.add(
            PositivePlace(
              placeId: prediction.placeId!,
              description: prediction.description ?? '',
              optOut: false,
              latitude: result.geometry?.location.lat.toString(),
              longitude: result.geometry?.location.lng.toString(),
            ),
          );
        }
      }));
    }

    await Future.wait(futures);

    return retPlaces;
  }
}
