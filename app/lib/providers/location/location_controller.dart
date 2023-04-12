import 'package:app/services/third_party.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:google_maps_webservice/places.dart";

part 'location_controller.freezed.dart';
part 'location_controller.g.dart';

@freezed
class LocationControllerState with _$LocationControllerState {
  const factory LocationControllerState({
    List<PlacesSearchResult>? placesList,
  }) = _LocationControllerState;

  factory LocationControllerState.initialState() => const LocationControllerState();
}

@riverpod
class LocationController extends _$LocationController {
  final places = GoogleMapsPlaces(apiKey: const String.fromEnvironment("MAPS_KEY"));
  @override
  LocationControllerState build() {
    return LocationControllerState.initialState();
  }

  Future<void> searchLocation(String query) async {
    final response = await places.searchByText(query);
    final Logger logger = ref.read(loggerProvider);
    if (response.isOkay) {
      state = state.copyWith(placesList: response.results);
    } else {
      logger.e(response.errorMessage);
    }
  }
}
