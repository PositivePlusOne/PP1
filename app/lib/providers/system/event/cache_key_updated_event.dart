import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';

class CacheKeyUpdatedEvent {
  final String key;
  final dynamic value;

  CacheKeyUpdatedEvent(this.key, this.value);

  @override
  String toString() {
    return 'CacheKeyUpdatedEvent{key: $key, value: $value}';
  }
}

extension CacheKeyUpdatedEventExt on CacheKeyUpdatedEvent {
  bool get isCurrentProfileChangeEvent {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final String expectedCacheKey = profileController.state.currentProfile?.flMeta?.id ?? '';
    if (expectedCacheKey.isEmpty) {
      return false;
    }

    return key == expectedCacheKey;
  }
}
