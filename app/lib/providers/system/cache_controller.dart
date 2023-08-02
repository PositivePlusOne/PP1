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

class CacheRecord {
  final String key;
  dynamic value;

  final String createdBy;
  String lastAccessedBy;

  final DateTime createdAt;
  DateTime? lastUpdatedAt;

  CacheRecord(this.key, this.value, this.createdBy)
      : createdAt = DateTime.now(),
        lastUpdatedAt = DateTime.now(),
        lastAccessedBy = createdBy;
}

@freezed
class CacheControllerState with _$CacheControllerState {
  const factory CacheControllerState({
    required Map<String, CacheRecord> cacheData,
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
    state = state.copyWith(cacheData: {});
  }

  void addToCache({
    required String key,
    required dynamic value,
    bool overwrite = true,
  }) {
    final StackTrace trace = StackTrace.current;
    final String caller = trace.toString().split('#')[1].split(' ')[0];

    final CacheRecord? record = state.cacheData[key];
    if (overwrite || record == null) {
      record?.lastUpdatedAt = DateTime.now();
      record?.lastAccessedBy = caller;
      record?.value = value;

      state = state.copyWith(cacheData: {...state.cacheData}..[key] = record ?? CacheRecord(key, value, caller));
      providerContainer.read(eventBusProvider).fire(CacheKeyUpdatedEvent(key, value));
    }
  }

  bool containsInCache(String key) {
    return state.cacheData.containsKey(key);
  }

  void removeFromCache(String key) {
    state = state.copyWith(cacheData: {...state.cacheData}..remove(key));
    providerContainer.read(eventBusProvider).fire(CacheKeyUpdatedEvent(key, null));
  }

  T? getFromCache<T>(String key) {
    final CacheRecord? record = state.cacheData[key];
    final dynamic data = record?.value;
    return data != null && data is T ? data : null;
  }

  bool isCached(String key) {
    return state.cacheData.containsKey(key);
  }
}
