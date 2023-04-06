import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_view_model.freezed.dart';
part 'location_view_model.g.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState({
    String? searchQuery,
    Location? location,
  }) = _LocationState;

  factory LocationState.initialState() => const LocationState();
}

@riverpod
class LocationViewModel extends _$LocationViewModel {
  @override
  LocationState build() {
    return LocationState.initialState();
  }

  Future<void> setLocation({required Location location}) async {
    state = state.copyWith(location: location);
  }
}
