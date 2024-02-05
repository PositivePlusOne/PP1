class LocationUpdatedEvent {
  LocationUpdatedEvent({
    this.latitude,
    this.longitude,
    this.addressComponents = const {},
  });

  final double? latitude;
  final double? longitude;
  final Map<String, Set<String>> addressComponents;
}
