// Package imports:
import "package:google_maps_webservice/places.dart";
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
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
    List<LocationOption>? placesList,
    PlaceDetails? selectedPlace,
  }) = _LocationControllerState;

  factory LocationControllerState.initialState() => const LocationControllerState();
}

@riverpod
class LocationController extends _$LocationController {
  final _places = GoogleMapsPlaces(apiKey: const String.fromEnvironment("MAPS_KEY"));

  @override
  LocationControllerState build() {
    return LocationControllerState.initialState();
  }

  Future<void> searchLocation(String query) async {
    final res = await _places.autocomplete(query, radius: 5000);
    final Logger logger = ref.read(loggerProvider);

    if (res.isOkay) {
      state = state.copyWith(
          placesList: res.predictions
              .where((element) => element.description != null)
              .map((e) => LocationOption(
                    description: e.description ?? "",
                    placeId: e.placeId ?? e.reference ?? "",
                  ))
              .toList());
    } else {
      logger.e(res.errorMessage);
    }
  }

  Future<void> getLocationByPlaceId(String placeId) async {
    final res = await _places.getDetailsByPlaceId(placeId);
    final Logger logger = ref.read(loggerProvider);

    if (res.isOkay) {
      final location = res.result.geometry?.location;
      if (location != null) {
        // reset the location list
        state = state.copyWith(selectedPlace: res.result, placesList: null);
      }
    } else {
      logger.e(res.errorMessage);
    }
  }
}
