// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/profile_controller.dart';

part 'location_view_model.freezed.dart';

part 'location_view_model.g.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    String? searchQuery,
    Location? location,
    String? error,
  }) = _LocationState;

  factory LocationState.initialState() => const LocationState();
}

@riverpod
class LocationViewModel extends _$LocationViewModel {
  @override
  LocationState build() {
    final profileLocation = ref.read(profileControllerProvider).userProfile?.location;
    if (profileLocation == null) {
      return LocationState.initialState();
    }

    return LocationState(
      location: Location(
        lat: profileLocation.latitude.toDouble(),
        lng: profileLocation.longitude.toDouble(),
      ),
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> findMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(error: 'Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = state.copyWith(error: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(error: 'Location permissions are permanently denied, we cannot request permissions.');
    }

    final location = await Geolocator.getCurrentPosition();

    state = state.copyWith(location: Location(lat: location.latitude, lng: location.longitude));
  }

  Future<void> setLocation({required Location location}) async {
    state = state.copyWith(location: location);
  }
}
