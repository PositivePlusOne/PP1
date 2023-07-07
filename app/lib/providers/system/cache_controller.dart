// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import '../../constants/cache_constants.dart';
import '../../services/third_party.dart';

part 'cache_controller.freezed.dart';
part 'cache_controller.g.dart';

@freezed
class CacheControllerState with _$CacheControllerState {
  const factory CacheControllerState({
    required Map<String, dynamic> cacheData,
  }) = _CacheControllerState;
  factory CacheControllerState.initialState() => const CacheControllerState(cacheData: {});
}

@Riverpod(keepAlive: true)
class CacheController extends _$CacheController {
  Timer? scheduledJobCacheClear;

  @override
  CacheControllerState build() {
    return CacheControllerState.initialState();
  }

  void setupTimers() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Setting up cache timers');

    scheduledJobCacheClear = Timer.periodic(
      kCacheDuration,
      (Timer t) => clearCache(),
    );
  }

  void clearCache() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Clearing cache');
    state = state.copyWith(cacheData: {});
  }

  void addToCache(String key, dynamic value) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Adding to cache: $key - $value');

    state = state.copyWith(cacheData: {...state.cacheData, key: value});
    providerContainer.read(eventBusProvider).fire(CacheKeyUpdatedEvent(key, value));
  }

  bool containsInCache(String key) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Checking if cached: $key');
    return state.cacheData.containsKey(key);
  }

  void removeFromCache(String key) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Removing from cache: $key');
    state = state.copyWith(cacheData: {...state.cacheData}..remove(key));
    providerContainer.read(eventBusProvider).fire(CacheKeyUpdatedEvent(key, null));
  }

  T? getFromCache<T>(String key) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Getting from cache: $key');

    final data = state.cacheData[key];
    return data != null && data is T ? data : null;
  }

  bool isCached(String key) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Checking if cached: $key');
    return state.cacheData.containsKey(key);
  }
}
