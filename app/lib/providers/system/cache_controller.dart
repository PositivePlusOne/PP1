// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  // Not giving up the chance to use this key lol
  static const String kCacheSharedPrefsKeyPrefix = 'pp_cache_';

  Timer? scheduledJobCacheClear;
  Timer? scheduledJobCachePersist;

  @override
  CacheControllerState build() {
    return CacheControllerState.initialState();
  }

  void setupTimers() {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Setting up cache timers');

    scheduledJobCacheClear = Timer.periodic(
      kCacheCleanupFrequency,
      (Timer t) => clearOutdatedCacheEntries(),
    );

    scheduledJobCachePersist = Timer.periodic(
      kCacheCleanupPersist,
      (Timer t) => persistCache(),
    );
  }

  void clearCache() {
    state = state.copyWith(cacheData: {});
  }

  Future<void> persistCache() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Persisting cache data');

    final String jsonData = json.encode(state.cacheData);
    final File prefsFile = await getSharedPrefsFile();
    prefsFile.writeAsStringSync(jsonData);
  }

  Future<bool> restoreCache() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Restoring cache data');

    final File prefsFile = await getSharedPrefsFile();
    if (!prefsFile.existsSync()) {
      logger.d('No cache file found');
      return false;
    }

    final String jsonData = prefsFile.readAsStringSync();
    final Map<String, CacheRecord> cacheData = json.decode(jsonData);
    state = state.copyWith(cacheData: cacheData);
    return true;
  }

  Future<File> getSharedPrefsFile() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    final String userId = firebaseAuth.currentUser?.uid ?? '';
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final String fileName = '$kCacheSharedPrefsKeyPrefix$userId';
    final File prefsFile = File('$path/$fileName');

    if (!prefsFile.existsSync()) {
      logger.d('Creating cache file');
      prefsFile.createSync();
    }

    return prefsFile;
  }

  void clearOutdatedCacheEntries() {
    final Logger logger = ref.read(loggerProvider);
    final DateTime now = DateTime.now();
    final Map<String, CacheRecord> cacheData = state.cacheData;
    final List<String> keysToRemove = [];

    logger.d('Clearing outdated cache entries');
    cacheData.forEach((String key, CacheRecord record) {
      final Duration difference = now.difference(record.lastUpdatedAt!);
      if (difference > kCacheTTL) {
        logger.d('Removing outdated cache entry for $key');
        keysToRemove.add(key);
      }
    });

    for (var key in keysToRemove) {
      cacheData.remove(key);
    }

    state = state.copyWith(cacheData: cacheData);
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
