// Dart imports:
import 'dart:async';
import 'dart:collection';
import 'dart:io';

// Package imports:
import 'package:cron/cron.dart';
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/constants/cache_constants.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/services/health_api_service.dart';
import '../../services/third_party.dart';

part 'cache_controller.freezed.dart';
part 'cache_controller.g.dart';

@freezed
class CacheRecord with _$CacheRecord {
  const factory CacheRecord({
    required String key,
    required Object value,
    required FlMeta metadata,
  }) = _CacheRecord;

  static const String kCacheRefreshInterval = '*/1 * * * *';
  static const Duration kCacheExpiryInterval = Duration(minutes: 2);

  static const int kCacheRefreshMaximumEntryCount = 100;

  static final List<String> kCacheUpdateTargetSchemas = List<String>.unmodifiable([
    'users',
    'relationships',
    'activities',
  ]);

  factory CacheRecord.fromJson(Map<String, Object?> json) => _$CacheRecordFromJson(json);
}

@Riverpod(keepAlive: true)
CacheController cacheController(CacheControllerRef ref) {
  return CacheController();
}

class CacheController {
  final HashMap<String, CacheRecord> cacheData = HashMap<String, CacheRecord>();
  ScheduledTask? cacheUpdateTask;

  Future<void> setupListeners() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final Cron cron = providerContainer.read(cronProvider);

    logger.i('Setting up cache controller listeners');
    await cacheUpdateTask?.cancel();
    cacheUpdateTask = cron.schedule(Schedule.parse(CacheRecord.kCacheRefreshInterval.toString()), onCacheUpdateRequest);
  }

  Future<void> onCacheUpdateRequest() async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.i('Cache update request received');

    final List<String> requestIds = [];

    final int currentTime = DateTime.now().millisecondsSinceEpoch;

    for (final CacheRecord record in cacheData.values) {
      final int lastFetchTime = record.metadata.lastFetchMillis;

      final String schema = record.metadata.schema ?? '';
      if (schema.isEmpty || !CacheRecord.kCacheUpdateTargetSchemas.contains(schema)) {
        logger.d('Skipping cache record ${record.key} due to schema mismatch');
        continue;
      }

      if (lastFetchTime == -1) {
        logger.d('Skipping cache record ${record.key} due to missing last fetch time');
        continue;
      }

      final String id = record.metadata.id ?? '';
      final bool isCacheExpired = currentTime - lastFetchTime > CacheRecord.kCacheExpiryInterval.inMilliseconds;

      if (id.isNotEmpty && isCacheExpired) {
        final String cacheKey = '${schema}_$id';
        requestIds.add(cacheKey);
      }

      logger.d('Cache record ${record.key} is expired: $isCacheExpired');
      if (requestIds.length >= CacheRecord.kCacheRefreshMaximumEntryCount) {
        logger.i('Cache update request limit reached');
        break;
      }
    }

    if (requestIds.isEmpty) {
      logger.i('No cache update requests to process');
      return;
    }

    final HealthApiService healthApiService = await providerContainer.read(healthApiServiceProvider.future);
    await healthApiService.updateLocalCache(requestIds: requestIds);
    logger.i('Cache update request completed');
  }

  Future<File?> getSharedPrefsFile(String uid) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = '$kSharedPreferenceKeyPrefix$uid';
    final File prefsFile = File('$path/$fileName');

    if (!(await prefsFile.exists())) {
      logger.d('Creating cache file');
      prefsFile.createSync();
    }

    return prefsFile;
  }

  void add({
    required String key,
    required dynamic value,
    Duration? ttl,
    FlMeta? metadata,
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    if (value == null) {
      logger.w('Skipping cache update on $key due to null value');
      return;
    }

    CacheRecord? record = cacheData[key];

    final bool hasRecord = record != null;
    final FlMeta newMetadata = metadata ?? FlMeta.empty(key, '');
    final bool isDataPartial = newMetadata.isPartial;
    final int newFetchMillis = DateTime.tryParse(newMetadata.lastModifiedDate ?? '')?.millisecondsSinceEpoch ?? -1;

    final bool isOldDataPartial = record?.metadata.isPartial ?? true;
    final int oldFetchMillis = DateTime.tryParse(record?.metadata.lastModifiedDate ?? '')?.millisecondsSinceEpoch ?? -1;

    final bool shouldSkipOnDataIntegrity = isDataPartial && !isOldDataPartial;
    if (hasRecord && shouldSkipOnDataIntegrity) {
      logger.w('Skipping cache update on $key due to new data being incomplete');
      return;
    }

    if (hasRecord && newFetchMillis > 0 && newFetchMillis <= oldFetchMillis) {
      logger.w('Skipping cache update on $key due to new data being older or equal to existing data');
      return;
    }

    final CacheRecord newCacheRecord = CacheRecord(
      key: key,
      value: value,
      metadata: newMetadata,
    );

    cacheData[key] = newCacheRecord;
    processEvents(newCacheRecord, hasRecord ? CacheKeyUpdatedEventType.updated : CacheKeyUpdatedEventType.created);
  }

  bool any(Iterable<String> keys) {
    for (final String key in keys) {
      if (cacheData.containsKey(key)) {
        return true;
      }
    }

    return false;
  }

  Iterable<T> listAll<T>() {
    final List<T> results = [];
    for (final CacheRecord record in cacheData.values) {
      if (record.value is T) {
        results.add(record.value as T);
      }
    }

    return results;
  }

  bool contains(String key) {
    return cacheData.containsKey(key);
  }

  void remove(String key) {
    final CacheRecord? record = cacheData.remove(key);
    if (record == null) {
      return;
    }

    final EventBus eventBus = providerContainer.read(eventBusProvider);
    eventBus.fire(CacheKeyUpdatedEvent(key, CacheKeyUpdatedEventType.deleted, record));
  }

  void removeSet(Iterable<String> keys) {
    for (final String key in keys) {
      remove(key);
    }
  }

  T? get<T>(String? key) {
    if (key == null || key.isEmpty) {
      return null;
    }

    final CacheRecord? record = cacheData[key];
    final dynamic data = record?.value;
    return data != null && data is T ? data : null;
  }

  bool exists(String key) {
    return cacheData.containsKey(key);
  }

  List<T> list<T>(Iterable<String> ids) {
    final List<T> results = [];

    for (final String id in ids) {
      final T? result = get<T>(id);
      if (result != null) {
        results.add(result);
      }
    }

    return results;
  }

  void processEvents(CacheRecord record, CacheKeyUpdatedEventType eventType) {
    final Logger logger = providerContainer.read(loggerProvider);
    final EventBus eventBus = providerContainer.read(eventBusProvider);
    logger.i('Processing add events for cache record ${record.key}');

    final List<dynamic> events = [];

    events.add(CacheKeyUpdatedEvent(record.key, eventType, record.value));

    for (final dynamic event in events) {
      logger.d('Firing processed cache event: $event');
      eventBus.fire(event);
    }
  }
}
