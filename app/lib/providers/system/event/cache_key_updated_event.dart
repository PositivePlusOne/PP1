class CacheKeyUpdatedEvent {
  final String key;
  final dynamic value;

  CacheKeyUpdatedEvent(this.key, this.value);

  @override
  String toString() {
    return 'CacheKeyUpdatedEvent{key: $key, value: $value}';
  }
}
