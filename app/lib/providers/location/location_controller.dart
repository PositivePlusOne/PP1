// Dart imports:

// Package imports:
import 'package:flutter_google_maps_webservices/geocoding.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/geo/positive_place.dart';
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
  }) = _LocationControllerState;
  factory LocationControllerState.initialState() => const LocationControllerState();
}

@Riverpod(keepAlive: true)
class LocationController extends _$LocationController {
  @override
  LocationControllerState build() {
    return LocationControllerState.initialState();
  }

  Future<void> attemptToGetLocationPermissions() async {
    final Logger logger = ref.read(loggerProvider);
    final PermissionStatus locationPermission = await ref.read(locationPermissionsProvider.future);

    logger.i('Location permission status: $locationPermission');
    state = state.copyWith(locationPermission: locationPermission);
  }

  Future<List<PositivePlace>> searchLocation(String query, {bool includeLocationAsRegion = false}) async {
    final GoogleMapsPlaces places = ref.read(googleMapsPlacesProvider);
    final Logger logger = ref.read(loggerProvider);
    Location? location;

    try {
      if (includeLocationAsRegion) {
        await attemptToGetLocationPermissions();
        if (state.locationPermission != PermissionStatus.granted) {
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

  Future<List<PositivePlace>> searchNearby() async {
    final GoogleMapsGeocoding geocoding = ref.read(googleMapsGeocodingProvider);
    final Logger logger = ref.read(loggerProvider);

    try {
      await attemptToGetLocationPermissions();
      if (state.locationPermission != PermissionStatus.granted) {
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
