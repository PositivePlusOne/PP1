// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';

enum CacheKeyUpdatedEventType { created, updated, deleted }

class CacheKeyUpdatedEvent {
  final String key;
  final CacheKeyUpdatedEventType eventType;
  final dynamic value;

  CacheKeyUpdatedEvent(this.key, this.eventType, this.value);

  @override
  String toString() {
    return 'CacheKeyUpdatedEvent{key: $key, value: $value}';
  }
}

extension CacheKeyUpdatedEventExt on CacheKeyUpdatedEvent {
  bool get isCurrentProfileChangeEvent {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final String expectedCacheKey = profileControllerState.currentProfile?.flMeta?.id ?? '';
    if (expectedCacheKey.isEmpty) {
      return false;
    }

    return key == expectedCacheKey;
  }
}
