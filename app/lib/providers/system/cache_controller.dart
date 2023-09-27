// Dart imports:
import 'dart:async';
import 'dart:collection';
import 'dart:io';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/system/constants/cache_constants.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import '../../services/third_party.dart';

part 'cache_controller.freezed.dart';
part 'cache_controller.g.dart';

@freezed
class CacheRecord with _$CacheRecord {
  const factory CacheRecord({
    required String key,
    required Object value,
    required String createdBy,
    required String lastAccessedBy,
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
    required DateTime? expiresAt,
  }) = _CacheRecord;

  factory CacheRecord.fromJson(Map<String, Object?> json) => _$CacheRecordFromJson(json);
}

@Riverpod(keepAlive: true)
CacheController cacheController(CacheControllerRef ref) {
  return CacheController();
}

class CacheController {
  final HashMap<String, CacheRecord> cacheData = HashMap<String, CacheRecord>();

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
    bool overwrite = true,
    Duration? ttl,
  }) {
    final StackTrace trace = StackTrace.current;
    final String caller = trace.toString().split('#')[1].split(' ')[0];
    final Logger logger = providerContainer.read(loggerProvider);

    CacheRecord? record = cacheData[key];
    if (!overwrite && record != null) {
      logger.d('Not overwriting cache entry for $key from $caller');
      return;
    }

    final bool exists = record != null;
    record = record?.copyWith(
          lastUpdatedAt: DateTime.now(),
          lastAccessedBy: caller,
          value: value,
        ) ??
        CacheRecord(
          key: key,
          value: value,
          createdBy: caller,
          createdAt: DateTime.now(),
          lastUpdatedAt: DateTime.now(),
          lastAccessedBy: caller,
          expiresAt: ttl != null ? DateTime.now().add(ttl) : null,
        );

    cacheData[key] = record;
    processEvents(record, exists ? CacheKeyUpdatedEventType.updated : CacheKeyUpdatedEventType.created);
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

  T? get<T>(String key) {
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
